resource "google_cloudbuild_trigger" "prenotiamo_trigger" {
  github {
    owner = var.github_owner
    name  = var.github_repo_name
    push {
      branch = "^${var.github_branch}$"
    }
  }

  filename = "cloudbuild.yaml"
}
