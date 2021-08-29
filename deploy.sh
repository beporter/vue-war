#!/usr/bin/env sh

# abort on errors
set -e

# build
npm run build

# navigate into the build output directory
cd dist

git init
git add -A
git commit -m 'Deploy to GH Pages'
git push -f git@github.com:beporter/vue-war.git main:gh-pages

cd -
