authors="$(git show -s --format='%ae' HEAD)"

if [[ "$authors" =~ "capgemini.com" ]]; then
  echo "¡Alto ahí gañán! Las cuentas corporativas no están permitidas."
  exit 1
fi