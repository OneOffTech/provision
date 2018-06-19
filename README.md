# Provision

This repository holds a sharable and "all configuration described in code" **provision and deployment system** around [Ansible](https://www.ansible.com/). It relies on a simple and encrypted [KeePass](https://keepass.info) storage file to manage the passwords of deployed machines.

## Requirements

However, in order to use this setup, none of the mentioned programs are a requirement, as it runs inside a [Docker](https://www.docker.com/) container and well defined through [Docker Compose](https://docs.docker.com/compose/). Just make sure you have those two installed.

## Configuration

Before you start, all essential things for Ansible need to be placed into the `data` directory. Please add:

* `data`/`ansible.hosts` - A typical [Ansible inventory](https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html) listing your machines, their IP addresses and SSH ports.
* `data`/`playbooks` - One or more [Ansible playbooks](https://docs.ansible.com/ansible/latest/user_guide/playbooks_intro.html) to be available.
* `data`/`roles` - The [Ansible roles](https://docs.ansible.com/ansible/devel/user_guide/playbooks_reuse_roles.html), which are available (if managing with git, they can be perfectly included as _[submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules)_).
* `data`/`ssh`/`id_rsa` - The private key of a ssh key pair to connect to machines.
* `data`/`ssh`/`id_rsa.pub` - The public key of a ssh key pair to connect to machines.
* `data`/`passwords.kdbx` - A [KeePass](https://keepass.info) database file, holding the passwords of the users on the deployed machines.

> You can also have a look at the [example data repository](https://github.com/OneOffTech/provision-data-example) to get a better idea.

You may want to put and manage all this private (!) data in a git repository, with obviously very restricted access to it (as it contains important keys). A git repository can be included nicely - as a _[submodule](https://git-scm.com/book/en/v2/Git-Tools-Submodules)_:

* `git submodule add https://github.com/OneOffTech/provision-data-example data`

> _Note:_ You may check the [`example-data`](https://github.com/OneOffTech/provision/tree/example-data) branch of this repository in order to see how the different repositories can be all included as git _submodules_: starting from the provision linking to the (private) data repository, and the roles inside this, again coming from different (probably public) sources.

## Server deployment

Deployment happens through a docker container which runs ansible.

* Apply everything to all: `docker-compose run --rm ansible_commander -i ansible.hosts playbooks/install.yml`
* Apply everything to one server: `docker-compose run --rm ansible_commander -i ansible.hosts -l YOURSERVER playbooks/install.yml`

## Local deployment

For local deployment,  the setup can not be deployed from a Docker container. Instead, Ansible must be installed:

```bash
ansible-playbook -i "localhost," -c 127.0.0.1 data/playbooks/install.yml
```
