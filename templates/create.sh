#!/bin/sh

sleep 15

${pre_create_user_data}

export INSTALL_${upper(type)}_NAME="server"
export INSTALL_${upper(type)}_SKIP_START="true"
export INSTALL_${upper(type)}_SKIP_ENABLE="true"
export INSTALL_${upper(type)}_VERSION="${version}"
export INSTALL_${upper(type)}_CHANNEL="${channel}"

export ${upper(type)}_TOKEN="${cluster_token}"
export ${upper(type)}_AGENT_TOKEN="${agent_token}"
export INSTALL_${upper(type)}_EXEC="server ${leader ? "--cluster-init" : "--server https://${private_ip}:6443"} ${join(" ", extra_args)} --node-taint node-role.kubernetes.io/master:NoSchedule"

mkdir -p /etc/rancher/${type}
mkdir -p /var/lib/rancher/${type}/server/manifests
cat <<-EOF | sed -r 's/^ {4}//' | tee /etc/rancher/${type}/config.yaml > /dev/null
    write-kubeconfig-mode: "0644"
    disable-cloud-controller: true
    disable: ["local-storage"]
    kube-apiserver-arg: ["enable-bootstrap-token-auth"]
    kubelet-arg: ["cloud-provider=external"]
    tls-san: ["${private_ip}", "${public_ip}"]
    cluster-cidr: "${pods_cidr}"
    flannel-iface: "$(ip a | grep $(hostname -I | awk '{print $2}') | awk '{print $NF}')"
    node-ip: "$(hostname -I | awk '{print $2}')"
    node-name: "$(hostname -f)"
    node-label: [${join(",", [for key, val in labels : "\"${key}=${val}\""])}]
    node-taint: [${join(",", [for key, val in taints : "\"${key}=${val}\""])}]
EOF
cat <<-EOF | sed -r 's/^ {4}//' | tee /etc/rancher/${type}/registries.yaml > /dev/null
    mirrors:
    %{ for key, val in registries }
        "${key}":
            endpoint:
                - "${val.endpoint}"
    %{ endfor }
    configs:
    %{ for key, val in registries }
    %{ if val.username != "" && val.password != "" }
        "${replace(val.endpoint, "/https?:\\/\\//", "")}":
            auth:
                username: ${val.username}
                password: ${val.password}
    %{ endif }
    %{ endfor }
EOF

if [ "${leader}" = "true" ]; then
cat <<-EOF | tee /var/lib/rancher/${type}/server/manifests/bootstrap.yaml > /dev/null
${bootstrap_file}
EOF
cat <<-EOF | tee /var/lib/rancher/${type}/server/manifests/hccm.yaml > /dev/null
${ccm_file}
EOF
cat <<-EOF | tee /var/lib/rancher/${type}/server/manifests/csi.yaml > /dev/null
${csi_file}
EOF
cat <<-EOF | tee /var/lib/rancher/${type}/server/manifests/ca.yaml > /dev/null
${ca_file}
EOF
fi

curl -sfL https://get.${type}.io | sh -

cat <<-EOF | sed -r 's/^ {4}//' | tee -a /etc/systemd/system/${type}-server.service.env > /dev/null
    %{ for key, val in extra_envs }
    ${key}="${val}"
    %{ endfor }
EOF

systemctl enable ${type}-server.service
systemctl start ${type}-server.service

${post_create_user_data}
