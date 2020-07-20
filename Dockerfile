#######################################################################
##- @Copyright (C) Huawei Technologies., Ltd. 2019. All rights reserved.
# - lcr licensed under the Mulan PSL v2.
# - You can use this software according to the terms and conditions of the Mulan PSL v2.
# - You may obtain a copy of Mulan PSL v2 at:
# -     http://license.coscl.org.cn/MulanPSL2
# - THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND, EITHER EXPRESS OR
# - IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT, MERCHANTABILITY OR FIT FOR A PARTICULAR
# - PURPOSE.
# - See the Mulan PSL v2 for more details.
##- @Description: prepare compile container envrionment
##- @Author: lifeng
##- @Create: 2020-01-10
#######################################################################
# This file describes the isulad compile container image.
#
# Usage:
#
# docker build --build-arg http_proxy=YOUR_HTTP_PROXY_IF_NEEDED \
#		--build-arg https_proxy=YOUR_HTTPS_PROXY_IF_NEEDED \
#		-t YOUR_IMAGE_NAME -f ./Dockerfile .


FROM	centos:7.6.1810 as build
MAINTAINER LiFeng <lifeng68@huawei.com>

RUN echo "nameserver 8.8.8.8" > /etc/resolv.conf && \
    echo "nameserver 8.8.4.4" >> /etc/resolv.conf && \
    echo "search localdomain" >> /etc/resolv.conf

# Install dependency package
RUN yum clean all && yum makecache && yum install -y epel-release && yum swap -y fakesystemd systemd && \
	yum update -y && \
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

