## installing packages required for kubernetes
dnf module -y install cri-o:1.24/default
systemctl enable --now cri-o
dnf -y install kubernetes-kubeadm kubernetes-node kubernetes-client cri-tools iproute-tc container-selinux
dnf -y update
dnf -y clean all
## setting hostname, maybe you dont need this line
#hostnamectl set-hostname $(cat /etc/hosts | grep 192.168 | awk '{print $3}')
## setting up kubernetes variables
sed -E -i 's/^KUBELET_ADDRESS=.*$/KUBELET_ADDRESS="--address=0.0.0.0"/g' /etc/kubernetes/kubelet
sed -E -i 's/^# (KUBELET_PORT=.*)$/\1/g' /etc/kubernetes/kubelet
sed -E -i "s/^KUBELET_HOSTNAME=.*$/KUBELET_HOSTNAME=\"--hostname-override=$(hostname)\"/g" /etc/kubernetes/kubelet
sed -E -i 's/^(Environment="KUBELET_EXTRA_ARGS=.*)"$/\1 --container-runtime=remote --container-runtime-endpoint=unix:\/\/\/var\/run\/crio\/crio.sock"/g' /etc/systemd/system/kubelet.service.d/kubeadm.conf
dnf -y install iptables
## remove next  3 lines if you don't have a proxy!!!
#echo 'NO_PROXY="localhost,127.0.0.1,3.0.0.0/8,192.168.0.0/16,10.0.0.0/8"'  >> /etc/sysconfig/crio
#echo 'HTTP_PROXY="http://172.20.20.253:3128"'  >> /etc/sysconfig/crio
#echo 'HTTPS_PROXY="http://172.20.20.253:3128"'  >> /etc/sysconfig/crio
## enable and start services
systemctl restart crio
systemctl enable kubelet.service
kubeadm config images pull
echo "you can use kubeadm init or join now"
## remember to use 'kubeadm token create --print-join-command' to get the full command to join the master
