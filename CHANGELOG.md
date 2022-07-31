## [1.7.5](https://github.com/cktf/terraform-hcloud-rke/compare/1.7.4...1.7.5) (2022-07-31)


### Bug Fixes

* enable traefik ingressclass ([003b949](https://github.com/cktf/terraform-hcloud-rke/commit/003b9495276781f94bd922471840eb23c8b6f6d2))

## [1.7.4](https://github.com/cktf/terraform-hcloud-rke/compare/1.7.3...1.7.4) (2022-07-31)


### Bug Fixes

* attach firewall to master servers using label selector ([c532b05](https://github.com/cktf/terraform-hcloud-rke/commit/c532b058d5ad4ec8c178a7e4e19fe04220b2614f))
* replace firewall attachment with apply_to in firewall ([c985ca0](https://github.com/cktf/terraform-hcloud-rke/commit/c985ca00de88fd609fe5cd09ae65dd8b93fbc279))

## [1.7.3](https://github.com/cktf/terraform-hcloud-rke/compare/1.7.2...1.7.3) (2022-07-31)


### Bug Fixes

* firewall attachment to workers using label selectors ([102c0d0](https://github.com/cktf/terraform-hcloud-rke/commit/102c0d074ce0beac4ede57b82cac1714eae2faf7))
* syntax problem in concat function firewall label selector ([d088d8d](https://github.com/cktf/terraform-hcloud-rke/commit/d088d8d408f3caea6722f2bf9463eb7bc3966a4e))

## [1.7.2](https://github.com/cktf/terraform-hcloud-rke/compare/1.7.1...1.7.2) (2022-07-31)


### Bug Fixes

* use one label selector for firewall rules ([7267dab](https://github.com/cktf/terraform-hcloud-rke/commit/7267dabe7b9bec0667de81b65160b7d4514f58d6))

## [1.7.1](https://github.com/cktf/terraform-hcloud-rke/compare/1.7.0...1.7.1) (2022-07-31)


### Bug Fixes

* set firewall on worker nodes using label selector ([a89e785](https://github.com/cktf/terraform-hcloud-rke/commit/a89e785cb509b9781878ddcfdb84e2ba5ef2661c))

# [1.7.0](https://github.com/cktf/terraform-hcloud-rke/compare/1.6.0...1.7.0) (2022-07-31)


### Bug Fixes

* add toleration and affinity to hcloud-csi-controller StatefulSet ([a55a592](https://github.com/cktf/terraform-hcloud-rke/commit/a55a59279cbd3ed64749d423754f1892e49d5809))
* change variable name ([9658cec](https://github.com/cktf/terraform-hcloud-rke/commit/9658cec251158b3b02594b311eaeb9c58379e9b7))


### Features

* add manifests to runtime condition block ([dd494e7](https://github.com/cktf/terraform-hcloud-rke/commit/dd494e7d31ec622a5e9ea8d87ef29d4a718f5991))

# [1.6.0](https://github.com/cktf/terraform-hcloud-rke/compare/1.5.0...1.6.0) (2022-07-29)


### Features

* add cluster-autoscaler manifest ([9c528a6](https://github.com/cktf/terraform-hcloud-rke/commit/9c528a62517dd7d8a620d1755813ae93284ca846))

# [1.5.0](https://github.com/cktf/terraform-hcloud-rke/compare/1.4.6...1.5.0) (2022-07-29)


### Features

* add pods_cidr range variable ([417d6ed](https://github.com/cktf/terraform-hcloud-rke/commit/417d6ed262f4852301c9fdb32287191713ac7706))

## [1.4.6](https://github.com/cktf/terraform-hcloud-rke/compare/1.4.5...1.4.6) (2022-07-29)


### Bug Fixes

* change flannel interface to private inet ([4f856e4](https://github.com/cktf/terraform-hcloud-rke/commit/4f856e45f32811986a1e0e55351717b63adf75d6))
* server install command ([e28e667](https://github.com/cktf/terraform-hcloud-rke/commit/e28e66789f6adcf20a0bce394131eb36b3b80922))

## [1.4.5](https://github.com/cktf/terraform-hcloud-rke/compare/1.4.4...1.4.5) (2022-07-28)


### Bug Fixes

* change secretKeyRef (Hetzner Bad Document) ([44e429c](https://github.com/cktf/terraform-hcloud-rke/commit/44e429cda7d8b35f23033ddf61179216b078a1c7))
* syntax problem after variable binding in hcloud.yml ([82230a4](https://github.com/cktf/terraform-hcloud-rke/commit/82230a4ae456b4497e63c216660136fa141a0934))

## [1.4.4](https://github.com/cktf/terraform-hcloud-rke/compare/1.4.3...1.4.4) (2022-07-28)


### Bug Fixes

* add support for networks in CCM plugin ([ee252eb](https://github.com/cktf/terraform-hcloud-rke/commit/ee252ebfa0cb0699a369bc61a02ea8f9d313a7f1))

## [1.4.3](https://github.com/cktf/terraform-hcloud-rke/compare/1.4.2...1.4.3) (2022-07-28)


### Bug Fixes

* change ccm.yaml file (removed automatically bug) ([65c5725](https://github.com/cktf/terraform-hcloud-rke/commit/65c5725ca9884c6f30138d00d7cd24cebb89d10c))

## [1.4.2](https://github.com/cktf/terraform-hcloud-rke/compare/1.4.1...1.4.2) (2022-07-28)


### Bug Fixes

* syntax problem in comment section of ccm.yml ([072c3c3](https://github.com/cktf/terraform-hcloud-rke/commit/072c3c3d8dcbceae99763dfbcf9e9a27de342955))

## [1.4.1](https://github.com/cktf/terraform-hcloud-rke/compare/1.4.0...1.4.1) (2022-07-28)


### Bug Fixes

* change line endings to LF ([0520692](https://github.com/cktf/terraform-hcloud-rke/commit/052069269f1608d542098be98caa0b3a796583ba))

# [1.4.0](https://github.com/cktf/terraform-hcloud-rke/compare/1.3.10...1.4.0) (2022-07-28)


### Bug Fixes

* change template files pat ([666c05d](https://github.com/cktf/terraform-hcloud-rke/commit/666c05d8d605ddd2f53c721bcad5690a5c590b9f))


### Features

* add ccm, csi manifests for hcloud ([ca82c34](https://github.com/cktf/terraform-hcloud-rke/commit/ca82c340b8483227fb2868feab491f0530a95e04))

## [1.3.10](https://github.com/cktf/terraform-hcloud-rke/compare/1.3.9...1.3.10) (2022-07-27)


### Bug Fixes

* add dependency to network for master servers ([90897aa](https://github.com/cktf/terraform-hcloud-rke/commit/90897aa4a6dd2b40db4d6121c0e2a67a721c1a31))
* create bootstrap service account and token ([6db31a1](https://github.com/cktf/terraform-hcloud-rke/commit/6db31a142781411fdd1f03ce14e58fb304e961ed))

## [1.3.9](https://github.com/cktf/terraform-hcloud-rke/compare/1.3.8...1.3.9) (2022-07-27)


### Bug Fixes

* change terraform lock file ([3cf6ae1](https://github.com/cktf/terraform-hcloud-rke/commit/3cf6ae166bab96478e3f14b6266ecae8067c9289))
* syntax problem in bootstrap.yml manifest file ([9c8cfe6](https://github.com/cktf/terraform-hcloud-rke/commit/9c8cfe6c0a373da85af19e0afcfa832fc954926a))

## [1.3.8](https://github.com/cktf/terraform-hcloud-rke/compare/1.3.7...1.3.8) (2022-07-26)


### Bug Fixes

* add hcloud_server_network attachment resource ([396c078](https://github.com/cktf/terraform-hcloud-rke/commit/396c078d565339767057c78d701f0bcc9cd36e70))

## [1.3.7](https://github.com/cktf/terraform-hcloud-rke/compare/1.3.6...1.3.7) (2022-07-26)


### Bug Fixes

* add node-ip (private interface) to k3s config ([ab3388b](https://github.com/cktf/terraform-hcloud-rke/commit/ab3388b5f235db265933019affae20aa36df1657))
* remove unused subnet_id variable ([ebda79b](https://github.com/cktf/terraform-hcloud-rke/commit/ebda79b42f990439a483004a9529fa2158995d75))

## [1.3.6](https://github.com/cktf/terraform-hcloud-rke/compare/1.3.5...1.3.6) (2022-07-26)


### Bug Fixes

* establish connection between servers using private ip of load balancer ([f291dce](https://github.com/cktf/terraform-hcloud-rke/commit/f291dce88b2557f0dd294e5383c22a21eb18217c))

## [1.3.5](https://github.com/cktf/terraform-hcloud-rke/compare/1.3.4...1.3.5) (2022-07-26)


### Bug Fixes

* add master servers to private network ([29a63de](https://github.com/cktf/terraform-hcloud-rke/commit/29a63de1335948f8742355b774034dd85fecc697))

## [1.3.4](https://github.com/cktf/terraform-hcloud-rke/compare/1.3.3...1.3.4) (2022-07-26)


### Bug Fixes

* enable public ipv6 without any input bound rules ([32e36db](https://github.com/cktf/terraform-hcloud-rke/commit/32e36dbeefcd8c9085e0935fa8353b85840c523f))

## [1.3.3](https://github.com/cktf/terraform-hcloud-rke/compare/1.3.2...1.3.3) (2022-07-20)


### Bug Fixes

* add leader conditional variable to master ([9fc1f24](https://github.com/cktf/terraform-hcloud-rke/commit/9fc1f240582dfb7b60191fd73859e7ec65a4b745))

## [1.3.2](https://github.com/cktf/terraform-hcloud-rke/compare/1.3.1...1.3.2) (2022-07-20)


### Bug Fixes

* add load balancer target dependency to network connection ([30be69e](https://github.com/cktf/terraform-hcloud-rke/commit/30be69efee1e9da3a66dbbff037dd863c991adbe))

## [1.3.1](https://github.com/cktf/terraform-hcloud-rke/compare/1.3.0...1.3.1) (2022-07-20)


### Bug Fixes

* add master labels and selector to load balancer ([8e3e1db](https://github.com/cktf/terraform-hcloud-rke/commit/8e3e1db3869816ab95cb4456f7a40351e8346849))

# [1.3.0](https://github.com/cktf/terraform-hcloud-rke/compare/1.2.2...1.3.0) (2022-07-20)


### Bug Fixes

* change firewall rules ([993a681](https://github.com/cktf/terraform-hcloud-rke/commit/993a68166a61e52ad4d287c4b07cd8c631072cd7))
* change load balancer ipv4 ([6465ce6](https://github.com/cktf/terraform-hcloud-rke/commit/6465ce650b2141ecc1d36034df37e40451c40f38))
* change load balancer network zone ([44a8680](https://github.com/cktf/terraform-hcloud-rke/commit/44a86801d1720a11c4785c8053da4ef6cb57c363))
* upgrade terraform lock file ([9be5de8](https://github.com/cktf/terraform-hcloud-rke/commit/9be5de8444b458fe6ded4df9872f98c359ceeb9f))


### Features

* add placement group for masters ([c61bd17](https://github.com/cktf/terraform-hcloud-rke/commit/c61bd17ad9f76c76a4a7c715548967c255f0c452))

## [1.2.2](https://github.com/cktf/terraform-hcloud-rke/compare/1.2.1...1.2.2) (2022-07-19)


### Bug Fixes

* **CI/CD:** remove unused actions ([8ad17db](https://github.com/cktf/terraform-hcloud-rke/commit/8ad17db7f5f3b76e8be4fec3d5b41cbcdfde4856))

## [1.2.1](https://github.com/cktf/terraform-hcloud-rke/compare/1.2.0...1.2.1) (2022-07-17)


### Bug Fixes

* **CI/CD:** change CI scripts ([495d0d2](https://github.com/cktf/terraform-hcloud-rke/commit/495d0d2e602d9988f00e433ee7cea5fca0799ff9))

# [1.2.0](https://github.com/cktf/terraform-hcloud-rke/compare/1.1.0...1.2.0) (2022-06-13)


### Features

* replace standard-version with semantic-release ([a7b130f](https://github.com/cktf/terraform-hcloud-rke/commit/a7b130f598549dc3910dadbc226111712f3e37fb))
