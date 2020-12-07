#!/usr/bin/env bash

# Check Docker

if [[ -z "$(command -v docker)" ]]; then
    echo "Docker not found!"
    echo "Exiting..."
    exit 1
fi

# Color
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
NC="\033[0m"

# Variables
GH_REF="github.com/crazyuploader/Bash.git"

# Run shfmt
docker run --rm -v "${PWD}":/mnt -w /mnt mvdan/shfmt -w .

# Making Shell Scripts Executables
LIST_FILES="$(find . -path ./.git -prune -o -name '*.sh' -print | sed 's|^./||' | sort)"
for file in ${LIST_FILES}; do
    echo "chmod +x ${file}"
done

git config user.email "41898282+github-actions[bot]@users.noreply.github.com"
git config user.name "github-actions"

echo ""
if [[ -z $(git status --porcelain) ]]; then
    echo -e "${GREEN} Nothing to commit.${NC}"
else
    git add .
    git commit -m "Run shfmt & Make Shell Scripts Executable"
    git push https://crazyuploader:"${GITHUB_TOKEN}"@"${GH_REF}" HEAD:"${GITHUB_REF}"
    echo -e "${YELLOW}Updates Pushed to https://${GH_REF}"
fi
