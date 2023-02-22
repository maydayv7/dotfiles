#! /usr/bin/env nix-shell
#! nix-shell -i bash -p coreutils jq
# shellcheck shell=bash
set -euo pipefail

# Script to Automatically Update Packages #

# Preset Variables
unset NIX_PATH
fakeHash="0000000000000000000000000000000000000000000000000000000000000000"

# Logic
update() {
  if [[ "${1:-""}" != "" ]]
  then
    t="$(mktemp)"; trap "rm ${t}" EXIT;
    m="$(mktemp)"; trap "rm ${m}" EXIT;
    l="$(mktemp)"; trap "rm ${l}" EXIT;
    pkg="${1}"
    metadata="${pkg}/metadata.nix"
    pkgname="$(basename "${pkg}")"

    if [[ ! -f "${pkg}/metadata.nix" ]]
    then
      exit 0
    fi

    # Extraction
    # Include ${pkg}/metadata.nix according to spec
    nix eval -f "${metadata}" --json > "${t}" 2>/dev/null
    rev="$(cat "${t}" | jq -r .rev)"
    sha256="$(cat "${t}" | jq -r .sha256)"
    repo="$(cat "${t}" | jq -r .repo)"
    branch="$(cat "${t}" | jq -r .branch)"             # Optional
    release="$(cat "${t}" | jq -r .release)"           # Optional
    cargoSha256="$(cat "${t}" | jq -r .cargoSha256)"   # Optional
    vendorSha256="$(cat "${t}" | jq -r .vendorSha256)" # Optional
    skip="$(cat "${t}" | jq -r .skip)"                 # Optional
    upattr="$(cat "${t}" | jq -r .upattr)";            # Optional
    if [[ "${upattr}" == "null" ]]
    then
      upattr="${pkgname}"
    fi

    if [[ "${skip}" == "true" ]]
    then
      echo "Skipping (Pinned to '${rev}')"
      exit 0
    fi

    # Latest Revision
    if [[ "${repo}" != "null" ]]
    then
      if [[ "${release}" == "true" ]]
      then
        newrev="$(git ls-remote --refs --sort="version:refname" --tags ${repo} | cut -d/ -f3-|tail -n1)"
      else
        if [ -z "${branch}" ]
        then
          branch="main"
        fi
        newrev="$(git ls-remote "${repo}" "refs/heads/${branch}" | awk '{ print $1}')"
      fi
    fi

    # Early Quit
    if [[ "${rev}" == "${newrev}" && "${FORCE_RECHECK:-""}" != "true" ]]
    then
      echo "'${pkgname}' Already Up to Date ('${rev}')"
      exit 0
    fi

    echo "Updating '${pkgname}'..."
    echo "Bumping '${rev}' ---> '${newrev}'"

    # Sha256
    sed -i "s|${rev}|${newrev}|" "${metadata}"
    sed -i "s|${sha256}|${fakeHash}|" "${metadata}"
    nix build --no-link "..#${upattr}" &> "${l}" || true
    newsha256="$(cat "${l}" | grep 'got:' | cut -d':' -f2 | tr -d ' ' || true)"
    if [[ "${newsha256}" == "sha256" ]]
    then
      newsha256="$(cat "${l}" | grep 'got:' | cut -d':' -f3 | tr -d ' ' || true)"
    fi

    newsha256="$(nix hash to-sri --type sha256 "${newsha256}")"
    sed -i "s|${fakeHash}|${newsha256}|" "${metadata}"

    # CargoSha256
    if [[ "${cargoSha256}" != "null" ]]
    then
      sed -i "s|${cargoSha256}|${fakeHash}|" "${metadata}"
      nix build --no-link "..#${upattr}" &> "${l}" || true
      newcargoSha256="$(cat "${l}" | grep 'got:' | cut -d':' -f2 | tr -d ' ' || true)"
      if [[ "${newcargoSha256}" == "sha256" ]]
        then
        newcargoSha256="$(cat "${l}" | grep 'got:' | cut -d':' -f3 | tr -d ' ' || true)"
      fi
      newcargoSha256="$(nix hash to-sri --type sha256 "${newcargoSha256}")"
      sed -i "s|${fakeHash}|${newcargoSha256}|" "${metadata}"
    fi

    # VendorSha256
    if [[ "${vendorSha256}" != "null" ]]
    then
      sed -i "s|${vendorSha256}|${fakeHash}|" "${metadata}"
      nix build --no-link "..#${upattr}" &> "${l}" || true
      newvendorSha256="$(cat "${l}" | grep 'got:' | cut -d':' -f2 | tr -d ' ' || true)"
      if [[ "${newvendorSha256}" == "sha256" ]]
      then
        newvendorSha256="$(cat "${l}" | grep 'got:' | cut -d':' -f3 | tr -d ' ' || true)"
      fi
      newvendorSha256="$(nix hash to-sri --type sha256 "${newvendorSha256}")"
      sed -i "s|${fakeHash}|${newvendorSha256}|" "${metadata}"
    fi

    # Commit
    prefix="chore(packages):"
    git diff-index --quiet HEAD "${pkg}" || \
      git commit -q -n "${pkg}" -m "${prefix} ${pkgname} (${rev} ---> ${newrev})"
    echo -e "Finished Updating '${pkgname}' ('${rev}' ---> '${newrev}')\n"
    exit 0
  fi
}
export -f update

# Execution
main() { 
  echo "Checking for Updates..."
}

while true
do
  (main)
  find . -mindepth 1 -maxdepth 1 -type d -exec bash -c 'update "$0"' {} \;
  res=$?
  if (( res != 255 ))
  then
    break
  fi
done
