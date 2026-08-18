terraform {
    backend "s3" {
        bucket         = "moyusufs-discord-bot-terraform-state"
        key            = "discord-bot/terraform.tfstate"
        region         = "eu-north-1"
        dynamodb_table = "terraform-discord-bot-state-lock"
        encrypt        = true 
    }
}