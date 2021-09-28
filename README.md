# MediaPipeUnityPluginLinuxInstaller

Environment setting shell script to build [MediaPipeUnityPlugin](https://github.com/homuler/MediaPipeUnityPlugin) in Linux.
This is a script created for environments where wsl 2 & docker cannot be used. (ex. using Android emulator)
Tested on v0.7.0 && WSL Ubuntu 20.04.

# how to install?
paste and run it:

cd $home && curl -O https://raw.githubusercontent.com/Leuconoe/MediaPipeUnityPluginLinuxInstaller/main/MPUPInstaller.sh && sudo chmod 777 MPUPInstaller.sh && sh MPUPInstaller.sh

# caution

Since it is only a script to build MediaPipeUnityPlugin, if wsl is already used for various purposes, the operation cannot be guaranteed. Please use docker as recommended by the original author.

# credits

Thanks to @homuler
