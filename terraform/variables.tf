variable "namespace" {
  default     = "nodeapp"
  description = "Apps namespace"
}
variable "app_dist" {
  default     = "app"
  description = "App Distribution folder"
}
variable "dist_zip" {
  default     = "app.zip"
  description = "APP package"
}

variable "environment" {
  default     = "dev"
  description = "(dev, stage, prod)"
}

variable "app" {
  default = "Node App"
}

variable "elasticapp" {
  default = "nodeapp"
}
variable "beanstalkappenv" {
  default = "nodeenv"
}
variable "solution_stack_name" {
  default = "64bit Amazon Linux 2 v5.6.1 running Node.js 16"
}
variable "tier" {
  default = "WebServer"
}

variable "vpc_id" {
  default = "vpc-e1c3bd9c"
}
variable "public_subnets" {
  default = ["subnet-ff163b99", "subnet-b1fe8f80"]
}
