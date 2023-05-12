provider "google" {
  credentials = file("prenotiamo-a6ac8880af6d.json")
  project     = var.my-project
  region      = var.location
}

provider "google-beta" {
  credentials = file("prenotiamo-a6ac8880af6d.json")
  project     = var.my-project
  region      = var.location
}
