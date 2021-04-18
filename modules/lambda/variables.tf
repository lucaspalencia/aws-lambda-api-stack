variable "environment_variables" {
    default = {}
}

variable "function_name" {
    type = string
}

variable "handler" {
    type = string
    default = "index.handler"
}

variable "memory_size" {
    type = number
    default = 128
}

variable "role" {
    type = string
}

variable "runtime" {
    type = string
}

variable "tags" {
    default = {}
}

variable "timeout" {
    type = number
    default = 10
}