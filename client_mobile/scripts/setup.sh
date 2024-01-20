#!/bin/bash

fvm flutter pub get

fvm flutter pub run build_runner build --delete-conflicting-outputs

#if [ "$(uname)" == "Darwin" ]; then
#  cd ios
#  pod install
#  cd ..
#fi
