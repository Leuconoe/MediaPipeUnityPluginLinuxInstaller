# MediaPipeUnityPluginLinuxInstaller

Environment setting shell script to build [MediaPipeUnityPlugin](https://github.com/homuler/MediaPipeUnityPlugin) in Linux.
Tested on WSL Ubuntu 20.04.

# how to install?
paste and run it:

cd $home && sudo apt install wget && wget https://raw.githubusercontent.com/Leuconoe/MediaPipeUnityPluginLinuxInstaller/main/MediaPipeUnityPluginLinuxInstaller.sh && sudo chmod 777 MediaPipeUnityPluginLinuxInstaller.sh && sh MediaPipeUnityPluginLinuxInstaller.sh

# caution

Since it is only a script to build MediaPipeUnityPlugin, if wsl is already used for various purposes, the operation cannot be guaranteed. Please use docker as recommended by the original author.

# credits

Thanks to @homuler.
