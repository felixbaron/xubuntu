# TODO: use local pwd
# Read VNC pw from environment
ARG ARG_VNC_PW=$VNC_PW
FROM accetto/ubuntu-vnc-xfce-firefox-g3:latest

# Install packages and additional fonts
USER root
RUN apt-get update
# Accept EULA for Microsoft fonts
RUN echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections
RUN apt-get install -y git default-jre vim zeal zip ffmpeg ttf-mscorefonts-installer

# Install Python
RUN apt -y upgrade
RUN apt install -y python3-pip python-is-python3
RUN apt install -y build-essential libssl-dev libffi-dev libpq-dev python3-dev
RUN python -m pip install --upgrade pip

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

# Use Git store to save tokens
RUN git config --global credential.helper store

# Set timezone to Europe/Berlin
RUN rm -rf /etc/localtime
RUN ln -s /usr/share/zoneinfo/Europe/Berlin /etc/localtime

# Install Stretchly
RUN wget https://github.com/hovancik/stretchly/releases/download/v1.7.0/Stretchly_1.7.0_amd64.deb
RUN apt-get install -y libappindicator1 libxss-dev; exit 0;
RUN apt-get -y -f install
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
RUN apt-get install -y gconf2; exit 0;
RUN apt-get -y -f install
RUN dpkg -i FromScratch_*.deb
RUN rm FromScratch_*.deb

# Install PyCharm
RUN wget https://download.jetbrains.com/python/pycharm-community-2021.2.3.tar.gz
RUN mkdir /opt/pycharm
RUN tar xzf pycharm-*.tar.gz -C /opt/pycharm
RUN ln -s /opt/pycharm/pycharm-community-*/bin/pycharm.sh /usr/local/bin/pycharm
RUN chmod a+x /opt/pycharm/pycharm-community-*/bin/pycharm.sh

# Install Discord
RUN apt-get install -y gdebi-core
RUN wget -O discord.deb "https://discordapp.com/api/download?platform=linux&format=deb"
RUN gdebi discord.deb
RUN rm discord.deb

# Copy home folder
WORKDIR /home
COPY home ./

# Switch to VNC user
USER headless
