data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  for_each      = local.environment[terraform.workspace].instance_type
  ami           = data.aws_ami.ubuntu.id
  instance_type = each.value.instance_type
  key_name      = each.value.key_name
  subnet_id     = "subnet-03adca08d0aa69d1e"

  tags = local.tags
}