RUN yum clean all && \
    (cd /lib/systemd/system/sysinit.target.wants/; for i in *; \
    do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
    rm -f /lib/systemd/system/multi-user.target.wants/*;\
    rm -f /etc/systemd/system/*.wants/*;\
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*;\
    rm -f /lib/systemd/system/anaconda.target.wants/*;

RUN echo "export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH" >> /etc/bashrc && \
    echo "export LD_LIBRARY_PATH=/usr/local/lib:/usr/lib:$LD_LIBRARY_PATH" >> /etc/bashrc && \
    echo "/usr/lib" >> /etc/ld.so.conf && \
    echo "/usr/local/lib" >> /etc/ld.so.conf

	
# disalbe sslverify
RUN git config --global http.sslverify false

# install cmake
RUN set -x && \
	cd ~ && \
	git clone https://gitee.com/src-openeuler/cmake.git && \
	cd cmake && \
	git checkout openEuler-20.03-LTS-tag && \
	tar -xzvf cmake-3.12.1.tar.gz && \
	cd cmake-3.12.1 && \
	./bootstrap && make && make install && \
	ldconfig

# Centos has no protobuf, protobuf-devel, grpc, grpc-devel, grpc-plugin
# and we should install them manually.
# install protobuf
RUN set -x && \
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

# install c-ares
RUN export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH && \
	set -x && \
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
	
# install grpc
RUN export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH && \
	set -x && \
	cd ~ && \
	git clone https://gitee.com/src-openeuler/grpc.git && \
	cd grpc && \
	git checkout openEuler-20.03-LTS-tag && \
	tar -xzvf grpc-1.22.0.tar.gz && \
	cd grpc-1.22.0 && \
	make -j $(nproc) && \
	make install && \
	ldconfig

# install libevent
RUN export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH && \
	set -x && \
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

# install libevhtp
RUN export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH && \
	set -x && \
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

# install http-parser
RUN export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH && \
	set -x && \
	cd ~ && \
	git clone https://gitee.com/src-openeuler/http-parser.git && \
	cd http-parser && \
	git checkout openEuler-20.03-LTS-tag && \
	tar -xzvf http-parser-2.9.2.tar.gz && \
	cd http-parser-2.9.2 && \
	make -j CFLAGS="-Wno-error" && \
	make CFLAGS="-Wno-error" install && \
	ldconfig

# install libwebsockets
RUN export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH && \
	set -x && \
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

# install lxc
RUN export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH && \
	set -x && \
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

# install lcr
RUN export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH && \
	set -x && \
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

# install clibcni
RUN export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH && \
	set -x && \
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

# install iSulad-img
RUN export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH && \
	set -x && \
	cd ~ && \
	git clone https://gitee.com/openeuler/iSulad-img.git && \
	cd iSulad-img && \
	git checkout v2.0.1 && \
	./apply-patch && \
	make -j $(nproc) && \
	make install && \
	ldconfig
	

RUN export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH && \
	set -x && \
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

RUN mkdir -p /tmp/isula /tmp/isulad /tmp/isulad-shim /tmp/isulad-img /etc/containers
RUN cp `ldd /usr/local/bin/isula|grep so|sed -e 's/\t//'|sed -e 's/.*=..//'|sed -e 's/ (0.*)//'|sed -e '/^$/d'` /tmp/isula  --parents
RUN cp `ldd /usr/local/bin/isulad|grep so|sed -e 's/\t//'|sed -e 's/.*=..//'|sed -e 's/ (0.*)//'|sed -e '/^$/d'` /tmp/isulad  --parents
RUN cp `ldd /usr/local/bin/isulad-shim|grep so|sed -e 's/\t//'|sed -e 's/.*=..//'|sed -e 's/ (0.*)//'|sed -e '/^$/d'` /tmp/isulad-shim  --parents
RUN cp `ldd /usr/bin/isulad-img|grep so|sed -e 's/\t//'|sed -e 's/.*=..//'|sed -e 's/ (0.*)//'|sed -e '/^$/d'` /tmp/isulad-img --parents


# todo isulad isulad-shim

FROM    centos:7.6.1810

# unionfs删除复制了一层之后再删除是无效的
COPY --from=build /tmp/isula /tmp/isula
COPY --from=build /tmp/isulad /tmp/isulad
COPY --from=build /tmp/isulad-shim /tmp/isulad-shim
COPY --from=build /tmp/isulad-img /tmp/isulad-img

RUN /usr/bin/cp -ru /tmp/isula/lib64/* /lib64  &&\
    /usr/bin/cp -ru /tmp/isula/usr/local/lib/* /usr/local/lib  &&\
    /usr/bin/cp -ru /tmp/isulad-img/lib64/* /lib64  &&\
    /usr/bin/cp -ru /tmp/isulad/lib64/* /lib64  &&\
    /usr/bin/cp -ru /tmp/isulad/usr/local/lib/* /usr/local/lib  &&\
    /usr/bin/cp -ru /tmp/isulad-shim/lib64/* /lib64  &&\
    /usr/bin/cp -ru /tmp/isulad-shim/usr/local/lib/* /usr/local/lib  &&\
    rm -rf /tmp/isul* &&\
#    echo "/usr/local/lib">/etc/ld.so.conf.d/isula.conf &&\
#    ldconfig

#isulad-img
COPY --from=build /usr/bin/isulad-img /usr/bin/isulad-img
COPY --from=build /etc/containers/policy.json /etc/containers/policy.json

# isula
COPY --from=build /usr/local/lib/pkgconfig/isulad.pc /usr/local/lib/pkgconfig/isulad.pc
COPY --from=build /usr/local/include/isulad/libisula.h /usr/local/include/isulad/libisula.h
COPY --from=build /usr/local/include/isulad/isula_connect.h /usr/local/include/isulad/isula_connect.h
COPY --from=build /usr/local/include/isulad/container_def.h /usr/local/include/isulad/container_def.h
COPY --from=build /usr/local/include/isulad/types_def.h /usr/local/include/isulad/types_def.h
COPY --from=build /usr/local/include/isulad/error.h /usr/local/include/isulad/error.h
COPY --from=build /usr/local/include/isulad/engine.h /usr/local/include/isulad/engine.h
COPY --from=build /etc/isulad/daemon.json /etc/isulad/daemon.json
COPY --from=build /etc/default/isulad/config.json /etc/default/isulad/config.json
COPY --from=build /etc/default/isulad/systemcontainer_config.json /etc/default/isulad/systemcontainer_config.json
COPY --from=build /etc/isulad/seccomp_default.json /etc/isulad/seccomp_default.json
COPY --from=build /etc/default/isulad/hooks/default.json /etc/default/isulad/hooks/default.json
COPY --from=build /etc/default/isulad/isulad-check.sh /etc/default/isulad/isulad-check.sh
COPY --from=build /etc/sysmonitor/process/isulad-monit /etc/sysmonitor/process/isulad-monit
#COPY --from=build /usr/local/lib/libisula.so /usr/local/lib/libisula.so
COPY --from=build /usr/local/bin/isula /usr/local/bin/isula
COPY --from=build /usr/local/bin/isulad-shim /usr/local/bin/isulad-shim
COPY --from=build /usr/local/bin/isulad /usr/local/bin/isulad
#COPY --from=build /usr/local/lib/libhttpclient.so /usr/local/lib/libhttpclient.so

RUN echo "/usr/local/lib">/etc/ld.so.conf.d/isula.conf &&\
    ldconfig

VOLUME [ "/sys/fs/cgroup" ]
CMD ["/usr/sbin/init"]
