variable "cluster_name" {
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

variable "region_id" {
    type = string 
}