# Environment / Project / ManagedBy come from the provider's default_tags in
# the environment root, so resources here only set Name.

resource "aws_key_pair" "main" {
  key_name   = var.key_name
  public_key = file(pathexpand(var.public_key_path))

  tags = {
    Name = var.key_name
  }
}

resource "aws_instance" "main" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  associate_public_ip_address = true

  key_name = aws_key_pair.main.key_name

  # Lets the instance reach AWS APIs through a role instead of long-lived
  # access keys baked into the application config.
  iam_instance_profile = var.iam_instance_profile_name

  root_block_device {
    volume_size           = var.root_volume_size
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }

  metadata_options {
    http_tokens = "required"
  }

  monitoring = false

  tags = {
    Name = var.instance_name
  }
}
