#!/usr/bin/env -S bash -e -o pipefail -O inherit_errexit

for i in 39 {30..37} {90..97} 0 ; do
  echo -e '\033[0m\033['"$i"'mCOLORE \\033['"$i"'m\033[1;'"$i"'m; BOLD \\033[1;'"$i"'m'
done
