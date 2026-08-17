resource "aws_ecr_repository" "this" {
    name = "discord-bot"

    image_scanning_configuration {
        scan_on_push = true
    }
}