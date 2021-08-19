#!/bin/bash

# Setup flutter
FLUTTER=`which flutter`
if [ $? -eq 0 ]
then
  # Flutter is installed
  FLUTTER=`which flutter`
else
  # Get flutter
  git clone https://github.com/flutter/flutter.git
  FLUTTER=flutter/bin/flutter
fi

# Configure flutter
FLUTTER_CHANNEL=beta
FLUTTER_VERSION=v1.17.0
$FLUTTER channel $FLUTTER_CHANNEL
$FLUTTER version $FLUTTER_VERSION
$FLUTTER config --enable-web

# Setup dart
DART=`echo $FLUTTER | sed 's/flutter$/cache\/dart-sdk\/bin\/dart/'`
echo $DART

# e.g. Run a dart command
$DART foo/bar.dart

# Build flutter for web
$FLUTTER build web

echo "OK"