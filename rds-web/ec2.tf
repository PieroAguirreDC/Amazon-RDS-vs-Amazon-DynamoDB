# Paso 1 y 3 del tutorial: EC2 con Amazon Linux 2023 y servidor web Apache + PHP.
# Al arrancar ejecuta user-data.sh: instala paquetes, crea dbinfo.inc y SamplePage.php.
data "aws_ssm_parameter" "al2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

resource "aws_instance" "web" {
  ami                         = data.aws_ssm_parameter.al2023.value
  instance_type               = var.ec2_tipo
  subnet_id                   = data.aws_subnets.default.ids[0]
  vpc_security_group_ids      = [aws_security_group.ec2.id]
  associate_public_ip_address = true

  metadata_options {
    http_tokens = "required"
  }

  user_data = templatefile("${path.module}/user-data.sh", {
    db_endpoint = aws_db_instance.mysql.address
    db_usuario  = aws_db_instance.mysql.username
    db_clave    = random_password.db.result
    db_nombre   = aws_db_instance.mysql.db_name
    pagina_b64  = filebase64("${path.module}/app/SamplePage.php")
  })
  user_data_replace_on_change = true

  tags = { Name = "tutorial-ec2-instance-web-server" }
}