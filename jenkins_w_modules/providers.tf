terraform {
  required_version = "~> 1.5.3"
  cloud {
    organization = "Dev_Practice"

    workspaces {
      name = "jenkins_module"
    }
  }
}