#!/bin/sh

export INSTALL_${upper(type)}_VERSION="${version}"
export INSTALL_${upper(type)}_CHANNEL="${channel}"
export INSTALL_${upper(type)}_EXEC="agent --token ${join_token} --server https://${join_host}:${join_port}"

curl -sfL https://get.${type}.io | sh -
