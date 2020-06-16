variable "aws_region" {
  description = "The region to create resources."
  default     = "eu-central-1"                 # This place need to be changed
}

variable "ttl" {
  description = "TTL record"
  default     = 300                            # This place need to be changed
}


variable "zone_id" {
  type        = string
  default     = "Z068026798668N0VC7MD"         # This place need to be changed

}


variable "dns_zone" {
  type        = string
  default     = "yuriyexample.com."            # This place need to be changed

}


variable "domain_name" {
  type        = string
  default     = "yuriyexample.com"             # This place need to be changed

}

variable "set_name" {
  type        = string
  default     = "book"                         # This place need to be changed

}
