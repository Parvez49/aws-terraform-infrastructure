# django-terraform-infrastructure

AWS infrastructure for a Django application, managed with Terraform. Built as a
learning project, so the layout and conventions aim to match what a production
repository would look like rather than the shortest path to a running instance.

## Layout

```
bootstrap/state-bucket/   S3 bucket holding remote state. Apply this first.
environments/dev/         Dev root: network, security, IAM, compute, storage
environments/staging/     Staging root: storage only, so far
environments/production/  Placeholder, not built yet
modules/network/          VPC, subnets, internet gateway, route tables
modules/security/         EC2 security group and its rules
modules/compute/          SSH key pair and EC2 instance
modules/storage/          Application S3 bucket
modules/iam/              EC2 instance role and profile
modules/database/         Placeholder, not built yet
modules/django/           Placeholder, not built yet
docs/                     Notes taken while learning
```

Environment roots are thin: they pick values and wire modules together. All
resource definitions live in `modules/`.

## Prerequisites

- Terraform >= 1.10 (the S3 backend's `use_lockfile` option requires it)
- AWS credentials with permission to manage VPC, EC2, S3 and IAM
- An SSH key pair; the public half is committed as
  `environments/dev/aws-django-dev.pub`

## First-time setup

The state bucket has to exist before any environment can initialise.

```bash
cd bootstrap/state-bucket
terraform init
terraform apply
```

See `bootstrap/state-bucket/README.md` for why that root uses local state.

## Working on an environment

```bash
cd environments/dev
cp terraform.tfvars.example terraform.tfvars   # then edit it
terraform init
terraform plan
terraform apply
```

`terraform.tfvars` is gitignored. For dev it **must** set `ssh_cidrs`, which has
no default on purpose: an empty default would quietly strip every SSH rule from
the security group on the next apply, whereas a missing value fails immediately.

Find your current public IP with:

```bash
curl -s https://checkip.amazonaws.com
```

## Conventions

- **Tagging.** `Environment`, `Project` and `ManagedBy` come from `default_tags`
  on the provider in each environment root. Modules only set their own `Name`.
- **Variables.** Every variable and output carries a description. Values that
  constrain infrastructure get a `validation` block.
- **No hardcoded CIDRs in modules.** Subnet ranges are variables, so a module
  can be reused for another environment.
- **Secrets.** Nothing secret is committed. Public IP allowlists live in
  `terraform.tfvars` locally and in the `SSH_CIDRS` repository variable in CI.

## Local checks

```bash
pre-commit install          # once
pre-commit run --all-files  # fmt, validate, tflint, checkov, private-key scan
```

Or individually:

```bash
terraform fmt -check -recursive
tflint --recursive
checkov --directory . --config-file .checkov.yml
```

`.checkov.yml` documents every suppressed check and why. Anything not listed
there fails CI, so new findings have to be triaged rather than ignored.

## CI/CD

| Workflow               | Trigger                        | Does                                              |
| ---------------------- | ------------------------------ | ------------------------------------------------- |
| `terraform-ci.yml`     | PR, push to main               | `fmt -check`, `validate`, TFLint, Checkov         |
| `terraform-plan.yml`   | PR, push to main               | `terraform plan`; uploads the plan on main        |
| `terraform-apply.yml`  | Manual dispatch                | Applies a previously uploaded plan                |

Applying is deliberately manual. `terraform-apply.yml` takes the run ID of a
plan, verifies that run really came from `terraform-plan.yml` on a successful
push to `main`, checks out the exact commit that produced the plan, and only
then applies the saved plan file. It also requires typing `APPLY` to confirm.

### Required repository configuration

| Kind     | Name                    | Purpose                                      |
| -------- | ----------------------- | -------------------------------------------- |
| Secret   | `AWS_ACCESS_KEY_ID`     | AWS credentials for plan and apply           |
| Secret   | `AWS_SECRET_ACCESS_KEY` | AWS credentials for plan and apply           |
| Variable | `SSH_CIDRS`             | JSON list, e.g. `["203.0.113.4/32"]`         |

GitHub Environments named `dev` and `staging` gate the apply workflow; add
required reviewers there to get an approval step.

## Known limitations

These are deliberate trade-offs for a cost-controlled learning account, not
oversights:

- **Static AWS keys in CI.** OIDC with a `role-to-assume` is the better pattern
  and is free on every account, including free tier. Worth migrating to.
- **Single availability zone.** One public and one private subnet in
  `ap-southeast-2a`. No high availability.
- **No NAT gateway.** The private subnet has no route to the internet, so
  nothing there can reach package repositories.
- **No VPC flow logs, no S3 access logging, no cross-region replication.** All
  billable; suppressed in `.checkov.yml` with reasons.
- **SSE-S3 rather than SSE-KMS** on both buckets, to avoid KMS key charges.
- **`production` is an empty placeholder** with no backend or provider config.
