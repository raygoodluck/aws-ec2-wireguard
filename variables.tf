variable "PATH_TO_PRIVATE_KEY" {
  default = "~/.ssh/id_rsa"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "~/.ssh/id_rsa.pub"
}

variable "INSTANCE_USERNAME" {
  default = "ec2-user"
}


# variable "AWS_ACCESS_KEY" {
#   default = ""
# }
# variable "AWS_SECRET_KEY" {
#   default = ""
# }

variable "AWS_REGION" {
  default = "ap-northeast-1"
  #   default = "us-west-1"
}
variable "AMIS" {
  type = map(string)
  default = {
    us-east-1      = "ami-13be557e"
    us-west-1      = "ami-0925fd223898ee5ba"
    eu-west-1      = "ami-0d729a60"
    ap-northeast-1 = "ami-030cf0a1edb8636ab"
  }
}


variable "wg_client_public_keys" {
  # type        = map(string)
  description = "List of maps of client IPs and public keys. See Usage in README for details."
  default = [
    { "10.1.1.1/32" = "5O3YB4bPwEbDXfkut7Dz3qxW77yClf0DISqZNMmSbzQ=" }, # make sure these are correct
  ]
}


variable "wg_server_net" {
  default     = "10.1.1.2/24"
  description = "IP range for vpn server - make sure your Client ips are in this range but not the specific ip i.e. not .1"
}

variable "wg_server_port" {
  default     = 51820
  description = "Port for the vpn server."
}

variable "wg_persistent_keepalive" {
  default     = 25
  description = "Persistent Keepalive - useful for helping connection stability over NATs."
}

variable "lan_net" {
  default     = "192.168.110.1/24"
  description = "lan network"
}


variable "additional_security_group_ids" {
  type        = list(string)
  default     = [""]
  description = "Additional security groups if provided, default empty."
}

variable "target_group_arns" {
  type        = list(string)
  default     = null
  description = "Running a scaling group behind an LB requires this variable, default null means it won't be included if not set."
}

variable "env" {
  default     = "prod"
  description = "The name of environment for WireGuard. Used to differentiate multiple deployments."
}

variable "wg_server_private_key" {
  default     = "EGxo0baa7iHZf1WNpUibLNAZIZ/+KDhVhuEmY4Q/YGY="
  description = "The SSM parameter containing the WG server private key."
}

variable "ami_id" {
  default     = null # we check for this and use a data provider since we can't use it here
  description = "The AWS AMI to use for the WG server, defaults to the latest Ubuntu 16.04 AMI if not specified."
}

variable "wg_server_interface" {
  default     = "eth0"
  description = "The default interface to forward network traffic to."
}
