# isulad


# cmake 
cd ~ 
git clone https://gitee.com/src-openeuler/cmake.git 
cd cmake 
git checkout openEuler-20.03-LTS-tag 
tar -xzvf cmake-3.12.1.tar.gz 
cd cmake-3.12.1 
./bootstrap && make && make install 
ldconfig

# protobuf
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


# cares 
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


# grpc
git clone https://gitee.com/src-openeuler/grpc.git
cd grpc
git checkout openEuler-20.03-LTS-tag
tar -xzvf grpc-1.22.0.tar.gz
cd grpc-1.22.0
sudo -E make -j $(nproc)
sudo -E make install
sudo -E ldconfig