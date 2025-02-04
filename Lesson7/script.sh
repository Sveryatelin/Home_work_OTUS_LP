#!/bin/bash

yum install -y wget rpmdevtools rpm-build createrepo yum-utils cmake gcc git

#create rpm
mkdir -p ~/rpm && cd ~/rpm
yumdownloader --source nginx

rpm -Uvh nginx*.src.rpm
yum-builddep -y nginx

cd /root
git clone --recurse-submodules -j8 https://github.com/google/ngx_brotli
cd ngx_brotli/deps/brotli
mkdir -p out && cd out

cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF \
    -DCMAKE_C_FLAGS="-Ofast -m64 -march=native -mtune=native -flto -funroll-loops -ffunction-sections -fdata-sections -Wl,--gc-sections" \
    -DCMAKE_CXX_FLAGS="-Ofast -m64 -march=native -mtune=native -flto -funroll-loops -ffunction-sections -fdata-sections -Wl,--gc-sections" \
    -DCMAKE_INSTALL_PREFIX=./installed ..

cmake --build . --config Release -j 2 --target brotlienc

sed -i '/--with-compat/a \    --add-module=/root/ngx_brotli \\' ~/rpmbuild/SPECS/nginx.spec

cd ~/rpmbuild/SPECS/
rpmbuild -ba nginx.spec -D 'debug_package %{nil}'

cp ~/rpmbuild/RPMS/noarch/* ~/rpmbuild/RPMS/x86_64/ || true
cd ~/rpmbuild/RPMS/x86_64

#install nginx
yum localinstall -y *.rpm
systemctl start nginx
systemctl status nginx --no-pager

#create repo
mkdir -p /usr/share/nginx/html/repo
cp ~/rpmbuild/RPMS/x86_64/*.rpm /usr/share/nginx/html/repo/
createrepo /usr/share/nginx/html/repo/

sed -i '/server {/a \ \ \ \ index index.html index.htm;\n\ \ \ \ autoindex on;' /etc/nginx/nginx.conf

systemctl reload nginx

#add local repo
cat > /etc/yum.repos.d/otus.repo << EOF
[otus]
name=otus-linux
baseurl=http://localhost/repo
gpgcheck=0
enabled=1
EOF

yum repolist enabled | grep otus

cd /usr/share/nginx/html/repo/
wget https://repo.percona.com/yum/percona-release-latest.noarch.rpm

yum makecache
