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
- `data`/`ssh`/`known_hosts` - The list of RSA key for known SSH hosts.
- `data`/`passwords.kdbx` - A [KeePass](https://keepass.info) database file,
  holding the passwords of the users on the deployed machines.

> You can also have a look at the [example data
> repository](https://github.com/OneOffTech/provision-data-example) to get a
> better idea.

## Usage

We use a Docker container to run the playbooks. 

Once the [configuration](#configuration) files are placed in 
the `data` folder grab the provided 
[`docker-compose.yml`](./docker-compose.yml) file.

```bash
docker-compose run --rm ansible -i {ansible_hosts} {playbook}

# e.g. docker-compose run --rm ansible -i ansible.hosts playbooks/install.yml
```

Where `{ansible_hosts}` is the file that contains the Ansible inventory and `{playbook}` is 
the path to the playbook to run.

You will be asked to type the keepass password before the playbook is executed.

### Only run on specific hosts

If you would like to limit the execution only to a 
[subset of hosts](https://docs.ansible.com/ansible/latest/user_guide/intro_patterns.html#patterns-and-ansible-playbook-flags).

To achieve that you can pass the `--limit` option

```bash
docker-compose run --rm ansible -i {ansible_hosts} --limit {hosts} {playbook}

# e.g. docker-compose run --rm ansible -i ansible.hosts --limit 'host1,host2' playbooks/install.yml
```

Where `{hosts}` could be a single or a list of hostnames defined in 
the `{ansible_hosts}` file, e.g. `'host1'`, `'host1,host2'`.

### Only run certain roles

To save time, you can tell Ansible to only run certain roles within playbooks by supplying
the `--tags` flag. A simple example would be `--tags="docker,redis"`. The 
[tags](https://docs.ansible.com/ansible/latest/user_guide/playbooks_tags.html) are defined
at the playbook level, so the list of available tags can be found in the specific playbook.

```bash
docker-compose run --rm ansible -i {ansible_hosts} --tags={tags} {playbook}

# e.g. docker-compose run --rm ansible -i ansible.hosts --tags="docker,redis" playbooks/install.yml
```

### Check for changed configuration

To see the differences between the server and the configured playbooks, add the
`--check` flag. To highlight the current state and proposed changes,
additionally use the `--diff` flag.

## Troubleshooting

#### Failed to connect as known hosts do not include a key for the specified host

On your remote host grab the RSA key of your server, where `{server_ip}` is 
your server's IP address, such as 192.168.2.1

```bash
ssh-keyscan -t rsa {server_ip}
```

The output will look like:

```
# {server_ip}:22 SSH-2.0-OpenSSH_7.9p1 Debian-10+deb10u2
{server_ip} ssh-rsa AAAAB3NzaC1y....
```

Copy the entire response line `{server_ip} ssh-rsa AAAAB3NzaC1y...` 
and add this key to the bottom of your ssh known hosts file.

> You should have a `known_hosts` file under the `data` folder based on the 
suggested [configuration](#configuration)


#### Unprotected private key file

An error on the permissions of the `id_rsa` key could be generated if the key is mounted
from a Windows host, or if a wrong permissions are set.

The permissions of the files under `.ssh` keys should be `600 (-rw-------)`.

Typically you want the permissions to be:

- `.ssh` directory: `700 (drwx------)`
- public key (`.pub` file): `644 (-rw-r--r--)`
- private key (`id_rsa`): `600 (-rw-------)`

## License

This project is licensed under the MIT license, see [LICENSE.txt](./LICENSE.txt).
