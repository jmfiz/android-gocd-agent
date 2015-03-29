FROM gocd/gocd-agent
MAINTAINER jmfiz <jmfiz@paradigmatecnologico.com>

#docker run -ti -e GO_SERVER=your.go.server.ip_or_host gocd/gocd-agent
# entrar en contenedor: docker exec -i -t CONTAINER-ID bash
# ver logs:   docker exec -i -t CONTAINER-ID tail -f /var/log/go-agent/go-agent.log

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

#android sdk 
RUN wget http://dl.google.com/android/android-sdk_r24.1.2-linux.tgz -O /opt/android-sdk_r24.1.2-linux.tgz
RUN tar xf /opt/android-sdk_r24.1.2-linux.tgz -C /opt/
ENV ANDROID_HOME /opt/android-sdk-linux
RUN chmod -R 777 /opt/android-sdk-linux

ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools

RUN mkdir -p /opt/tools
#COPY sdk_android.sh /opt/tools/android-accept-licenses.sh
ENV PATH ${PATH}:/opt/tools

RUN \
  apt-get update -y && \
  apt-get install -q -y expect

# Install Android tools
RUN echo y | android update sdk --filter platform,tool,platform-tool,extra,addon-google_apis-google-19,addon-google_apis_x86-google-19,build-tools-19.1.0 --no-ui -a


#RUN chmod 755 /opt/tools/android-accept-licenses.sh
#RUN ["/opt/tools/android-accept-licenses.sh", "android update sdk --filter tools --no-ui --all"]
RUN chmod -R 777 /opt/android-sdk-linux

#Start agent
CMD ["/sbin/my_init"]

