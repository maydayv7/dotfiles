#! /usr/bin/env nix
#! nix shell nixpkgs#bash nixpkgs#coreutils nixpkgs#jq -c bash
# shellcheck shell=bash
unset NIX_PATH
set -euo pipefail

COMMIT_PREFIX="chore(packages): Update"

# Script to Automatically Update Packages #
# Logic
update() {
  if [[ "${1:-""}" != "" ]]
  then
    t1="$(mktemp)"; trap 'rm ${t1}' EXIT;
    t2="$(mktemp)"; trap 'rm ${t2}' EXIT;
    pkg="${1}"
    metadata="${pkg}/metadata.nix"
    pkgname="$(basename "${pkg}")"

    if [[ ! -f "${pkg}/metadata.nix" ]]
    then
      exit 0
    fi

    # Extraction
    # Include ${pkg}/metadata.nix according to spec
    nix eval -f "${metadata}" --json > "${t1}" 2>/dev/null
    rev="$(cat "${t1}" | jq -r .rev)"
    sha256="$(cat "${t1}" | jq -r .sha256)"
    repo="$(cat "${t1}" | jq -r .repo)"
    branch="$(cat "${t1}" | jq -r .branch)"             # Optional
    release="$(cat "${t1}" | jq -r .release)"           # Optional
    cargoHash="$(cat "${t1}" | jq -r .cargoHash)"   # Optional
    vendorHash="$(cat "${t1}" | jq -r .vendorHash)" # Optional
    skip="$(cat "${t1}" | jq -r .skip)"                 # Optional
    upattr="$(cat "${t1}" | jq -r .upattr)";            # Optional
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
        newrev="$(git ls-remote --refs --sort="version:refname" --tags "${repo}" | cut -d/ -f3- | tail -n1)"
      else
        if [[ "${branch}" == "null" ]]
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

    # SHA
    fakeHash="sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
    sed -i "s|${rev}|${newrev}|" "${metadata}"
    sed -i "s|${sha256}|${fakeHash}|" "${metadata}"
    nix build --no-link "..#${upattr}" &> "${t2}" || true
    newHash="$(cat "${t2}" | grep 'got:' | cut -d':' -f2 | tr -d ' ' || true)"
    if [[ "${newHash}" == "sha256" ]]
    then
      newHash="$(cat "${t2}" | grep 'got:' | cut -d':' -f3 | tr -d ' ' || true)"
    fi

    newHash="$(nix hash convert --hash-algo sha256 "${newHash}")"
    sed -i "s|${fakeHash}|${newHash}|" "${metadata}"

    # Cargo SHA
    if [[ "${cargoHash}" != "null" ]]
    then
      sed -i "s|${cargoHash}|${fakeHash}|" "${metadata}"
      nix build --no-link "..#${upattr}" &> "${t2}" || true
      newcargoHash="$(cat "${t2}" | grep 'got:' | cut -d':' -f2 | tr -d ' ' || true)"
      if [[ "${newcargoHash}" == "sha256" ]]
        then
        newcargoHash="$(cat "${t2}" | grep 'got:' | cut -d':' -f3 | tr -d ' ' || true)"
      fi
      newcargoHash="$(nix hash convert --hash-algo sha256 "${newcargoHash}")"
      sed -i "s|${fakeHash}|${newcargoHash}|" "${metadata}"
    fi

    # Vendor SHA
    if [[ "${vendorHash}" != "null" ]]
    then
      sed -i "s|${vendorHash}|${fakeHash}|" "${metadata}"
      nix build --no-link "..#${upattr}" &> "${t2}" || true
      newvendorHash="$(cat "${t2}" | grep 'got:' | cut -d':' -f2 | tr -d ' ' || true)"
      if [[ "${newvendorHash}" == "sha256" ]]
      then
        newvendorHash="$(cat "${t2}" | grep 'got:' | cut -d':' -f3 | tr -d ' ' || true)"
      fi
      newvendorHash="$(nix hash convert --hash-algo sha256 "${newvendorHash}")"
      sed -i "s|${fakeHash}|${newvendorHash}|" "${metadata}"
    fi

    # Commit
    git diff-index --quiet HEAD "${pkg}" || \
      git commit -q -n "${pkg}" -m "${COMMIT_PREFIX} \`${pkgname}\`" -m "${rev} ---> ${newrev}"
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
