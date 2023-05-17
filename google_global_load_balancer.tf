resource "google_compute_global_address" "ip" {
  name = "service-ip"
}

resource "google_compute_region_network_endpoint_group" "neg" {
  for_each = toset(local.locations)

  name                  = "neg-${each.key}"
  network_endpoint_type = "SERVERLESS"
  region                = each.key

  cloud_run {
    service = google_cloud_run_v2_service.service[each.key].name
  }
  depends_on = [
    google_cloud_run_v2_service.service
  ]
}

resource "google_compute_backend_service" "backend" {
  name       = "backend"
  protocol   = "HTTP"
  enable_cdn = true

  dynamic "backend" {
    for_each = toset(local.locations)

    content {
      group = google_compute_region_network_endpoint_group.neg[backend.key].id
    }
  }
  depends_on = [
    google_cloud_run_v2_service.service
  ]
}

resource "google_compute_url_map" "url_map" {
  name            = "url-map"
  default_service = google_compute_backend_service.backend.id
  depends_on = [
    google_cloud_run_v2_service.service
  ]
}

resource "google_compute_target_http_proxy" "http_proxy" {
  name    = "http-proxy"
  url_map = google_compute_url_map.url_map.id
  depends_on = [
    google_cloud_run_v2_service.service
  ]
}

resource "google_compute_global_forwarding_rule" "frontend" {
  name       = "frontend"
  target     = google_compute_target_http_proxy.http_proxy.id
  port_range = "80"
  ip_address = google_compute_global_address.ip.address
  depends_on = [
    google_cloud_run_v2_service.service
  ]
}

output "static_ip" {
  value = google_compute_global_address.ip.address
}
