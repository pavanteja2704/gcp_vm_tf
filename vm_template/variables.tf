variable "vm" {
  type = any
  sensitive = false
}

variable "access_token" {
  type = string
}

variable "project_id" {
  type    = string
  default = "project-9daeb647-2a9c-4b5f-a21"
}