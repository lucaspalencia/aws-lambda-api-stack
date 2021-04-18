# AWS lambda API stack with Terraform

## Requirements

To run this project you must have installed:

- [docker](https://www.docker.com/)
- [docker-compose](https://docs.docker.com/compose/)
- [GNU make](https://www.gnu.org/software/make/)

## Running

Firstly, make a copy of the `.env_template` naming it `.env` and change
the variables inside the file with your AWS credentials

### S3 backend

Stores the state as a given key in a given bucket on Amazon S3.

To create S3 bucket, change the `<BUCKET-NAME>` in `remote-state/main.tf` with the name of your choice and run:

```bash
make init-remote-state
make apply-remote-state
```

After the bucket is successfully created, change the`<BUCKET-NAME>` of terraform backend config in `main.tf`

### Environments

If you need to have multiple environments, e.g. dev, staging and production, you can use `terraform workspaces`.

You just need to create `.tfvars` files related to each workspace.

Examples:

```bash
default.tfvars     - dev environment
staging.tfvars     - staging environment
production.tfvars  - production environment
```

### Terraform commands

```bash
make init                         - equivalent to terraform init
make validate                     - equivalent to terraform validate
make plan workspace=$workspace    - equivalent to terraform plan
make apply workspace=$workspace   - equivalent to terraform apply
make destroy workspace=$workspace - equivalent to terraform destroy
make refresh workspace=$workspace - equivalent to terraform refresh
make version                      - equivalent to terraform version
```