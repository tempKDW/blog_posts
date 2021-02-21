#!/bin/bash

git add archetypes/ content/ config.yml
git commit
git push origin main

hugo

cd public
git add .
git commit
git push origin main

cd ..