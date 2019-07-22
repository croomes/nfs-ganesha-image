FROM ubuntu:bionic

LABEL maintainer="support@storageos.com"

COPY ganesha_exporter /usr/bin/ganesha_exporter

# install prerequisites
# && apt-get install -y software-properties-common gnupg2 \
# && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3FE869A9 \
RUN DEBIAN_FRONTEND=noninteractive \
 && apt-get update \
 && apt-get install -y software-properties-common \
 && add-apt-repository ppa:gluster/glusterfs-4.1 \
 && add-apt-repository ppa:nfs-ganesha/libntirpc-1.7 \
 && add-apt-repository ppa:nfs-ganesha/nfs-ganesha-2.7 \
 && apt-get update \
 && apt-get install -y netbase nfs-common dbus nfs-ganesha nfs-ganesha-vfs \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
 && mkdir -p /run/rpcbind /export /var/run/dbus \
 && touch /run/rpcbind/rpcbind.xdr /run/rpcbind/portmap.xdr \
 && chmod 755 /run/rpcbind/* \
 && chown messagebus:messagebus /var/run/dbus

# Add startup script
COPY entrypoint.sh /

COPY storageos-nfs-ganesha-dbus.conf /etc/dbus-1/system.d/

# NFS ports and portmapper
EXPOSE 2049 38465-38467 662 111/udp 111 9587

# Start Ganesha NFS daemon by default
CMD ["/entrypoint.sh"]
