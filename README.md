# Terraform file for AWS Route 53 and AWS ACM

This terraform file will creates (CNAME record) subdomain named book using aws route 53 and make request certificate using
 AWS Certificate Manager with new name (book), write new CNAME record for certificate.







```
# Configure the AWS Provider
provider "aws" {
  region            = var.aws_region
}


data "aws_route53_zone" "public" {
  name              = var.dns_zone
  private_zone      = false
}

# -----This create subdomain with name book -----
resource "aws_route53_record" "www-book" {
  zone_id           = var.zone_id
  name              = "www"
  type              = "CNAME"
  ttl               = var.ttl

weighted_routing_policy {
    weight          = 10
  }

  set_identifier    = var.set_name
  records           = ["${var.set_name}.${var.domain_name}"]
}


# ----- This creates an SSL certificate-----
resource "aws_acm_certificate" "cert" {
  domain_name       = "${var.set_name}.${var.domain_name}"
  validation_method = "DNS"
}

# -----This is a DNS record for the ACM certificate validation to prove we own the domain-----

resource "aws_route53_record" "cert_validation" {
  name              = aws_acm_certificate.cert.domain_validation_options.0.resource_record_name
  type              = aws_acm_certificate.cert.domain_validation_options.0.resource_record_type
  zone_id           = var.zone_id
  records           = ["${aws_acm_certificate.cert.domain_validation_options.0.resource_record_value}"]
  ttl               = var.ttl
}
###########################################################################
# -----This tells terraform to cause the route53 validation to happen-----
#
#resource "aws_acm_certificate_validation" "cert" {
#  certificate_arn         = aws_acm_certificate.cert.arn
#  validation_record_fqdns = [aws_route53_record.cert_validation.fqdn]
#}
###########################################################################
```



# Conclusion: You just need to change variables.tf file with your data.



