variable "cluster_name" {
    type = string 
}

variable "service_name" {
    type = string 
}

variable "cpu" {
    type = string
}

variable "memory" {
    type = string 
}

variable "image_id" {
    type = string 
}

variable "desired_count" {
    type = string 
}

variable "subnets" {
    type = list(string)
}

variable "security_groups" {
    type = list(string)
}

variable "discord_bot_token" { 
  type      = string
  sensitive = true
}