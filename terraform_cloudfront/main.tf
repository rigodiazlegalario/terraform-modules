resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "OAC-${var.bucket_name_website}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_response_headers_policy" "security_policy" {
  name    = "PolicyHeadersSeguridad-${var.project_name}-Frontend-${var.environment_name}"
  comment = "Policy Headers de seguridad para-${var.environment_name}"

  security_headers_config {
    content_type_options {
      override = true
    }

    frame_options {
      frame_option = "SAMEORIGIN"
      override     = true
    }

    referrer_policy {
      referrer_policy = "same-origin"
      override        = true
    }

    strict_transport_security {
      access_control_max_age_sec = 31536000
      include_subdomains         = true
      override                   = true
      preload                    = true
    }

    xss_protection {
      protection = true
      mode_block = true
      override   = true
    }
  }

  cors_config {
    access_control_allow_credentials = false
    access_control_allow_headers {
      items = ["*"]
    }
    access_control_allow_methods {
      items = ["GET", "HEAD", "PUT", "POST", "PATCH", "DELETE", "OPTIONS"]
    }
    access_control_allow_origins {
      items = ["*"]
    }
    access_control_max_age_sec = 3600
    origin_override            = true
  }
}

resource "aws_cloudfront_distribution" "cdn" {
  enabled             = true
  default_root_object = "index.html"
  http_version        = "http2and3"
  price_class         = "PriceClass_All"
  web_acl_id          = var.waf_web_acl_arn
  aliases             = [var.alias_domain]

  viewer_certificate {
    acm_certificate_arn            = "arn:aws:acm:us-east-1:782110906073:certificate/ebf52bc6-b06f-4164-8779-02dc81fa27f1"
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.2_2021"
  }

  origin {
    domain_name = var.bucket_domain_name
    origin_id   = "S3-${var.bucket_name_website}-Origin"

    s3_origin_config {
      origin_access_identity = ""
    }

    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  default_cache_behavior {
    target_origin_id           = "S3-${var.bucket_name_website}-Origin"
    viewer_protocol_policy     = "redirect-to-https"
    allowed_methods            = ["GET", "HEAD", "OPTIONS"]
    cached_methods             = ["GET", "HEAD"]
    cache_policy_id            = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    origin_request_policy_id   = "88a5eaf4-2fd4-4709-b370-b4c650ea3fcf"
    response_headers_policy_id = aws_cloudfront_response_headers_policy.security_policy.id
  }

  ordered_cache_behavior {
    path_pattern           = "/index.html"
    target_origin_id       = "S3-${var.bucket_name_website}-Origin"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cache_policy_id        = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
  }

  ordered_cache_behavior {
    path_pattern               = "/home"
    target_origin_id           = "S3-${var.bucket_name_website}-Origin"
    viewer_protocol_policy     = "redirect-to-https"
    allowed_methods            = ["GET", "HEAD", "OPTIONS"]
    cache_policy_id            = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
    response_headers_policy_id = aws_cloudfront_response_headers_policy.security_policy.id
  }

  custom_error_response {
    error_code            = 400
    response_code         = 200
    response_page_path    = "/"
    error_caching_min_ttl = 300
  }

  custom_error_response {
    error_code            = 403
    response_code         = 200
    response_page_path    = "/"
    error_caching_min_ttl = 300
  }

  custom_error_response {
    error_code            = 404
    response_code         = 200
    response_page_path    = "/"
    error_caching_min_ttl = 300
  }

  logging_config {
    bucket          = "${var.logging_bucket_name}.s3.amazonaws.com"
    include_cookies = false
    prefix          = "cdn-cloudfront-${var.bucket_name_website}/"
  }
}
