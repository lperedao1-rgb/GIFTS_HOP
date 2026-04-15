resource "docker_network" "app_network" {
  name = "app_network"
}
resource "docker_image" "web_image" {
  name = "web_localhost_01_img"

  build {
    context    = "../src/web"
    dockerfile = "Dockerfile"
  }
}

resource "docker_container" "web_container" {
  name  = "web_localhost_01"
  image = docker_image.web_image.image_id

  networks_advanced {
    name = docker_network.app_network.name
  }

  ports {
    internal = 80
    external = var.web_port
  }
}
resource "docker_image" "api_image" {
  name = "api01_img"

  build {
    context    = "../src/api"
    dockerfile = "Dockerfile"
  }
}

resource "docker_container" "api_container" {
  name  = "api01"
  image = docker_image.api_image.image_id

  networks_advanced {
    name = docker_network.app_network.name
  }

  ports {
    internal = 3000
    external = var.api_port
  }
}

resource "docker_image" "mysql_image" {
  name = "mysql:8.0"
}

resource "docker_container" "mysql_container" {
  name  = "mysql"
  image = docker_image.mysql_image.image_id

  networks_advanced {
    name = docker_network.app_network.name
  }

  ports {
    internal = 3306
    external = 4003
  }

  env = [
    "MYSQL_ROOT_PASSWORD=root",
    "MYSQL_DATABASE=appdb",
    "MYSQL_USER=user",
    "MYSQL_PASSWORD=1234"
  ]
}

