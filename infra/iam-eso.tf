############################
# External Secrets IAM
############################

# 1) Policy: what ESO can do in AWS
data "aws_iam_policy_document" "eso_week1_go_demo" {
  statement {
    sid = "AllowSecretsManagerRead"

    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecrets",
    ]

    # Keep it simple for now: all secrets.
    # Later you can narrow this to specific ARNs or tags.
    resources = ["*"]
  }

  statement {
    sid = "AllowSSMParameterRead"

    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters",
      "ssm:GetParametersByPath",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "eso_week1_go_demo" {
  name        = "eso-week1-go-demo-tf"
  description = "Permissions for External Secrets Operator for week1 go microservice"
  policy      = data.aws_iam_policy_document.eso_week1_go_demo.json
}

# 2) Trust policy: who can assume this role (IRSA)
# We use your existing EKS OIDC provider from the module.
data "aws_iam_policy_document" "eso_irsa_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [module.eks.oidc_provider_arn]
    }

    # This ties the role to a specific ServiceAccount in the cluster.
    # We’ll use:
    #   namespace: external-secrets
    #   serviceAccount: external-secrets
    #
    # (You’ll configure ESO Helm chart later to use this SA.)
    condition {
      test     = "StringEquals"
      # issuer URL without https://
      variable = "${replace(module.eks.cluster_oidc_issuer_url, "https://", "")}:sub"

      values = [
        "system:serviceaccount:external-secrets:external-secrets"
      ]
    }
  }
}

# 3) IAM Role for ESO
resource "aws_iam_role" "eso_week1_go_demo" {
  name               = "eso-week1-go-demo-role"
  assume_role_policy = data.aws_iam_policy_document.eso_irsa_assume_role.json

  tags = {
    Project     = "week1-go-microservice"
    Environment = "dev"
    Owner       = "Tomer"
    Purpose     = "ExternalSecretsOperator"
  }
}

# 4) Attach policy to role
resource "aws_iam_role_policy_attachment" "eso_week1_go_demo_attach" {
  role       = aws_iam_role.eso_week1_go_demo.name
  policy_arn = aws_iam_policy.eso_week1_go_demo.arn
}