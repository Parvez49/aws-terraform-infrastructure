# Bootstrap: Terraform state bucket

Creates the S3 bucket that every other root in this repository uses as its
remote backend. It has to exist before `terraform init` can succeed anywhere
else, which is why it lives outside `environments/`.

## This root uses local state, on purpose

There is no `backend.tf` here. The bucket cannot store its own state before it
exists, so `terraform.tfstate` is written next to this file and is gitignored.

**Consequence:** that local file is the only record of this bucket. Lose it and
the bucket keeps working, but Terraform no longer manages it.

Two ways to handle that:

1. **Leave it local (current choice).** Simple. The bucket is protected by
   `prevent_destroy`, and if the state file is lost it can be recovered with
   `terraform import aws_s3_bucket.terraform_state django-infrastructure-tfstate`.
2. **Migrate it into the bucket it created.** After the first successful apply,
   add a `backend.tf` pointing at `bootstrap/terraform.tfstate` in this same
   bucket and run `terraform init -migrate-state`. Self-referential but valid,
   since the bucket already exists by then.

Keep a copy of the local state file somewhere safe if you stay on option 1.

## Usage

```bash
cd bootstrap/state-bucket
terraform init
terraform plan
terraform apply
```

Run this once per AWS account. Afterwards, `terraform init` works in
`environments/dev` and `environments/staging`.

## Notes

- `prevent_destroy = true` on the bucket means `terraform destroy` fails by
  design. Remove the lifecycle block first if you genuinely intend to tear it down.
- Versioning is enabled and noncurrent versions expire after 90 days, keeping at
  least the 10 most recent regardless of age, so a bad apply stays recoverable
  without unbounded storage growth.
- State locking is handled by the S3 backend's `use_lockfile` option in each
  environment's `backend.tf`, so no DynamoDB table is needed.
