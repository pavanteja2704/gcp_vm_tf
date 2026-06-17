variable "vm" {
  type = any
  sensitive = false
}

variable "access_token" {
  type      = string
  sensitive = true
}

variable "project_id" {
  type = string
}