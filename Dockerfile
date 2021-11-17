# Read VNC pw from environment
ARG ARG_VNC_PW=$VNC_PW
FROM accetto/ubuntu-vnc-xfce-firefox-g3:latest

# Install packages and additional fonts
USER root
RUN apt-get update
# Accept EULA for Microsoft fonts
RUN echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections
RUN apt-get install -y git default-jre vim zeal zip ffmpeg ttf-mscorefonts-installer

# Install Python
RUN apt -y upgrade
RUN apt install -y python3-pip
RUN apt install -y build-essential libssl-dev libffi-dev python3-dev

# Install additional fonts
RUN fc-cache -f

# Install Docker Engine
RUN apt-get update
RUN apt-get install -y ca-certificates curl gnupg lsb-release
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN apt-get update
RUN apt-get install -y docker-ce docker-ce-cli containerd.io

# Install Docker Compose
RUN curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

# Set timezone to Europe/Berlin
RUN rm -rf /etc/localtime
RUN ln -s /usr/share/zoneinfo/Europe/Berlin /etc/localtime

# Install Stretchly
RUN wget https://github.com/hovancik/stretchly/releases/download/v1.7.0/Stretchly_1.7.0_amd64.deb
RUN apt-get install -y libxss-dev libgbm-dev libxss1 libappindicator3-1 libsecret-1-0
RUN dpkg -i Stretchly_*.deb
RUN rm Stretchly_*.deb

# Install DBeaver CE
RUN wget https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb
RUN dpkg -i dbeaver-ce_*.deb
RUN rm dbeaver-ce_*.deb

# Install Beekeeper Studio
RUN wget --quiet -O - https://deb.beekeeperstudio.io/beekeeper.key | sudo apt-key add -
RUN echo "deb https://deb.beekeeperstudio.io stable main" | sudo tee /etc/apt/sources.list.d/beekeeper-studio-app.list
RUN apt-get update
RUN apt-get install -y beekeeper-studio

# Install FromScratch
RUN wget https://github.com/Kilian/fromscratch/releases/download/v1.4.3/FromScratch_1.4.3_amd64.deb
RUN apt-get install -y gconf2 gconf-service libgconf-2-4 gconf2-common libdbusmenu-gtk4  gconf-service-backend libappindicator1
RUN dpkg -i FromScratch_*.deb
RUN rm FromScratch_*.deb

# Install PyCharm
RUN wget https://download.jetbrains.com/python/pycharm-community-2021.2.3.tar.gz
RUN tar xzf xzf pycharm-*.tar.gz -C /opt/pycharm
RUN ln -s /opt/pycharm/pycharm-community-*/bin/pycharm.sh /usr/local/bin/pycharm
RUN chmod a+x getopts /opt/pycharm/pycharm-community-*/bin/pycharm.sh

# Switch to VNC user
USER headless
