plugin "terraform" {
    enabled = true
    preset = "recommended"
}

rule "terraform_comment_syntax" {
    enabled = true
}

plugin "aws" {
    enabled = true
    version = "0.45.0"
    source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

# disabled for now.
# check github repo for update version
# plugin "opa" {
#   enabled = true
#   version = "0.9.0"
#   source  = "github.com/terraform-linters/tflint-ruleset-opa"
# }
