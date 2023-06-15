env = "dev"

components = {
  frontend = {
    name          = "frontend"
    instance_type = "t3.small"
  }
  mongodb = {
    name          = "mongodb"
    instance_type = "t3.small"
  }
  catalogue = {
    name          = "catalogue"
    instance_type = "t3.micro"
  }

  redis = {
    name          = "redis"
    instance_type = "t3.small"
  }

  user = {
    name          = "user"
    instance_type = "t3.micro"
  }
}