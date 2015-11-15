# build rkt debian package

RKT_VERSION=${RKT_VERSION:-0.11.0}
REV=${REV:-1}

rm -f rkt/builds/rkt_$RKT_VERSION_amd64.deb
rm -rf rkt/source/rkt-$RKT_VERSION

mkdir rkt/builds
mkdir rkt/source
mkdir -p rkt/downloads/v$RKT_VERSION

cd rkt/downloads/v$RKT_VERSION

if [ -f rkt-v${RKT_VERSION}.tar.gz ]; then
  echo "already have the download ..."
else
  wget https://github.com/coreos/rkt/releases/download/v$RKT_VERSION/rkt-v$RKT_VERSION.tar.gz
fi

cd ../../source
tar zxf ../downloads/v$RKT_VERSION/rkt-v$RKT_VERSION.tar.gz

fpm -s dir -n "rkt" \
-p ../builds \
-C ./rkt-v${RKT_VERSION} \
-v ${RKT_VERSION}-${REV} \
-t deb \
-a amd64 \
-d "dpkg (>= 1.17)" \
--license "Apache Software License 2.0" \
--maintainer "yoti <noc@yoti.com>" \
--vendor "yoti ltd" \
--description "rkt binary and stage1 acis" \
rkt=/usr/bin/rkt \
stage1-coreos.aci=/usr/share/rkt/aci/stage1-coreos.aci \
stage1-kvm.aci=/usr/share/rkt/aci/stage1-kvm.aci
