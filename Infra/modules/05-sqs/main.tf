resource "aws_sqs_queue" "dlq" {
    name = "${var.queue_name}-dlq"
}

resource "aws_sqs_queue" "this" {
    name = var.queue_name

    visibility_timeout_seconds = 60
    message_retention_seconds  = 86400
    receive_wait_time_seconds  = 10

    redrive_policy = jsonencode ({
        deadLetterTargetArn = aws_sqs_queue.dlq.arn
        maxReceiveCount = 3
    })
}