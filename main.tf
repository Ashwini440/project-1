provider "aws" {
  region = "ap-south-1"
  access_key = "AKIA4ZTOONJHYMUXI7DO"
  secret_key = "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"
}

resource "aws_instance" "test-server" {
    ami = "ami-007020fd9c84e18c7"
    instance_type = "t2.micro"  
    key_name = "project-1"
}
