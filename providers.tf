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
