output "aws_ecs_cluster" {
    value = aws_ecs_cluster.this.name   
}

output "aws_ecs_service" {
    value = aws_ecs_service.this.name
}