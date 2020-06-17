# Terraform file for AWS Route 53 and AWS ACM

This terraform file will creates (CNAME record) subdomain named book using aws route 53 and make request certificate using
 AWS Certificate Manager with new name (book), write new CNAME record for certificate.

1. Install terraform:
 - Visit https://www.terraform.io/downloads.html to choose you OS and download terraform package
   example for linux:

 $  wget https://releases.hashicorp.com/terraform/0.12.26/terraform_0.12.26_linux_amd64.zip
 $  unzip terraform_0.12.26_linux_amd64.zip

    Move terraform to /usr/local/bin/terraform with next command:
 $  cp terraform /usr/local/bin/terraform

    You can check terraform version
 $  terraform -v
 > Terraform v0.12.26


2. Export AWS credential:

   export AWS_ACCESS_KEY_ID=your-access-key
   export AWS_SECRET_ACCESS_KEY=your-secret-key
   export AWS_DEFAULT_REGION=your-region

   NOTE: This user must have read/write access for Route 53 and AWS Certificate Manager.

3. Clone this repo and change variables.tf file with your data. All variables are marked where changes need to be made.

4. Follow to next commands to launch terraform:

 $  terrafom init   ''' # Terraform initialization '''
 $  terraform plan  ''' # You will see what terraform will create '''
 $  terraform apply ''' # Apply your plan and create infrastructure '''

    After command terraform apply you will able to see all changes at AWS сonsole



  File main.tf has the following form



``` main.tf
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
