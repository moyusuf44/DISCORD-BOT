resource "aws_s3_bucket" "terraform_state" {
  bucket = "moyusufs-discord-bot-terraform-state"

  tags = {
    Name        = "moyusufs-discord-bot-terraform-state"
    Environment = "dev"
  }
}

resource "aws_dynamodb_table" "terraform-discord-bot-state-lock" {
    name         = "terraform-discord-bot-state-lock"
    billing_mode = "PAY_PER_REQUEST"
    hash_key     = "LockID"

    attribute {
        name = "LockID"
        type = "S"
 
    }
}