#!/usr/bin/env bash

SCRIPTFILE=$(readlink -f "$0")
BASEDIR=$(dirname "$SCRIPTFILE")
BRICKSDIR=$(readlink -f "$BASEDIR/../../bricks")

# clear directory
ls -A1 | xargs rm -rf

# init mason and bricks
mason cache clear
mason init
mason add scaffolding --path $BRICKSDIR/scaffolding
mason add scaffolding_test --path $BRICKSDIR/scaffolding_test
mason add scaffolding_home --path $BRICKSDIR/scaffolding_home
mason add scaffolding_home_test --path $BRICKSDIR/scaffolding_home_test

# make with config.json
mason make scaffolding -c $BASEDIR/config.json
mason make scaffolding_home -c $BASEDIR/config.json
mason make scaffolding_test -c $BASEDIR/config.json
mason make scaffolding_home_test -c $BASEDIR/config.json

# add empty flutter project
flutter create . --template=skeleton
flutter pub add equatable uuid flutter_bloc
flutter pub add bloc_test mocktail --dev
flutter test --coverage
dart $BASEDIR/coverage.dart ${PWD}/coverage/lcov.info