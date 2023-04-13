
DOMAIN="nokialab.net"

# Install base packages for iptables and others
dnf -y install iptables ethtool ebtables
# Enable IP packet forwarding
cat > /etc/sysctl.d/99-k8s-cri.conf <<EOF
net.bridge.bridge-nf-call-iptables=1
net.ipv4.ip_forward=1
net.bridge.bridge-nf-call-ip6tables=1
EOF
echo -e overlay\\nbr_netfilter > /etc/modules-load.d/k8s.conf
# Fix cgroup version
sed -E -i 's/^GRUB_CMDLINE_LINUX="/GRUB_CMDLINE_LINUX="systemd.unified_cgroup_hierarchy=0 /g' /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg
touch /etc/systemd/zram-generator.conf
# Disable firewalld
sed -E -i 's/^.*DNSStubListener=.*/DNSStubListener=no/g' /etc/systemd/resolved.conf
sed -E -i 's/^.*Domains=.*/Domains='${DOMAIN}'/g' /etc/systemd/resolved.conf
systemctl restart systemd-resolved
systemctl disable --now firewalld
systemctl restart systemd-resolved
# disable selinux
sudo setenforce 0
sudo sed -i 's/^SELINUX=.*$/SELINUX=disabled/' /etc/selinux/config
#######  reboot  server
echo "rebooting server in 10 seconds"
sleep 10
reboot
