resource "aws_cloudwatch_log_group" "this" {
    name              = "/ecs/discord-bot"
    retention_in_days = 7
}

resource "aws_cloudwatch_metric_alarm" "this" {
    alarm_name          = "discord-bot-high-cpu"
    comparison_operator = "GreaterThanThreshold"
    evaluation_periods  = 2
    metric_name         = "CPUUtilization"
    namespace           = "AWS/ECS"
    period              = 300
    statistic           = "Average"
    threshold           = 80

    dimensions = {
        ClusterName = var.cluster_name
        ServiceName = var.service_name
    }

    alarm_description = "Discord bot ECS service CPU usage is high"
}

