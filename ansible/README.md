# Environment setup

Install Ansible and collections:
```
pip3 install --user -r requirements.txt
echo "export ANSIBLE_NOCOWS=1" >> ~/.bashrc
ansible-galaxy install -r requirements.yml
```

Apply patches ([cloudalchemy.ansible-node-exporter#230](https://github.com/cloudalchemy/ansible-node-exporter/issues/230)):
```
patch -p0 < patches/0001-cloudalchemy-node-exporter-stdout.patch
```

Setup repository:
```
git submodule update --init
```

Run test playbook:
```
BASTION_HOST=***OBFUSCATED*** ansible-playbook playbooks/hello.yml
```
