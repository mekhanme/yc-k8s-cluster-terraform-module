variable "token" {
  type    = string
}

variable "cloud_id" {
  type    = string
}

variable "folder_id" {
  type    = string
}

variable "name" {
  type    = string
}

variable "kubernetes_version" {
  type    = string
}

variable "cluster_service_account" {
  type    = string
}

variable "node_service_account" {
  type    = string
}

variable "key_id" {
  type    = string
}

variable "subnets" {
  type   = object({
    a   = object({
      name    = string
      zone    = string
    })
    b   = object({
      name    = string
      zone    = string
    })
    c   = object({
      name    = string
      zone    = string
    })
  })
}

variable "network" {
  type   = object({
    name        = string
    region      = string
    public_ip   = string
  })
}

variable "release_channel" {
  type    = string
}

variable "network_policy_provider" {
  type    = string
}

variable "node_platform_id" {
  type    = string
}

variable "container_runtime" {
  type    = string
}

variable "node_group_size" {
  type    = number
}

variable "resources" {
  type = object({
    cores           = number
    memory          = number
    core_fraction   = number
  })
}

variable "boot_disk" {
  type = object({
    type   = string
    size   = number
  })
}