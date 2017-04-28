#!/usr/bin/env bash
git add .
git commit -m "$2"
npm version $1
npm publish
git push --tags
