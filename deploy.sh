#!/usr/bin/env bash

hem build
git add .
git commit -as -m "deploy point"
tsocks git push heroku master
