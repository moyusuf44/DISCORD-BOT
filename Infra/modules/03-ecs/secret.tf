resource "aws_secretsmanager_secret" "discord_bot_token" {
    name = "discord-bot/discord-bot-key"
}

resource "aws_iam_role_policy" "secrets_manager" {
    name = "ecs-secrets-manager"
    role = aws_iam_role.ecs_task_execution_role.id

    policy = jsonencode({
        Version = "2012-10-17"

        Statement = [
            {
                Effect = "Allow"

                Action = [
                    "secretsmanager:GetSecretValue"
                ]

                Resource = aws_secretsmanager_secret.discord_bot_token.arn
            }
        ]
    })
}

resource "aws_secretsmanager_secret_version" "discord_bot_token" {
    secret_id = aws_secretsmanager_secret.discord_bot_token.id

    secret_string = var.discord_bot_token
}