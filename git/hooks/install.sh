git_path=$(git rev-parse --show-toplevel)
cp ./git/hooks/pre-commit.sh ${git_path}/hooks/pre-commit