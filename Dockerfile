FROM balenalib/raspberry-pi-debian

RUN apt-get update \
	&& apt-get install apt-utils\
	&& apt-get install -y --no-install-recommends \
		libraspberrypi0 python3-numpy python3-scipy python3-pip python3-setuptools \
	&& pip3 install \
		picamera \
		paho-mqtt \
		imutils \
		opencv-python-headless \
		opencv-contrib-python-headless \
	&& apt-get install -y python3-skimage \
	&& apt-get install -y libpng-dev \
		libfreetype6-dev \
		pkg-config \
		libjpeg-dev \
		libhdf5-dev \
		libhdf5-serial-dev \
		libtiff5-dev \
		libjasper-dev \
		libavutil55 \
		libavcodec-dev \
		libavformat-dev \
		libswscale-dev \
		libv4l-dev \
		libxvidcore-dev \
		libx264-dev \
		libgtk2.0-dev \
		libgtk-3-dev \
		libatlas-base-dev \
		gfortran \
		libharfbuzz-bin  \
		libilmbase-dev \
		libopenexr-dev \
		libgstreamer1.0-dev \
		libwebp6 \
	# cleanup apt. \
	&& apt-get purge -y --auto-remove \
	&& rm -rf /var/lib/apt/lists/*

CMD ["/bin/bash"]