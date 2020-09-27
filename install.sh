yum install -y epel-release

yum install -y  automake \
			autoconf \
			libtool \
			make \
			which \
			gdb \
			strace \
			rpm-build \
			graphviz \
			libcap \
			libcap-devel \
			libxslt  \
			docbook2X \
			libselinux \
			libselinux-devel \
			libseccomp \
			libseccomp-devel \
			yajl-devel \
			git \
			bridge-utils \
			dnsmasq \
			libcgroup \
			rsync \
			iptables \
			iproute \
			net-tools \
			unzip \
			tar \
			wget \
			gtest \
			gtest-devel \
			gmock \
			gmock-devel \
			cppcheck \
			python3 \
			python3-pip \
			python \
			python-pip \
			device-mapper-devel \
			libarchive \
			libarchive-devel \
			libtar \
			libtar-devel \
			libcurl-devel \
			zlib-devel \
			glibc-headers \
			openssl-devel \
			gcc \
			gcc-c++ \
			hostname \
			sqlite-devel \
			gpgme \
			gpgme-devel \
			expect \
			systemd-devel \
			systemd-libs \
			go \
			CUnit \
			CUnit-devel \
			valgrind \
			e2fsprogs

# cmake
echo "cmake------"
cd ~ && \
	git clone https://gitee.com/src-openeuler/cmake.git && \
	cd cmake && \
	git checkout openEuler-20.03-LTS-tag && \
	tar -xzvf cmake-3.12.1.tar.gz && \
	cd cmake-3.12.1 && \
	./bootstrap && make && make install && \
	ldconfig
echo "install cmake finish"

echo "protobuf"
cd ~ && \
	git clone https://gitee.com/src-openeuler/protobuf.git && \
	cd protobuf && \
	git checkout openEuler-20.03-LTS-tag && \
	tar -xzvf protobuf-all-3.9.0.tar.gz && \
	cd protobuf-3.9.0 && \
	./autogen.sh && \
	./configure && \
	make -j $(nproc) && \
	make install && \
	ldconfig
echo "install protobuf finish"

echo "c-ares"
cd ~ && \
	git clone https://gitee.com/src-openeuler/c-ares.git && \
	cd c-ares && \
	git checkout openEuler-20.03-LTS-tag && \
	tar -xzvf c-ares-1.15.0.tar.gz && \
	cd c-ares-1.15.0 && \
	autoreconf -if && \
	./configure --enable-shared --disable-dependency-tracking && \
	make -j $(nproc) && \
	make install && \
	ldconfig
echo "install c-ares finish"

# grpc
cd ~ && \
	git clone https://gitee.com/src-openeuler/grpc.git && \
	cd grpc && \
	git checkout openEuler-20.03-LTS-tag && \
	tar -xzvf grpc-1.22.0.tar.gz && \
	cd grpc-1.22.0 && \
	make -j $(nproc) && \
	make install && \
	ldconfig
echo "install grpc finish"


cd ~ && \
	git clone https://gitee.com/src-openeuler/libevent.git && \
	cd libevent && \
	git checkout openEuler-20.03-LTS-tag && \
	tar -xzvf libevent-2.1.11-stable.tar.gz && \
	cd libevent-2.1.11-stable && \
	./autogen.sh && \
	./configure && \
	make -j $(nproc) && \
	make install && \
	ldconfig
echo "install libevent  finish"

-------------------------------------------------
echo "start libevhtp"
cd ~ && \
	git clone https://gitee.com/src-openeuler/libevhtp.git && \
	cd libevhtp && \
	# 此处的4个patch中的指令是openEuler-20.03-LTS分支中，在openEuler-20.03-LTS-tag中是1.2.16   && \
	git checkout openEuler-20.03-LTS-tag && \
	tar -xzvf libevhtp-1.2.16.tar.gz && \
	cd libevhtp-1.2.16 && \
	patch -p1 -F1 -s < ../0001-support-dynamic-threads.patch && \
	patch -p1 -F1 -s < ../0002-close-openssl.patch && \
	rm -rf build && \
	mkdir build && \
	cd build && \
	cmake -D EVHTP_BUILD_SHARED=on -D EVHTP_DISABLE_SSL=on ../ && \
	make -j $(nproc) && \
	make install && \
	ldconfig
echo "install libevhtp finish"


cd ~ && \
	git clone https://gitee.com/src-openeuler/http-parser.git && \
	cd http-parser && \
	git checkout openEuler-20.03-LTS-tag && \
	tar -xzvf http-parser-2.9.2.tar.gz && \
	cd http-parser-2.9.2 && \
	make -j CFLAGS="-Wno-error" && \
	make CFLAGS="-Wno-error" install && \
	ldconfig
echo "install http parser finish"

cd ~ && \
	git clone https://gitee.com/src-openeuler/libwebsockets.git && \
	cd libwebsockets && \
	git checkout openEuler-20.03-LTS-tag && \
	tar -xzvf libwebsockets-2.4.2.tar.gz && \
	cd libwebsockets-2.4.2 && \
	patch -p1 -F1 -s < ../libwebsockets-fix-coredump.patch && \
	mkdir build && \
	cd build && \
	cmake -DLWS_WITH_SSL=0 -DLWS_MAX_SMP=32 -DCMAKE_BUILD_TYPE=Debug ../ && \
	make -j $(nproc) && \
	make install && \
	ldconfig

echo "install libwebsocket finish"

cd ~ && \
	git clone https://gitee.com/src-openeuler/lxc.git && \
	cd lxc && \
	git checkout openEuler-20.03-LTS-tag &&\
	./apply-patches && \
	cd lxc-3.0.3 && \
	./autogen.sh && \
	./configure && \
	make -j $(nproc) && \
	make install && \
	ldconfig
echo "install lxc finish"


cd ~ && \
	git clone https://gitee.com/openeuler/lcr.git && \
	cd lcr && \
	git checkout aa88f1a8c5e4bc969b28a202a5940f72b0d4357d  && \
	mkdir build && \
	cd build && \
	cmake ../ && \
	make -j $(nproc) && \
	make install && \
	ldconfig

echo "install lcr finish"

cd ~ && \
	git clone https://gitee.com/openeuler/clibcni.git && \
	cd clibcni && \
	git checkout v2.0.2 && \
	mkdir build && \
	cd build && \
	cmake ../ && \
	make -j $(nproc) && \
	make install && \
	ldconfig

echo "install clibcni finish"


cd ~ && \
	git clone https://gitee.com/openeuler/iSulad-img.git && \
	cd iSulad-img && \
	git checkout v2.0.1 && \
	./apply-patch && \
	make -j $(nproc) && \
	make install && \
	ldconfig

echo "install isulad-img finish"


cd ~ && \
	git clone https://gitee.com/openeuler/iSulad.git && \
	cd iSulad && \
	git checkout v2.0.3 && \
	mkdir build && \
	cd build && \
	cmake .. && \
	make && \
	make install && \
	ldconfig
echo "install isula finish"