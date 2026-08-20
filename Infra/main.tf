module "vpc" {
    source = "./modules/01-vpc"
}

module "ecr" {
    source = "./modules/02-ecr"

}

module "ecs" {
    source = "./modules/03-ecs"

    subnets         = module.vpc.public_subnets
    security_groups = [module.vpc.ecs_security_group]

    discord_bot_token = var.discord_bot_token
    cpu               = var.cpu
    memory            = var.memory
    image_id          = var.image_id
    desired_count     = var.desired_count
    cluster_name      = var.cluster_name
    service_name      = var.service_name
}

module "dynamodb" {
    source = "./modules/04-dynamodb"

    table_name = var.table_name
}

module "sqs" {
    source = "./modules/05-sqs"

    queue_name = var.queue_name
}

module "monitor" {
    source = "./modules/06-monitor"

    cluster_name = module.ecs.aws_ecs_cluster
    service_name = module.ecs.aws_ecs_service
}