if [ -d /usr/local/Cellar/android-sdk ]; then
  export ANDROID_SDK_ROOT=/usr/local/Cellar/android-sdk/$(ls -1 /usr/local/Cellar/android-sdk/ | sort -r | head -n 1)
  export ANDROID_HOME=$ANDROID_SDK_ROOT
  export PATH=$PATH:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools
fi
