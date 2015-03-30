FROM gocd/gocd-agent
MAINTAINER jmfiz <jmfiz@paradigmatecnologico.com>

#utils & troubleshooting sdk
RUN \
	apt-get update && apt-get upgrade -y && \
	apt-get install -q -y wget && \
	dpkg --add-architecture i386 && \
	apt-get update -y && \
	apt-get install -y libncurses5:i386 libstdc++6:i386 zlib1g:i386

# Install Java.
RUN \
  apt-get update -y && \
  apt-get install -y openjdk-7-jdk && \
  rm -rf /var/lib/apt/lists/*

# Define working directory.
WORKDIR /data

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64

#gradle
RUN \
  add-apt-repository ppa:cwchien/gradle -y && \
  apt-get update -y && \
  apt-get install gradle -y

#android sdk 
RUN wget http://dl.google.com/android/android-sdk_r24.1.2-linux.tgz -O /opt/android-sdk_r24.1.2-linux.tgz
RUN tar xf /opt/android-sdk_r24.1.2-linux.tgz -C /opt/
ENV ANDROID_HOME /opt/android-sdk-linux
RUN chmod -R 777 /opt/android-sdk-linux

ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools

RUN mkdir -p /opt/tools
ENV PATH ${PATH}:/opt/tools

# Install Android tools
RUN echo y | android update sdk --filter tools,platform-tools,build-tools-22.0.1,build-tools-19.1.0,build-tools-19.0.1,android-19,sys-img-armeabi-v7a-android-19,sys-img-x86-android-19,addon-google_apis_x86-google-19,addon-google_apis-google-19,extra-google-google_play_services,extra-google-m2repository --no-ui -a
RUN chmod -R 777 /opt/android-sdk-linux

#Start agent
CMD ["/sbin/my_init"]
