#! /usr/bin/env nix
#! nix shell nixpkgs#bash nixpkgs#coreutils -c bash

# Shows PCI Devices mapped to IOMMU Groups #

for group in $(find /sys/kernel/iommu_groups/* -maxdepth 0 -type d | sort -V)
do
  echo "IOMMU Group ""${group##*/}"":"
  for device in "$group"/devices/*
  do
    echo -e "\t$(lspci -nns "${device##*/}")"
  done
done
