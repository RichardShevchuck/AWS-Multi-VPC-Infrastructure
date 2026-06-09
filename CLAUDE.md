# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Purpose

Packer-based golden AMI pipeline for AWS. Produces hardened Ubuntu 22.04 images pre-installed with Apache2, AWS SSM Agent, and CloudWatch Agent. Part of a broader VPC architecture project (Terraform infra tracked in `.gitignore` but not yet present).

## Packer Commands

```bash
# Initialize plugins (required once after clone)
packer init packer/

# Validate configuration
packer validate -var-file=packer/golden-ami.pkrvars.hcl packer/

# Format HCL files
packer fmt packer/

# Build AMI (requires AWS credentials in environment)
packer build -var-file=packer/golden-ami.pkrvars.hcl packer/

# Build with inline variable overrides
packer build -var="environment=prod" -var="aws_region=us-east-1" packer/
```

## Architecture

**Build flow:** `variables.pkr.hcl` declares inputs → `golden-ami.pkr.hcl` pulls the latest Canonical Ubuntu 22.04 AMI (owner `099720109477`), launches a `t3.micro` builder, runs shell provisioner, snapshots the result.

**AMI naming:** `{ami_name}-{environment}-{YYYYMMDD-HHmmss}` — timestamp injected via `locals` block, preventing name collisions across builds.

**Variable overrides:** Supply `packer/golden-ami.pkrvars.hcl` (gitignored) for environment-specific values. Defaults in `variables.pkr.hcl` target `us-east-2` / `dev`.

## AWS Credentials

Packer uses the standard AWS credential chain (env vars, `~/.aws/credentials`, instance role). Set before building:

```bash
export AWS_ACCESS_KEY_ID=...
export AWS_SECRET_ACCESS_KEY=...
export AWS_DEFAULT_REGION=us-east-2
```

## Gitignore Notes

`packer/golden-ami.pkrvars.hcl` is gitignored (may contain secrets). `terraform/` paths are pre-ignored for planned Terraform work.
