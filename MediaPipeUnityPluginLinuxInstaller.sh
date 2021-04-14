# 줄바꿈이 LF인지 확인할것.
# sudo chmod 777 MediaPipeUnityPluginLinuxInstaller.sh && sh MediaPipeUnityPluginLinuxInstaller.sh

# 기본 디렉토리에서 시작하는것을 전제로 함.
cd $HOME
####################
# 사전 준비
####################
# nodejs 설치를 위한 경로 추가
curl -sL https://deb.nodesource.com/setup_15.x | sudo -E bash -
#apt 업데이트
sudo apt update && sudo apt upgrade -y
# 필요한 라이브러리 설치 - 패키지 매니저, 빌드시스템과 JDK, 기타 라이브러리들
sudo apt install -y python3-pip python-is-python3 nodejs gcc g++ make cmake ninja-build wget unzip build-essential git zip adb openjdk-8-jdk openjdk-8-jre-headless mono-devel nuget
sudo nuget update -self

#opencv
#apt나 pip로 설치할경우 헤더파일을 못찾는 문제가 있으니 직접 빌드한다.
###4로 하면 빌드 스크립트의 경로를 수정해야하니 기본값인 3으로.
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
pip3 install -U numpy
# bazel 관리하는 bazelisk 설치
sudo npm install -g @bazel/bazelisk

#ADK & NDK 설치 스크립트
wget --no-clobber https://raw.githubusercontent.com/google/mediapipe/master/setup_android_sdk_and_ndk.sh
bash setup_android_sdk_and_ndk.sh  ~/Android/Sdk ~/Android/Ndk r21b

#환경변수
# setup_android_sdk_and_ndk.sh 의 echo "Set android_ndk_repository and android_sdk_repository in WORKSPACE"
#이하부터 오류가 나는데 아직 해결을 못함.
# sudo vi ~./bashrc
export ANDROID_HOME=$HOME/Android/Sdk
export ANDROID_NDK_HOME=$HOME/Android/Ndk/android-ndk-r21b

#레파지토리 복사
git clone https://github.com/homuler/MediaPipeUnityPlugin.git
cd MediaPipeUnityPlugin
#git checkout (git describe --tags `git rev-list --tags --max-count=1`) -b latest

#내장된 라이브러리에 BooleanOptionalAction이 없다는 오류가 계속 나서 그 이슈 처리
wget --no-clobber https://raw.githubusercontent.com/python/cpython/master/Lib/argparse.py 

sudo apt update && sudo apt upgrade -y

#빌드
python build.py build --desktop cpu --android arm64 -v
