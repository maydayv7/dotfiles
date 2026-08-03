#! /usr/bin/env nix
#! nix shell nixpkgs#bash nixpkgs#cacert nixpkgs#coreutils nixpkgs#curl nixpkgs#jq nixpkgs#nix -c bash

set -euo pipefail

# Script to automatically update Minecraft Server Mods from Modrinth #

API="https://api.modrinth.com/v2"
COMMIT_PREFIX="chore(mc-server): Update"

# Locate mod metadata file
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATA="${MODS_FILE:-${SCRIPT_DIR}/../modules/games/mc-server/_mods.nix}"

if [[ ! -f "${DATA}" ]]
then
  echo "Mod metadata file not found: '${DATA}'"
  exit 1
fi

export CURL_CA_BUNDLE="${CURL_CA_BUNDLE:-$(nix eval --raw nixpkgs#cacert)/etc/ssl/certs/ca-bundle.crt}"

# Tracking
declare -a UNAVAILABLE=()
updated=0
uptodate=0

# Fetch latest version metadata for a project, target loader and game version
latest() {
  local id="${1}" loader="${2}" version="${3}"
  curl -s -G "${API}/project/${id}/version" \
    --data-urlencode "loaders=[\"${loader}\"]" \
    --data-urlencode "game_versions=[\"${version}\"]" \
    | jq -r '
        (sort_by(.date_published) | reverse | .[0]) as $v
        | if $v == null then empty
          else (($v.files | map(select(.primary)) + .)[0]) as $f
            | if $f == null then empty else "\($f.url)\t\($f.hashes.sha512)" end
          end
      ' 2>/dev/null || true
}

# Update every mod of a loader
process_loader() {
  local loader="${1}" json version count
  json="$(nix eval --json -f "${DATA}" "${loader}" 2>/dev/null || true)"

  if [[ -z "${json}" || "${json}" == "null" ]]
  then
    return 0
  fi

  version="$(echo "${json}" | jq -r '.version')"
  count="$(echo "${json}" | jq -r '.mods | length')"

  echo "==> Loader '${loader}' (Minecraft ${version}): ${count} mods"

  local i name id oldurl oldhash result newurl sha512 newhash
  for ((i = 0; i < count; i++))
  do
    name="$(echo "${json}" | jq -r ".mods[${i}].name")"
    id="$(echo "${json}" | jq -r ".mods[${i}].id")"
    oldurl="$(echo "${json}" | jq -r ".mods[${i}].url")"
    oldhash="$(echo "${json}" | jq -r ".mods[${i}].hash")"

    result="$(latest "${id}" "${loader}" "${version}")"
    newurl="$(echo "${result}" | cut -f1)"
    sha512="$(echo "${result}" | cut -f2)"

    if [[ -z "${result}" || "${newurl}" == "null" || -z "${newurl}" || "${sha512}" == "null" ]]
    then
      echo "  ✗ ${name}: no build for Minecraft ${version}"
      UNAVAILABLE+=("${name} (${loader} ${version})")
      continue
    fi

    if [[ "${newurl}" == "${oldurl}" ]]
    then
      echo "  = ${name}: up to date"
      ((uptodate += 1)) || true
      continue
    fi

    newhash="$(nix hash convert --hash-algo sha512 --to sri "${sha512}")"

    sed -i "s|${oldurl}|${newurl}|" "${DATA}"
    sed -i "s|${oldhash}|${newhash}|" "${DATA}"

    echo "  ↑ ${name}: updated"
    ((updated += 1)) || true
  done

  # Commit per loader
  if [[ "${COMMIT:-true}" == "true" ]]
  then
    git -C "$(dirname "${DATA}")" diff-index --quiet HEAD "${DATA}" 2>/dev/null || \
      git -C "$(dirname "${DATA}")" commit -q -n "${DATA}" \
        -m "${COMMIT_PREFIX} \`${loader}\` mods" || true
  fi
}

# Execution
echo "Checking for Mod Updates..."

# Iterate over every defined loader
mapfile -t LOADERS < <(nix eval --json -f "${DATA}" 2>/dev/null | jq -r 'keys[]')
for loader in "${LOADERS[@]}"
do
  process_loader "${loader}"
done

# Summary
echo
echo "Summary: ${updated} updated, ${uptodate} up to date, ${#UNAVAILABLE[@]} unavailable"
if (( ${#UNAVAILABLE[@]} > 0 ))
then
  echo "Could not update to the target Minecraft version:"
  for m in "${UNAVAILABLE[@]}"
  do
    echo "  - ${m}"
  done
fi
