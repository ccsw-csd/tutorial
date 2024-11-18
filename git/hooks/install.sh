if [ -e ./git/hooks/installed ]
then
    echo "Hooks already installed!!"
else
    echo "Installing hooks..."
    cp ./git/hooks/pre-commit.sh ./.git/hooks/pre-commit
    touch ./git/hooks/installed
    echo "Hooks installed!!"
fi