# Mac Ansible Playbook

An Ansible playbook to set up and maintain my Mac: Homebrew packages, casks and Mac App Store apps, zsh and git configuration, SSH config and Node.js.

## What it manages

- **Packages**: Homebrew formulae, casks and Mac App Store apps
- **Shell**: oh-my-zsh, plugins, aliases, `~/.zprofile` and `~/.zshrc`
- **Git**: `~/.gitconfig`, global gitignore, commit template, aliases, commit signing
- **SSH**: `~/.ssh/config`
- **Node.js**: nvm and a default Node.js version

## Install

Homebrew is needed, see https://brew.sh/ to install it.

Clone the repository:

```shell
$ xcode-select --install
$ git clone git@github.com:notFloran/mac-playbook.git ~/.mac-playbook
```

Create your configuration:

```shell
$ cd ~/.mac-playbook
$ touch config.yml
$ vim config.yml
```

`config.yml` overrides the values of `default.config.yml`. Example:

```yaml
---
edit_dev_config_with: code

homebrew_cask_packages:
  - iterm2
  - visual-studio-code

homebrew_packages:
  - jq
  - gh

mas_installed_apps:
  - 937984704 # Amphetamine

zsh_theme: agnoster

git_user_name: John Doe
git_user_email: john@doe.fr
```

Then bootstrap the machine:

```shell
# Edit your bashrc or zshrc to include "export PIPX_HOME=$HOME/.local/pipx"
# To bootstrap with a specific Ansible version: make bootstrap ansible_version_spec="<2.18"
$ make bootstrap
```

And to finish: reboot the computer.

## Usage

Once bootstrapped, the `dev` binary runs the Makefile targets from anywhere. Type `dev` to list them.

| Command | Description |
| --- | --- |
| `dev setup` | Apply the whole playbook |
| `dev setup tags=dotfiles` | Apply only some tags (`dev tags` lists them) |
| `dev dotfiles` | Apply only the shell, git and SSH configuration |
| `dev upgrade` | Upgrade casks and Homebrew packages, then apply the playbook |
| `dev config` | Edit `config.yml` |
| `dev update` | Pull the last version of the playbook |

## Save the sudo password

To avoid typing the sudo password on every run, encrypt it with a vault password stored in the keychain:

```shell
$ ./scripts/generate-ansible-password
```

## License

[mac-playbook](https://github.com/notFloran/mac-playbook) is licensed under the [MIT license](LICENSE).
