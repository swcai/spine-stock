#!/usr/bin/env bash

if [ $# -eq 1 ]; then
  if [ $1 = "heroku" ]; then
    hem build
    git add .
    git commit -as -m "deploy point"
    tsocks git push heroku master
  fi
  if [ $1 = "phonegap" ]; then
    hem build
    cp public/index.html phonegap/assets/www/
    cp public/application.js phonegap/assets/www/
    cp public/application.css phonegap/assets/www/
    pushd .
    cd phonegap
    ./cordova/run
    popd 
  fi
fi
