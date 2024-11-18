config_author="$(git config user.email)"
config_comitter=$(git var GIT_AUTHOR_IDENT)

if [[ "$config_author" =~ "capgemini.com"  ||  "$config_comitter" =~ "capgemini.com" ]]; then
  echo "¡Alto ahí gañán! Las cuentas corporativas no están permitidas."
  exit 1
fi