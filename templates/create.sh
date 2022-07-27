#!/bin/sh

${pre_create_user_data}

export INSTALL_${upper(type)}_NAME="server"
export INSTALL_${upper(type)}_SKIP_START="true"
export INSTALL_${upper(type)}_SKIP_ENABLE="true"
export INSTALL_${upper(type)}_VERSION="${version}"
export INSTALL_${upper(type)}_CHANNEL="${channel}"

export ${upper(type)}_TOKEN="${cluster_token}"
export ${upper(type)}_AGENT_TOKEN="${agent_token}"
export INSTALL_${upper(type)}_EXEC="${leader ? "server --cluster-init" : "server --server https://${private_ip}:6443"} ${join(" ", extra_args)}"

mkdir -p /etc/rancher/${type}
mkdir -p /var/lib/rancher/${type}/server/manifests
cat <<-EOF | sed -r 's/^ {4}//' | tee /etc/rancher/${type}/config.yaml > /dev/null
    write-kubeconfig-mode: "0644"
    kube-apiserver-arg: ["enable-bootstrap-token-auth"]
    tls-san: ["${private_ip}", "${public_ip}"]
    node-ip: "$(hostname  -I | awk '{print $2}')"
    node-name: "${name}"
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

%{ if leader }
cat <<-EOF | sed -r 's/^ {4}//' | tee /var/lib/rancher/${type}/server/manifests/bootstrap.yaml > /dev/null
    ---
    apiVersion: v1
    kind: Secret
    metadata:
        name: bootstrap-token-${token_id}
        namespace: kube-system
    type: bootstrap.kubernetes.io/token
    stringData:
        description: "bootstrap token"
        token-id: ${token_id}
        token-secret: ${token_secret}
        usage-bootstrap-authentication: "true"
        usage-bootstrap-signing: "true"
        auth-extra-groups: system:bootstrappers:worker,system:bootstrappers:ingress
    ---
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRoleBinding
    metadata:
        name: bootstrap-admin
    subjects:
        - kind: Group
          name: system:bootstrappers
          apiGroup: rbac.authorization.k8s.io
    roleRef:
        apiGroup: rbac.authorization.k8s.io
        kind: ClusterRole
        name: cluster-admin    
EOF
%{ endif }

curl -sfL https://get.${type}.io | sh -

cat <<-EOF | sed -r 's/^ {4}//' | tee -a /etc/systemd/system/${type}-server.service.env > /dev/null
    %{ for key, val in extra_envs }
    ${key}="${val}"
    %{ endfor }
EOF

systemctl enable ${type}-server.service
systemctl start ${type}-server.service

${post_create_user_data}
