FROM debian:buster
RUN apt-get update && apt-get upgrade -y && apt-get install -y curl unzip python3-pip
RUN pip3 install --upgrade pip
RUN pip3 install python-openstackclient python-novaclient ovhcli
RUN curl -s -L https://releases.hashicorp.com/terraform/1.0.9/terraform_1.0.9_linux_amd64.zip > /tmp/terraform_1.0.9_linux_amd64.zip \
        && cd /tmp && unzip /tmp/terraform_1.0.9_linux_amd64.zip && mv terraform /usr/local/bin/ && rm -f /tmp/terraform_1.0.9_linux_amd64.zip \
        && touch ~/.bashrc && terraform -install-autocomplete
