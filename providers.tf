provider "google" {
  credentials = file("prenotiamo-52276ba2c593.json")
  project     = var.my-project
  region      = var.location
}

provider "google-beta" {
  credentials = file("prenotiamo-52276ba2c593.json")
  project     = var.my-project
  region      = var.location
}
