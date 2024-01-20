FROM fedora:latest
RUN dnf update -y && dnf install -y curl git unzip xz zip libX11-devel mesa-libGLU-devel java-1.8.0-openjdk-devel java-11-openjdk-devel wget
ENV JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk
ENV PATH $JAVA_HOME/bin:$PATH
RUN mkdir -p /Android/sdk
ENV ANDROID_SDK_ROOT /Android/sdk
RUN mkdir -p .android && touch .android/repositories.cfg
RUN wget -O sdk-tools.zip https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip
RUN unzip sdk-tools.zip && rm sdk-tools.zip
RUN mv tools /Android/sdk/tools
RUN cd /Android/sdk/tools/bin && ./sdkmanager --update
RUN cd /Android/sdk/tools/bin && yes | ./sdkmanager --licenses
RUN cd /Android/sdk/tools/bin && ./sdkmanager "build-tools;29.0.2" "platform-tools" "platforms;android-29" "sources;android-29"
ENV PATH "$PATH:/Android/sdk/platform-tools"
RUN git clone https://github.com/flutter/flutter.git /flutter
WORKDIR /flutter
RUN git checkout 3.16.0
ENV PATH "$PATH:/flutter/bin"
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk
ENV PATH $JAVA_HOME/bin:$PATH
WORKDIR /usr/src/app
COPY . .
ENV ANDROID_HOME /Android/sdk
RUN flutter pub get
#RUN flutter pub run build_runner build --delete-conflicting-outputs
RUN chown root -R .
RUN flutter clean
RUN flutter build apk --split-per-abi
RUN mkdir -p /var/apk && cp build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk /var/apk/client.apk
CMD ["sleep", "infinity"]
