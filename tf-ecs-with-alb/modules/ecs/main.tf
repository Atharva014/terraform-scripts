# ECS cluster
resource "aws_ecs_cluster" "this" {
  name = "hello-ecr-cluster"
}

# Task Execution Role
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

# Attach AWS managed policy for ECS task execution
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ECS task definition
resource "aws_ecs_task_definition" "this" {
  family = "hello-ecr-task"
  requires_compatibilities = [ "FARGATE" ]
  network_mode = "awsvpc"
  cpu = "256"
  memory = "512"
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  container_definitions = jsonencode([
    {
        name = "hello-ecr-container"
        image = "abhise203/hello-ecr-app:v1.0"
        essential = true

        portMappings = [{
            containerPort = 3000
            protocol      = "tcp"
        }]

        logConfiguration = {
            logDriver = "awslogs"
            options = {
                "awslogs-group"         = "/ecs/my-app"
                "awslogs-region"        = var.region
                "awslogs-stream-prefix" = "ecs"
            }
        }
    }])
}

# CloudWatch Log Group for container logs
resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/my-app"
  retention_in_days = 7
}

# ECS service
resource "aws_ecs_service" "this" {
  name = "hello-ecr-service"
  cluster = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count = 1
  launch_type = "FARGATE"
  network_configuration {
    subnets = var.subnet_ids
    security_groups = [ aws_security_group.ecs_tasks.id ]
    assign_public_ip = true
  }
}

resource "aws_security_group" "ecs_tasks" {
  name = "hello-ecr-sg"
  description = "Allow inbound traffic on port 3000"
  vpc_id = var.vpc_id
  ingress {
    from_port = 3000
    to_port = 3000
    protocol = "tcp"
    cidr_blocks =  [ "0.0.0.0/0" ]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}