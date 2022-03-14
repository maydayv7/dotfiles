#! /usr/bin/env nix-shell
#! nix-shell -i bash

# Print Color Map #

for i in {0..255}
do
  print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}
done
