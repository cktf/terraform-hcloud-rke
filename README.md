# Terraform HCloud RKE

![pipeline](https://github.com/cktf/terraform-hcloud-rke/actions/workflows/cicd.yml/badge.svg)
![release](https://img.shields.io/github/v/release/cktf/terraform-hcloud-rke?display_name=tag)
![license](https://img.shields.io/github/license/cktf/terraform-hcloud-rke)

**RKE** is a Terraform module useful for bootstraping **HA** kubernetes clusters using **k3s** and **rke2** on **HCloud**

These modules will be installed and configured on the cluster:

-   [CCM](https://github.com/hetznercloud/hcloud-cloud-controller-manager)
-   [CSI](https://github.com/hetznercloud/csi-driver)
-   [CA](https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/cloudprovider/hetzner)

## Installation

Add the required configurations to your terraform config file and install module using command bellow:

```bash
terraform init
```

## Usage

```hcl
module "rke" {
  source = "cktf/rke/hcloud"

  name         = "mycluster"
  network_id   = module.network_hcloud.network_id
  hcloud_token = "<HCLOUD_TOKEN>"

  masters = {
    1 = {
      type     = "cx11"
      location = "fsn1"
      tags     = {}
    }
  }

  node_pools = {
    pool1 = {
      type     = "cx11"
      location = "fsn1"
      min_size = 3
      max_size = 5
    }
    pool2 = {
      type     = "cx11"
      location = "fsn1"
      min_size = 2
      max_size = 5
    }
  }
}
```

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License

This project is licensed under the [MIT](LICENSE.md).  
Copyright (c) KoLiBer (koliberr136a1@gmail.com)
