resource "aws_elasticache_cluster" "instance" {
  cluster_id           = "redis-cluster"
  engine               = "redis"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis6.x"
  engine_version       = "6.x"
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.instance.name
  security_group_ids   = [aws_security_group.redis_security_group.id]
}

resource "aws_elasticache_subnet_group" "instance" {
  name       = "redis-subnet-group"
  subnet_ids = [aws_subnet.private.id]
}
