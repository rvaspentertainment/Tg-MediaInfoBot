# Use the latest Ubuntu base image
FROM ubuntu:latest

# Set environment variables for locale and timezone
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8 LANGUAGE=en_US:en TZ=Asia/Kolkata

# Set the working directory inside the container
WORKDIR /usr/src/app

# Update package lists and install necessary packages
RUN apt-get update && apt-get install -y \
    python3-pip \
    git \
    libcurl3-gnutls \
    libmms0 \
    libzen0v5 \
    libcurl4-gnutls-dev \
    libzen-dev \
    wget \
    ffmpeg \
    libsox-fmt-mp3 \
    sox \
    locales \
    megatools \
    && rm -rf /var/lib/apt/lists/*

# Install libzen0v5 from specific URL since it's not available in some default repos
RUN wget -q -O /tmp/libzen0v5.deb http://th.archive.ubuntu.com/ubuntu/pool/universe/libz/libzen/libzen0v5_0.4.40-1_amd64.deb \
  && dpkg -i /tmp/libzen0v5.deb \
  && rm /tmp/libzen0v5.deb

# Install libmediainfo0v5 from Debian repo
RUN wget -q -O /tmp/libmediainfo0v5.deb http://ftp.de.debian.org/debian/pool/main/libm/libmediainfo/libmediainfo0v5_22.12+dfsg-1_amd64.deb \
  && dpkg -i /tmp/libmediainfo0v5.deb \
  && rm /tmp/libmediainfo0v5.deb

# Install libtinyxml2-6a from specific Ubuntu repo
RUN wget -q -O /tmp/libtinyxml2-6a.deb http://kr.archive.ubuntu.com/ubuntu/pool/universe/t/tinyxml2/libtinyxml2-6a_7.0.0+dfsg-1build1_amd64.deb \
  && dpkg -i /tmp/libtinyxml2-6a.deb \
  && rm /tmp/libtinyxml2-6a.deb

# Install libmediainfo-dev from Debian repo
RUN wget -q -O /tmp/libmediainfo-dev.deb http://ftp.de.debian.org/debian/pool/main/libm/libmediainfo/libmediainfo-dev_22.12+dfsg-1_amd64.deb \
  && dpkg -i /tmp/libmediainfo-dev.deb \
  && rm /tmp/libmediainfo-dev.deb

# Install mediainfo from MediaArea repo
RUN wget -q -O /tmp/mediainfo.deb https://mediaarea.net/download/binary/mediainfo/22.12/mediainfo_22.12-1_amd64.xUbuntu_20.04.deb \
  && dpkg -i /tmp/mediainfo.deb \
  && rm /tmp/mediainfo.deb

# Generate and set locale
RUN locale-gen en_US.UTF-8 && update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

# Copy requirements.txt and install Python dependencies
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

# Copy the entire current directory into the container
COPY . .

# Ensure start script is executable
RUN chmod +x start

# Set the command to run the start script
CMD ["./start"]
