#Set your public SSH key here
variable "ssh_key" {
  default = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK/5d3jAjWq1fOIyPk3jHMafTLJH6xqHv2bAZalQ/GaL leo@craftcat.dev"
}
variable "api_url" {
    default = "https://192.168.0.25:8006/api2/json"
}
#Blank var for use by terraform.tfvars
variable "user" {
}

variable "password" {
}

variable "email" {
}

variable "bitwarden_id" {
}

variable "bitwarden_secret" {
}


variable "master_password" {

}
