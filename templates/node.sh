#!/bin/sh

sleep 15

export INSTALL_${upper(type)}_NAME="agent"
export INSTALL_${upper(type)}_SKIP_START="true"
export INSTALL_${upper(type)}_SKIP_ENABLE="true"
export INSTALL_${upper(type)}_VERSION="${version}"
export INSTALL_${upper(type)}_CHANNEL="${channel}"

export ${upper(type)}_URL="https://${join_host}:6443"
export ${upper(type)}_TOKEN="${join_token}"
export INSTALL_${upper(type)}_EXEC="agent"

mkdir -p /etc/rancher/${type}
cat <<-EOF | sed -r 's/^ {8}//' | tee /etc/rancher/${type}/config.yaml > /dev/null
    kubelet-arg: ["cloud-provider=external"]
    flannel-iface: "$(ip a | grep $(hostname -I | awk '{print $2}') | awk '{print $NF}')"
    node-ip: "$(hostname -I | awk '{print $2}')"
    node-name: "$(hostname -f)"
EOF
cat <<-EOF | sed -r 's/^ {8}//' | tee /etc/rancher/${type}/registries.yaml > /dev/null
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

curl -sfL https://get.${type}.io | sh -

systemctl enable ${type}-agent.service
systemctl start ${type}-agent.service
