resource "aws_vpc" "instance" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "instance" {
  vpc_id = aws_vpc.instance.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.instance.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.instance.id
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.instance.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.instance.id
  }
}

resource "aws_route_table_association" "public" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public.id
}

resource "aws_route_table_association" "private" {
  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.private.id
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.instance.id
  cidr_block = "10.0.0.0/17"
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.instance.id
  cidr_block = "10.0.128.0/17"
}

resource "aws_nat_gateway" "instance" {
  allocation_id = aws_eip.instance.id
  subnet_id     = aws_subnet.public.id
}

resource "aws_eip" "instance" {
  vpc = true
}

resource "aws_security_group" "lambda_security_group" {
  vpc_id = aws_vpc.instance.id
  name   = "lambda-security-group"
}

resource "aws_security_group_rule" "lambda_redis_egress_rule" {
  type                     = "egress"
  protocol                 = "tcp"
  from_port                = aws_elasticache_cluster.instance.port
  to_port                  = aws_elasticache_cluster.instance.port
  security_group_id        = aws_security_group.lambda_security_group.id
  source_security_group_id = aws_security_group.redis_security_group.id
}

resource "aws_security_group_rule" "lambda_public_internet_egress_rule" {
  type              = "egress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lambda_security_group.id
}

resource "aws_security_group" "redis_security_group" {
  vpc_id = aws_vpc.instance.id
  name   = "redis-security-group"
}

resource "aws_security_group_rule" "redis_ingress_rule" {
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = aws_elasticache_cluster.instance.port
  to_port                  = aws_elasticache_cluster.instance.port
  security_group_id        = aws_security_group.redis_security_group.id
  source_security_group_id = aws_security_group.lambda_security_group.id
}
