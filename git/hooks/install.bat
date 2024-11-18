FOR /F "usebackq delims=" %%G IN (`git rev-parse --show-toplevel`) DO SET "GIT_PATH=%%G"
COPY "./pre-commit.sh" "%GIT_PATH%/hooks/pre-commit"