variable "my-project" {
  type        = string
  description = "The ID of the Google Cloud project"
}

variable "smtp_server" {
  type        = string
  description = "The SMTP server to use for sending emails"
}

variable "smtp_username" {
  type        = string
  description = "The username for the SMTP server"
}

variable "mailtrap_secret" {
  type        = string
  description = "The secret for Mailtrap"
}

variable "db_name" {
  type        = string
  description = "The name of the database"
}

variable "db_service_user" {
  type        = string
  description = "The database service user"
}

variable "db_service_user_password" {
  type        = string
  description = "The password for the database service user"
}

variable "db_service_admin" {
  type        = string
  description = "The database service admin user"
}

variable "db_service_admin_password" {
  type        = string
  description = "The password for the database service admin user"
}

variable "jwt_secret" {
  type        = string
  description = "The secret for JWT authentication"
}

variable "cookie_name" {
  type        = string
  description = "The name of the cookie used for authentication"
}
variable "github_owner" {
  description = "The GitHub owner of the repository to connect to Cloud Build."
  type        = string
}

variable "github_repo_name" {
  description = "The name of the GitHub repository to connect to Cloud Build."
  type        = string
}

variable "github_branch" {
  description = "The branch of the GitHub repository to trigger Cloud Build on push."
  type        = string
}
