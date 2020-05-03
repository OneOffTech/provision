# Ansible-Keepass

This repository holds a "all configuration described in code" **provision and
deployment system** around [Ansible](https://www.ansible.com/). Additionally it
relies on a simple and encrypted [KeePass](https://keepass.info) storage file to
manage the passwords of deployed machines.

## Requirements

[Docker](https://www.docker.com/) and [Docker
Compose](https://docs.docker.com/compose/) will have to be already installed on
the host system.

## Configuration

Before you start, all essential things for Ansible need to be placed into the
`data` directory. Please add:

- `data`/`ansible.hosts` - A typical [Ansible
  inventory](https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html)
  listing your machines, their IP addresses and SSH ports.
- `data`/`group_vars` - Directory containing [Group specific
  variables](https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html#variable-precedence-where-should-i-put-a-variable)
  for the deployment.
  - `data`/`host_vars` - Directory containing [Host specific
    variables](https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html#variable-precedence-where-should-i-put-a-variable)
    for the deployment.
- `data`/`playbooks` - One or more [Ansible
  playbooks](https://docs.ansible.com/ansible/latest/user_guide/playbooks_intro.html)
  to be available.
- `data`/`roles` - The [Ansible
  roles](https://docs.ansible.com/ansible/devel/user_guide/playbooks_reuse_roles.html),
  which are available (if managing with git, they can be perfectly included as
  _[submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules)_).
- `data`/`ssh`/`id_rsa` - The private key of a ssh key pair to connect to
  machines.
- `data`/`ssh`/`id_rsa.pub` - The public key of a ssh key pair to connect to
  machines.
- `data`/`passwords.kdbx` - A [KeePass](https://keepass.info) database file,
  holding the passwords of the users on the deployed machines.

> You can also have a look at the [example data
> repository](https://github.com/OneOffTech/provision-data-example) to get a
> better idea.

## Server deployment

Deployment happens through a Docker container which runs Ansible.

- Apply everything to all: `docker-compose run --rm ansible_commander -i ansible.hosts playbooks/install.yml`
- Apply everything to one server: `docker-compose run --rm ansible_commander -i ansible.hosts -l YOURSERVER playbooks/install.yml`

### Only run certain roles

To save time, you can tell ansible to only run certain playbooks by supplying
the `--tags` flag, which can use multiple parameters. A simple example would be
`--tags="kbox,vpn"`. To see a list of defined tags, you can check the site.yml.

### Check for changed configuration

To see the differences between the server and the configured playbooks, add the
`--check` flag. To highlight the current state and proposed changes,
additionally use the `--diff` flag.

For configuration of the individual roles, please check out the respective
`README.md` files in the `roles/` directory.
