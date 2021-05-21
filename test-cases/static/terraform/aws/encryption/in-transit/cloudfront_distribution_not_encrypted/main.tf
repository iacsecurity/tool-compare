provider "aws" {
  region = "us-east-1"
}

locals {
  name         = "cloudfront-dist-non-encrypted"
  s3_origin_id = "cloudfront-dist-non-encrypted-bucket"
}

resource "aws_s3_bucket" "cdn-content" {
  bucket = local.name
  acl    = "private"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "AllowCloudFrontOAI",
  "Statement": [
    {
      "Sid": "AllowCloudFrontOAI",
      "Effect": "Allow",
      "Principal": {
        "CanonicalUser": "${aws_cloudfront_origin_access_identity.oai.s3_canonical_user_id}"
      },
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::${local.name}/*"
    }
  ]
}
POLICY
}

resource "aws_s3_bucket_public_access_block" "cdn-content" {
  bucket                  = aws_s3_bucket.cdn-content.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = local.name
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  enabled             = true
  price_class         = "PriceClass_200"
  default_root_object = "index.html"
  comment             = local.name

  origin {
    domain_name = aws_s3_bucket.cdn-content.bucket_regional_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = join("",
        ["origin-access-identity/cloudfront/",
        aws_cloudfront_origin_access_identity.oai.id]
      )
    }
  }

  custom_error_response {
    error_caching_min_ttl = 300
    error_code            = 403
    response_code         = 404
    response_page_path    = "/404.html"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = local.s3_origin_id
    viewer_protocol_policy = "allow-all"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  # Cache behavior with precedence 0
  ordered_cache_behavior {
    path_pattern           = "/path01/*"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    target_origin_id       = local.s3_origin_id
    viewer_protocol_policy = "allow-all"

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }
  }

  # Cache behavior with precedence 1
  ordered_cache_behavior {
    path_pattern           = "/path02/*"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = local.s3_origin_id
    viewer_protocol_policy = "allow-all"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }
}
