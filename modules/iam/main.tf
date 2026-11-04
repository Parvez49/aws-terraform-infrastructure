# Environment / Project / ManagedBy come from the provider's default_tags in
# the environment root, so resources here only set Name.

data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ec2" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

  tags = {
    Name = var.role_name
  }
}

resource "aws_iam_instance_profile" "ec2" {
  name = var.role_name
  role = aws_iam_role.ec2.name

  tags = {
    Name = var.role_name
  }
}

# Scoped to the one bucket this application owns, rather than s3:* on "*".
data "aws_iam_policy_document" "s3_access" {
  statement {
    sid       = "ListOwnBucket"
    effect    = "Allow"
    actions   = ["s3:ListBucket", "s3:GetBucketLocation"]
    resources = [var.storage_bucket_arn]
  }

  statement {
    sid    = "ReadWriteOwnObjects"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
    ]
    resources = ["${var.storage_bucket_arn}/*"]
  }
}

resource "aws_iam_role_policy" "s3_access" {
  name   = "${var.role_name}-s3-access"
  role   = aws_iam_role.ec2.id
  policy = data.aws_iam_policy_document.s3_access.json
}

# Optional: lets you open a shell via SSM Session Manager, which means SSH (and
# the ssh_cidrs allowlist) stops being the only way in.
resource "aws_iam_role_policy_attachment" "ssm" {
  count = var.enable_ssm_access ? 1 : 0

  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
