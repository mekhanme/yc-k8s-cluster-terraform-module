// NOTE: https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_cluster
//       https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_node_group

data "yandex_vpc_network" "net" {
  name   = var.network.name
}

data "yandex_vpc_subnet" "subnet-a" {
  name   = var.subnets.a.name
}

data "yandex_vpc_subnet" "subnet-b" {
  name   = var.subnets.b.name
}

data "yandex_vpc_subnet" "subnet-c" {
  name   = var.subnets.c.name
}

resource "yandex_kubernetes_cluster" "cluster" {
  name          = var.name
  network_id    = data.yandex_vpc_network.net.id

  master {
    version   = var.kubernetes_version

    regional {
      region   = var.network.region

      location {
        zone        = data.yandex_vpc_subnet.subnet-a.zone
        subnet_id   = data.yandex_vpc_subnet.subnet-a.subnet_id
      }

      location {
        zone        = data.yandex_vpc_subnet.subnet-b.zone
        subnet_id   = data.yandex_vpc_subnet.subnet-b.subnet_id
      }

      location {
        zone        = data.yandex_vpc_subnet.subnet-c.zone
        subnet_id   = data.yandex_vpc_subnet.subnet-c.subnet_id
      }
    }

    public_ip             = var.network.public_ip
    // security_group_ids    = [security_group_ids]

    maintenance_policy {
      auto_upgrade   = true

      maintenance_window {
        start_time    = "03:00"
        duration      = "1h"
      }
    }
  }

  service_account_id        = var.cluster_service_account
  node_service_account_id   = var.node_service_account
  release_channel           = var.release_channel
  network_policy_provider   = var.network_policy_provider

  kms_provider {
    key_id   = var.key_id
  }
}

resource "yandex_kubernetes_node_group" "node_group" {
  cluster_id    = yandex_kubernetes_cluster.cluster.id
  name          = var.name
  version       = var.kubernetes_version

  instance_template {
    platform_id   = var.node_platform_id

    network_interface {
      nat           = true
      subnet_ids    = [
        data.yandex_vpc_subnet.subnet-a.id,
        data.yandex_vpc_subnet.subnet-b.id,
        data.yandex_vpc_subnet.subnet-c.id
      ]
      // security_group_ids    = [security_group_ids]
    }

    resources {
      memory           = var.resources.memory
      cores            = var.resources.cores
      core_fraction    = var.resources.core_fraction
    }

    boot_disk {
      type   = var.boot_disk.type
      size   = var.boot_disk.size
    }

    scheduling_policy {
      preemptible = false
    }

    container_runtime {
      type   = var.container_runtime
    }
  }

  scale_policy {
    fixed_scale {
      size   = var.node_group_size
    }
  }

  allocation_policy {
    location {
      zone   = data.yandex_vpc_subnet.subnet-a.zone
    }

    location {
      zone   = data.yandex_vpc_subnet.subnet-b.zone
    }

    location {
      zone   = data.yandex_vpc_subnet.subnet-c.zone
    }
  }

  maintenance_policy {
    auto_upgrade    = true
    auto_repair     = true

    maintenance_window {
      day           = "monday"
      start_time    = "03:00"
      duration      = "1h"
    }
  }

  depends_on   = [
    yandex_kubernetes_cluster.cluster
  ]
}