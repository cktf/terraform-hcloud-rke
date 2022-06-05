# Terraform HCloud RKE

![pipeline](https://github.com/cktf/terraform-hcloud-rke/actions/workflows/cicd.yml/badge.svg)
![release](https://img.shields.io/github/v/release/cktf/terraform-hcloud-rke?display_name=tag)
![license](https://img.shields.io/github/license/cktf/terraform-hcloud-rke)

**RKE** is a Terraform module useful for bootstraping **HA** kubernetes clusters using **k3s** and **rke2** on **HCloud**

## Installation

Add the required configurations to your terraform config file and install module using command bellow:

```bash
terraform init
```

## Usage

```hcl
module "rke" {
  source = "cktf/rke/hcloud"

  name = "master"
  type = "k3s"
  labels = {
    platform = "linux"
  }
  server_size     = 3
  server_type     = "cx11"
  server_image    = "debian-9"
  server_location = "nbg1"
  network_id      = "<YOUR-NETWORK-ID>"
  subnet_id       = "<YOUR-SUBNET-ID>"

  node_pools = {
    pool1 = {
      name            = "node"
      server_size     = 5
      server_type     = "cx11"
      server_image    = "debian-9"
      server_location = "nbg1"
      network_id      = "<YOUR-NETWORK-ID>"
      subnet_id       = "<YOUR-SUBNET-ID>"
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
