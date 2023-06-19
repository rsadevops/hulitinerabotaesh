#!/bin/bash

#Set Git user identity
git config --global user.email "${GITHUB_ACTOR}@users.noreply.github.com"
git config --global user.name "${GITHUB_ACTOR}"

#Determine version
commit_message=$(git log --format=%s -n 1)

if echo "$commit_message" | grep -qE '^major:'; then
  new_version=$(npm --no-git-tag-version version major --allow-same-version)

elif echo "$commit_message" | grep -qE '^minor:'; then
  new_version=$(npm --no-git-tag-version version minor --allow-same-version)

elif echo "$commit_message" | grep -qE '^patch:'; then
  new_version=$(npm --no-git-tag-version version patch --allow-same-version)

elif echo "$commit_message" | grep -qE '^manual:'; then
  new_version=$(node -p "require('./package.json').version")
else
  new_version=$(npm --no-git-tag-version version prerelease --allow-same-version)
fi

#Update package.json
echo "new_version=$new_version" >> $GITHUB_OUTPUT

npm --no-git-tag-version version $new_version --allow-same-version

git add package.json
git commit -m "Bump version to $new_version"
git push "https://github.com/${{ github.repository }}" HEAD:refs/heads/main --quiet --force --follow-tags -u "${{ secrets.REGISTRY_PASSWORD }}"

