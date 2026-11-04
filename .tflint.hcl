config {
  call_module_type = "all"
}

# Bundled with tflint, so it needs no version pin or plugin download.
# Catches unused declarations, missing versions, naming conventions,
# deprecated syntax and undocumented variables/outputs.
plugin "terraform" {
  enabled = true
  preset  = "recommended"
}

# The AWS ruleset adds provider-specific checks, such as rejecting invalid
# instance types and unsupported attribute combinations. It must be pinned to
# an exact version, so set this to the current release before enabling:
#   https://github.com/terraform-linters/tflint-ruleset-aws/releases
#
# plugin "aws" {
#   enabled = true
#   version = "<latest>"
#   source  = "github.com/terraform-linters/tflint-ruleset-aws"
# }
