IF EXIST "C:\path\to\installed\file" (
    ECHO Already installed.
) ELSE (
    ECHO Installing...
    COPY "./git/hooks/pre-commit.sh" "./.git/hooks/pre-commit"
    ECHO Installation successful.
)