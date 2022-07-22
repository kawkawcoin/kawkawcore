 #!/usr/bin/env bash

 # Execute this file to install the kawkaw cli tools into your path on OS X

 CURRENT_LOC="$( cd "$(dirname "$0")" ; pwd -P )"
 LOCATION=${CURRENT_LOC%Kawkaw-Qt.app*}

 # Ensure that the directory to symlink to exists
 sudo mkdir -p /usr/local/bin

 # Create symlinks to the cli tools
 sudo ln -s ${LOCATION}/Kawkaw-Qt.app/Contents/MacOS/kawkawd /usr/local/bin/kawkawd
 sudo ln -s ${LOCATION}/Kawkaw-Qt.app/Contents/MacOS/kawkaw-cli /usr/local/bin/kawkaw-cli
