variable "api_gateway_deployed_at" {
  type = string
}

variable "availability_zone_1" {
  type    = string
  default = ""
}

variable "availability_zone_2" {
  type    = string
  default = ""
}

variable "availability_zone_3" {
  type    = string
  default = ""
}

variable "environment" {
  type = string
}

variable "lambda_runtime" {
  type    = string
  default = "nodejs14.x"
}

variable "lambda_memory_size" {
  type    = number
  default = 128
}

variable "lambda_timeout" {
  type    = number
  default = 10
}

variable "project_prefix" {
  type    = string
  default = "<PROJECT-PREFIX>"
}