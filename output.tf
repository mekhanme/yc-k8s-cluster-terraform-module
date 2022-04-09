output "cluster_name" {
  value   = yandex_kubernetes_cluster.cluster.name
}

output "cluster_id" {
  value   = yandex_kubernetes_cluster.cluster.id
}

output "cluster_ipv4_range" {
  value   = yandex_kubernetes_cluster.cluster.cluster_ipv4_range
}

output "service_ipv4_range" {
  value   = yandex_kubernetes_cluster.cluster.service_ipv4_range
}

output "internal_v4_address" {
  value   = yandex_kubernetes_cluster.cluster.master.*.internal_v4_address[0]
}

output "external_v4_address" {
  value   = yandex_kubernetes_cluster.cluster.master.*.external_v4_address[0]
}
