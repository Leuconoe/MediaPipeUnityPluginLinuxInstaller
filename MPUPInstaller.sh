# 줄바꿈이 LF인지 확인할것.
# sudo chmod 777 MediaPipeUnityPluginLinuxInstaller.sh && sh MediaPipeUnityPluginLinuxInstaller.sh

# 기본 디렉토리에서 시작하는것을 전제로 함.
cd $HOME
####################
# 사전 준비
echo "************initalize************"
####################
# nodejs 설치를 위한 경로 추가
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
#apt 업데이트
sudo apt update && sudo apt upgrade -y && sudo apt dist-upgrade
# 필요한 라이브러리 설치 - 패키지 매니저, 빌드시스템과 JDK, 기타 라이브러리들
sudo apt install -y python3-pip python-is-python3 nodejs gcc g++ make cmake ninja-build wget unzip build-essential git zip adb openjdk-8-jdk openjdk-8-jre-headless mono-devel nuget
sudo nuget update -self

#install python 3.9
#만약 Could not read response to hello message from hook 어쩌구 하는 메시지가 나오면
#sudo rm -rf /etc/apt/apt.conf.d/20snapd.conf
#anaconda에서 3.9 사용하는법은 https://ieworld.tistory.com/21
if ! command -v python3.9 &> /dev/null
then
  echo "************install : python 3.9************"
  sudo apt install -y build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev wget
  if [ ! -d "Python-3.9.1" ];
  then
    wget https://www.python.org/ftp/python/3.9.1/Python-3.9.1.tgz
    tar -xvzf Python-3.9.1.tgz
    cd Python-3.9.1 && ./configure && sudo make altinstall
  fi
else
 echo "************skip : python 3.9 ************"
fi
cd $HOME


#opencv

#apt나 pip로 설치할경우 헤더파일을 못찾는 문제가 있으니 직접 빌드한다.
###4로 하면 빌드 스크립트의 경로를 수정해야하니 기본값인 3으로.
echo "************opencv************"
wget --no-clobber -O opencv.zip https://github.com/opencv/opencv/archive/refs/tags/3.4.14.zip
unzip -n opencv.zip
mv opencv-3.4.14 opencv
mkdir -p build && cd build
# 닌자가 멀티코어를 기본 지원한대서 닌자로
cmake -GNinja ../opencv
ninja && sudo ninja install
echo "opencv build finish"
#종료시 기본 폴더로
cd $HOME


# 파이썬 라이브러리 설치
echo "************python************"
pip3 install -U numpy
# bazel 관리하는 bazelisk 설치
sudo npm install -g @bazel/bazelisk

#ADK & NDK 설치 스크립트
if [ ! -d "opencv" ];
then
  wget --no-clobber https://raw.githubusercontent.com/google/mediapipe/master/setup_android_sdk_and_ndk.sh
fi
bash setup_android_sdk_and_ndk.sh  ~/Android/Sdk ~/Android/Ndk r21b
sh Android/Sdk/tools/bin/sdkmanager "build-tools;30.0.0" "platform-tools" "platforms;android-30"
#sh Android/Sdk/tools/bin/sdkmanager "build-tools" "platform-tools" "platforms"


#환경변수
echo "************env_val************"
# setup_android_sdk_and_ndk.sh 의 echo "Set android_ndk_repository and android_sdk_repository in WORKSPACE"
#이하부터 오류가 나는데 아직 해결을 못함.
# sudo vi ~./bashrc
export ANDROID_HOME=$HOME/Android/Sdk && export ANDROID_NDK_HOME=$HOME/Android/Ndk/android-ndk-r21b

#레파지토리 복사
echo "************git clone************"
git clone https://github.com/homuler/MediaPipeUnityPlugin.git
cd MediaPipeUnityPlugin
#git checkout (git describe --tags `git rev-list --tags --max-count=1`) -b latest

#내장된 라이브러리에 BooleanOptionalAction이 없다는 오류가 계속 나서 그 이슈 처리
wget --no-clobber https://raw.githubusercontent.com/python/cpython/master/Lib/argparse.py 

echo "************apt update************"
sudo apt update && sudo apt upgrade -y


#빌드
echo "************build************"
python3.9 build.py build --desktop cpu --android arm64 -v
