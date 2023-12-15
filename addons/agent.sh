#!/bin/bash

export INSTALL_${upper(type)}_EXEC=agent
export INSTALL_${upper(type)}_TYPE=agent
export INSTALL_${upper(type)}_CHANNEL=${pool.channel != null ? pool.channel : channel}
export INSTALL_${upper(type)}_VERSION=${pool.version != null ? pool.version : version}

mkdir -p /etc/rancher/${type}
cat <<-EOFX | tee /etc/rancher/${type}/registries.yaml > /dev/null
${yamlencode(merge(registries, pool.registries))}
EOFX
cat <<-EOFX | tee /etc/rancher/${type}/config.yaml > /dev/null
${yamlencode(merge(configs, pool.configs))}
EOFX

curl -sfL https://get.${type}.io | sh -
systemctl enable ${type}-agent.service
systemctl start ${type}-agent.service
