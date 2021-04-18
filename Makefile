init-remote-state:
	cd remote-state && docker-compose run --rm --no-deps terraform init

apply-remote-state:
	cd remote-state && docker-compose run --rm --no-deps terraform apply

init:
	docker-compose run --rm --no-deps terraform init

validate:
	docker-compose run --rm --no-deps terraform validate

plan:
	docker-compose run --rm --no-deps terraform workspace select $(workspace)
	docker-compose run --rm --no-deps terraform plan -var-file=$(workspace).tfvars

apply:
	docker-compose run --rm --no-deps terraform workspace select $(workspace)
	docker-compose run --rm --no-deps terraform apply -var-file=$(workspace).tfvars

destroy:
	docker-compose run --rm --no-deps terraform workspace select $(workspace)
	docker-compose run --rm --no-deps terraform destroy -var-file=$(workspace).tfvars

refresh:
	docker-compose run --rm --no-deps terraform workspace select $(workspace)
	docker-compose run --rm --no-deps terraform refresh -var-file=$(workspace).tfvars

version:
	docker-compose run --rm --no-deps terraform version