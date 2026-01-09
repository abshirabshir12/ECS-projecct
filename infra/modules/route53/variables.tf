variable "dns_name" {
  type        = string
  description = "The DNS name of the ALB"
}

variable "zone_id" {
  type        = string
  description = "The hosted zone ID of the ALB"
}

variable "domain_name" {
  type    = string
  default = "lab.abshirabshir.co.uk"
}

variable "hosted_zone_id" {
  type    = string
  default = "Z0420365QZU98VBUGSGV"
}

