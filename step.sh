#!/bin/bash
set -ex

echo "Installing Shorebird CLI"
# This installs shorebird into ~/.shorebird/bin and adds it to your PATH. 
# It also installs a copy of Flutter and Dart inside ~/.shorebird/bin/cache/flutter. 
# The copy of Flutter is slightly modified to add Shorebird code push and is not 
# intended to be added to your PATH. You can continue to use the versions of 
# Flutter and Dart you already have installed.
curl --proto '=https' --tlsv1.2 https://raw.githubusercontent.com/shorebirdtech/install/main/install.sh -sSf | bash 

# Replace PATH to include Shorebird
envman add --key PATH --value '/Users/vagrant/.shorebird/bin:$PATH'

# Echo path to console
envman run bash -c 'echo "Modified path: $PATH"'

export PATH="$(echo $HOME)/.shorebird/bin:$PATH"

# Get Flutter version from FVM or Flutter
extracted_flutter_version="-1"
which fvm
if [ $? -eq 0 ]; then
    fvm_flutter_version=$(fvm flutter --version)
    extracted_flutter_version=$(echo "$fvm_flutter_version" | head -n 1 | awk '{print $2}')
    echo "FVM Flutter Version: $extracted_flutter_version"
else
    flutter_version=$(flutter --version)
    extracted_flutter_version=$(echo "$flutter_version" | head -n 1 | awk '{print $2}')
    echo "Flutter Version: $extracted_flutter_version"
fi

# Use parsed flutter version to sync Shorebird to installed Flutter
if [ $extracted_flutter_version != "-1" ]; then
    shorebird flutter versions use $extracted_flutter_version
    envman add --key SHOREBIRD_FLUTTER_VERSION --value $extracted_flutter_version
else 
    echo "Flutter not detected, skipping Shorebird Sync."
fi

# --- Exit codes:
# The exit code of your Step is very important. If you return
#  with a 0 exit code `bitrise` will register your Step as "successful".
# Any non zero exit code will be registered as "failed" by `bitrise`.
exit 0 