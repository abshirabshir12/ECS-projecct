variable "zone_id" {
  type    = string
  default = "Z0420365QZU98VBUGSGV"
}

variable "domain_name" {
  type = string
}


variable "ttl" {
  type    = number
  default = 300
}

variable "project_name" {
  type = string
}
variable "subject_alternative_names" {
  type    = list(string)
  default = []
}