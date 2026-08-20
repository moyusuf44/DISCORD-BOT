resource "aws_ecs_cluster" "this" {
    name = var.cluster_name

    setting {
        name  = "containerInsights"
        value = "enabled"
    }
}

resource "aws_ecs_task_definition" "this" {
    family                   = "discord-bot-task"
    requires_compatibilities = ["FARGATE"]

    network_mode = "awsvpc"
    
    cpu    = var.cpu
    memory = var.memory

    execution_role_arn = aws_iam_role.ecs_task_execution_role.arn 

    container_definitions = jsonencode ([
        {
            name  = "discord-bot"
            image = var.image_id

            secrets = [
            {
            name      = "DISCORD_BOT_TOKEN"
            valueFrom = aws_secretsmanager_secret.discord_bot_token.arn
            }
            ]

            logConfiguration = {
                logDriver = "awslogs"

                options = {
                    awslogs-group         = "/ecs/discord-bot"
                    awslogs-region        = "eu-north-1"
                    awslogs-stream-prefix = "ecs"
                }
            }
        }
    ])
}

resource "aws_ecs_service" "this" {
    name            = var.service_name
    cluster         = aws_ecs_cluster.this.id 
    task_definition = aws_ecs_task_definition.this.id

    launch_type   = "FARGATE"
    desired_count = var.desired_count

    network_configuration {
        subnets          = var.subnets
        security_groups  = var.security_groups 
        assign_public_ip = true 
    }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "discordBotEcsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}