# Setup

```
curl -s https://releases.hashicorp.com/terraform/1.0.9/terraform_1.0.9_linux_amd64.zip > /tmp/terraform_1.0.9_linux_amd64.zip
unzip /tmp/terraform_1.0.9_linux_amd64.zip
```

# Run Terraform

```
read -s OS_PASSWORD
export OS_PASSWORD
./terraform init
./terraform apply
./terraform destroy
```
