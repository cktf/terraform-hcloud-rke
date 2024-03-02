#!/bin/bash

export gateway="${gateway}"
${file("${path}/setup.sh")}

export INSTALL_${upper(type)}_NAME=agent
export INSTALL_${upper(type)}_EXEC=agent
export INSTALL_${upper(type)}_CHANNEL=${pool.channel != null ? pool.channel : channel}
export INSTALL_${upper(type)}_VERSION=${pool.version != null ? pool.version : version_}
curl -sfL https://get.${type}.io | sh - && sleep 10
systemctl enable ${type}-agent.service
mkdir -p /etc/rancher/${type}

cat <<-EOFX | tee /etc/rancher/${type}/registries.yaml > /dev/null
${yamlencode(merge(registries, pool.registries))}
EOFX
cat <<-EOFX | tee /etc/rancher/${type}/config.yaml > /dev/null
${yamlencode(merge(configs, pool.configs))}
EOFX

${pool.pre_exec}
systemctl restart ${type}-agent.service || true
${pool.post_exec}
