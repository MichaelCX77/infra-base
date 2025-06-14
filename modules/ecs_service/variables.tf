variable "project_name" {}
variable "image" {}
variable "cpu" {
  default = "256"
}
variable "memory" {
  default = "512"
}
variable "desired_count" {
  default = 1
}
variable "container_port" {
  default = 80
}
