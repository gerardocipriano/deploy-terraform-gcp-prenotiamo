provider "google" {
  credentials = file("prenotiamo-52276ba2c593.json")
  project     = var.my-project
  region      = "asia-east1"
}

provider "google-beta" {
  credentials = file("prenotiamo-52276ba2c593.json")
  project     = var.my-project
  region      = "asia-east1"
}

provider "kubernetes" {
  host                   = "https://${data.google_container_cluster.cluster.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(data.google_container_cluster.cluster.master_auth.0.cluster_ca_certificate)
  
}
