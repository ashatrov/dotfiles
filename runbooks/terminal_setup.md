# Terminal setup

Install terminal: Warp
Install shell: `brew install zsh`
Install OhMyZsh: https://ohmyz.sh/#install

Enable TouchID for sudo: Add line `auth       sufficient     pam_tid.so` as the **first** line in the file `sudo vim /etc/pam.d/sudo`


# Claude Code setup
Add `context7` through the plugin.
Add `LSP` for the project coding language. First, install LSP (e.g. https://intelephense.com/ or https://github.com/PHPantom-dev/phpantom_lsp), Then enable LSP plugin in Claude code.
Install `BMad Method`
Install skills from my skills registry. Example:`gh skill install ashatrov/agent-skills php-code-intelligence-routing --agent claude-code --scope project
