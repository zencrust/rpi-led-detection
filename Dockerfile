FROM balenalib/raspberry-pi2-alpine-python:latest

# update apt
RUN apt-get update \
	&& apt-get install -y --no-install-recommends apt-utils \
	# install necessary build tools \
	&& apt-get -qy install build-essential cmake pkg-config unzip wget \
	# install necessary libraries \
	&& apt-get -qy install \
		libjpeg-dev \
		libtiff5-dev \
		libjasper-dev \
		libpng12-dev \
		libavcodec-dev \
		libavformat-dev \
		libswscale-dev \
		libv4l-dev \
		libxvidcore-dev \
		libx264-dev \
	#Had to break the install into chunks as the deps wouldn't resolve.  \
	&& apt-get -qy install \
		libgtk2.0-dev \
		libgtk-3-dev \
		libatlas-base-dev \
		gfortran \
		python3-dev \
		python3-pip \
		python3-numpy \
		libraspberrypi0 \
		python3-setuptools \
	# cleanup apt. \
	&& apt-get purge -y --auto-remove \
	&& rm -rf /var/lib/apt/lists/*

ARG OPENCV_VERSION=4.1.0
ENV OPENCV_VERSION $OPENCV_VERSION

	# download latest source & contrib
RUN	cd /tmp \
	&& wget -c -N -nv -O opencv.zip https://github.com/opencv/opencv/archive/$OPENCV_VERSION.zip \
	&& unzip opencv.zip \
	&& wget -c -N -nv -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/$OPENCV_VERSION.zip \
	&& unzip opencv_contrib.zip \
	# build opencv \
	&& cd /tmp/opencv-$OPENCV_VERSION \
	&& mkdir build \
	&& cd build \
	&& cmake -D CMAKE_BUILD_TYPE=RELEASE \
		-D CMAKE_INSTALL_PREFIX=/usr/local \
		-D INSTALL_C_EXAMPLES=OFF \
		-D BUILD_PYTHON_SUPPORT=OFF \
		-D BUILD_NEW_PYTHON_SUPPORT=ON \
		-D INSTALL_PYTHON_EXAMPLES=OFF \
		-D OPENCV_EXTRA_MODULES_PATH=/tmp/opencv_contrib-$OPENCV_VERSION/modules \
		-D BUILD_EXAMPLES=OFF .. \
	&& make -j4  \
	&& make \
	&& make install\
	&& make clean \
	&& cd / \
	&& rm -rf /tmp/* \
	&& pip3 install imutils picamera scipy\
        && date \
        && echo "Raspbian $RASPBIAN_VERSION - OpenCV $OPENCV_VERSION Docker Build finished."


ARG VCS_REF
ARG BUILD_DATE
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/zencrust/rpi-led-detection"

# copy main files
CMD ["/bin/bash"]