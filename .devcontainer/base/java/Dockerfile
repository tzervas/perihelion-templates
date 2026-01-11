FROM mcr.microsoft.com/devcontainers/java:21-bullseye

# Install additional OS packages
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
        git-core \
        curl \
        gpg \
        openssh-client \
        vim \
        unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Maven
ARG MAVEN_VERSION=3.9.6
RUN curl -fsSL https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
    | tar -xzC /usr/share \
    && ln -s /usr/share/apache-maven-${MAVEN_VERSION}/bin/mvn /usr/bin/mvn

# Set up Git configuration for GPG signing
RUN git config --system commit.gpgsign true \
    && git config --system gpg.program gpg

# Create non-root user
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Switch to non-root user
USER $USERNAME

# Install JDK tools and security updates
RUN sudo update-alternatives --set java /usr/lib/jvm/temurin-21-jdk-amd64/bin/java \
    && sudo update-alternatives --set javac /usr/lib/jvm/temurin-21-jdk-amd64/bin/javac \
    && java -version

# Setup Maven configuration
RUN mkdir -p /home/$USERNAME/.m2 \
    && echo '<settings><localRepository>/home/'$USERNAME'/.m2/repository</localRepository></settings>' > /home/$USERNAME/.m2/settings.xml

# Set environment variables
ENV JAVA_HOME=/usr/lib/jvm/temurin-21-jdk-amd64 \
    MAVEN_HOME=/usr/share/apache-maven-${MAVEN_VERSION} \
    MAVEN_CONFIG=/home/$USERNAME/.m2

# Setup working directory
WORKDIR /workspace

# Label the image
LABEL org.opencontainers.image.source=https://github.com/tzervas/perihelion-templates
LABEL org.opencontainers.image.description="Base Java development container image for Perihelion templates"
LABEL org.opencontainers.image.licenses=MIT
