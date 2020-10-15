yum install -y epel-release

# change mirror
sed -e 's!^metalink=!#metalink=!g' \
    -e 's!^#baseurl=!baseurl=!g' \
    -e 's!//download\.fedoraproject\.org/pub!//mirrors.tuna.tsinghua.edu.cn!g' \
    -e 's!http://mirrors\.tuna!https://mirrors.tuna!g' \
    -i /etc/yum.repos.d/epel.repo /etc/yum.repos.d/epel-testing.repo


yum install -y automake autoconf libtool cmake make libcap libcap-devel libselinux libselinux-devel libseccomp libseccomp-devel yajl-devel git libcgroup tar python3 python3-pip device-mapper-devel libarchive libarchive-devel libcurl-devel zlib-devel glibc-headers openssl-devel gcc gcc-c++ systemd-devel systemd-libs golang libtar libtar-devel

export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH
export LD_LIBRARY_PATH=/usr/local/lib:/usr/lib:$LD_LIBRARY_PATH
 echo "/usr/local/lib" | sudo tee -a  /etc/ld.so.conf


git clone https://gitee.com/src-openeuler/protobuf.git
cd protobuf
git checkout openEuler-20.03-LTS-tag
tar -xzvf protobuf-all-3.9.0.tar.gz
cd protobuf-3.9.0
sudo -E ./autogen.sh
sudo -E ./configure
sudo -E make -j $(nproc)
sudo -E make install
sudo -E ldconfig


git clone https://gitee.com/src-openeuler/c-ares.git
cd c-ares
git checkout openEuler-20.03-LTS-tag
tar -xzvf c-ares-1.15.0.tar.gz
cd c-ares-1.15.0
sudo -E autoreconf -if
sudo -E ./configure --enable-shared --disable-dependency-tracking
sudo -E make -j $(nproc)
sudo -E make install
sudo -E ldconfig



git clone https://gitee.com/src-openeuler/grpc.git
cd grpc
git checkout openEuler-20.03-LTS-tag
tar -xzvf grpc-1.22.0.tar.gz
cd grpc-1.22.0
sudo -E make -j $(nproc)
sudo -E make install
sudo -E ldconfig


git clone https://gitee.com/src-openeuler/http-parser.git
cd http-parser
git checkout openEuler-20.03-LTS-tag
tar -xzvf http-parser-2.9.2.tar.gz
cd http-parser-2.9.2
sudo -E make -j CFLAGS="-Wno-error"
sudo -E make CFLAGS="-Wno-error" install
sudo -E ldconfig


git clone https://gitee.com/src-openeuler/libwebsockets.git
cd libwebsockets
git checkout openEuler-20.03-LTS-tag
tar -xzvf libwebsockets-2.4.2.tar.gz
cd libwebsockets-2.4.2
patch -p1 -F1 -s < ../libwebsockets-fix-coredump.patch
mkdir build
cd build
sudo -E cmake -DLWS_WITH_SSL=0 -DLWS_MAX_SMP=32 -DCMAKE_BUILD_TYPE=Debug ../
sudo -E make -j $(nproc)
sudo -E make install
sudo -E ldconfig


# specific
git clone https://gitee.com/src-openeuler/lxc.git
cd lxc
tar -zxf lxc-4.0.3.tar.gz
./apply-patches
cd lxc-4.0.3
sudo -E ./autogen.sh
sudo -E ./configure
sudo -E make -j
sudo -E make install


git clone https://gitee.com/openeuler/lcr.git
cd lcr
git checktout v2.0.3
mkdir build
cd build
sudo -E cmake ..
sudo -E make -j
sudo -E make install


git clone https://gitee.com/openeuler/clibcni.git
cd clibcni
mkdir build
cd build
sudo -E cmake ..
sudo -E make -j
sudo -E make install