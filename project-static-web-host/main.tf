resource "random_id" "rand_id" {
  byte_length = 8
}

resource "aws_s3_bucket" "mywebapp_bucket" {
  bucket = "shrinath-bucket-${random_id.rand_id.hex}"
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.mywebapp_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "mywebapp" {
  bucket = aws_s3_bucket.mywebapp_bucket.id
  policy = jsonencode(
    {
      Version = "2012-10-17",
      Statement = [
        {
          Sid       = "PublicReadGetObject",
          Effect    = "Allow",
          Principal = "*",
          Action    = "s3:GetObject",
          Resource  = "arn:aws:s3:::${aws_s3_bucket.mywebapp_bucket.id}/*"
        }
      ]
    }
  )
}

resource "aws_s3_bucket_website_configuration" "mywebapp" {
  bucket = aws_s3_bucket.mywebapp_bucket.id

  index_document {
    suffix = "index.html"
  }

  depends_on = [aws_s3_bucket.mywebapp_bucket]
}

resource "aws_s3_object" "index_html" {
  bucket       = aws_s3_bucket.mywebapp_bucket.bucket
  source       = "/home/shrinath/Terraform/practice1/project-static-web-host/Grandcoffee Free Website Template - Free-CSS.com/html/index.html"
  key          = "index.html"
  content_type = "text/html"

  depends_on = [aws_s3_bucket.mywebapp_bucket]
}

resource "aws_s3_object" "style_css" {
  bucket       = aws_s3_bucket.mywebapp_bucket.bucket
  source       = "/home/shrinath/Terraform/practice1/project-static-web-host/Grandcoffee Free Website Template - Free-CSS.com/html/css/style.css"
  key          = "style.css"
  content_type = "text/css"

  depends_on = [aws_s3_bucket.mywebapp_bucket]
}

output "random_id" {
  value = random_id.rand_id.hex
}

output "Website_url" {
  value = aws_s3_bucket.mywebapp_bucket.website_endpoint
}
