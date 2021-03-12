# isulad
isulad unofficial docker image


# usage:
1. start isulad daemon
```
docker run --rm -it -v /var/lib/isulad:/var/lib/isulad -v /sys/fs/cgroup:/sys/fs/cgroup  --privileged --name test les1ie/isulad
```
2. run docker exec to container
```
docker exec -it test bash
```
3. run isula command in container
```
isula pull docker.io/library/busybox
isula images
isula ps
isula run -it busybox sh
```

# screenshot
![image](https://user-images.githubusercontent.com/19611084/110882998-bcd07380-831d-11eb-8597-4cfdbd5c8fa0.png)

![image](https://user-images.githubusercontent.com/19611084/110883006-c0fc9100-831d-11eb-87f1-13c35269af1d.png)

![image](https://user-images.githubusercontent.com/19611084/110883015-c528ae80-831d-11eb-8393-6f2f61056e70.png)

<!--
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
```
-->

# refer
- https://gitee.com/openeuler/iSulad/issues/I1LKQA
- https://gitee.com/openeuler/iSulad/pulls/769
