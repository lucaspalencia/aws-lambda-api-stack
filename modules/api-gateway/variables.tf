variable "api_gateway_api_key_name" {
    type = string
}

variable "api_gateway_api_key_tags" {
    default = {}
}

variable "api_gateway_rest_api_name" {
    type = string
}

variable "api_gateway_rest_api_tags" {
    default = {}
}

variable "api_gateway_usage_plan_name" {
    type = string
}

variable "api_gateway_usage_plan_tags" {
    default = {}
}

variable "environment" {
    type = string
}

variable "deployed_at" {
    type = string 
}

variable "uri" {
    type = string
}
