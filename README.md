# Terraform HCloud RKE

![pipeline](https://github.com/cktf/terraform-hcloud-rke/actions/workflows/cicd.yml/badge.svg)
![release](https://img.shields.io/github/v/release/cktf/terraform-hcloud-rke?display_name=tag)
![license](https://img.shields.io/github/license/cktf/terraform-hcloud-rke)

This module is a customized version of [terraform-module-rke](https://github.com/cktf/terraform-module-rke) for hetzner cloud. these addons will be installed and configured on the cluster:

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

  name = "mycluster"
  type = "k3s"

  hcloud_zone    = "<ALB_ZONE>"
  hcloud_token   = "<HCLOUD_TOKEN>"
  hcloud_network = "<HCLOUD_NETWORK>"

  servers = {
    1 = {
      type     = "cx11"
      location = "fsn1"
    }
    2 = {
      type     = "cx11"
      location = "fsn1"
    }
    3 = {
      type     = "cx11"
      location = "fsn1"
    }
  }

  agents = {
    1 = {
      type     = "cx21"
      location = "fsn1"
    }
    2 = {
      type     = "cx21"
      location = "fsn1"
    }
  }

  pools = {
    1 = {
      type     = "cx21"
      location = "fsn1"
      min_size = 1
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
