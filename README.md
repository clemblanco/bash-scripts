# Bash Scripts

This is a simple and naive collection of bash scripts which I like to call with simple aliases.

## Installation

Make sure `brew` is installed and up to date by running:

- `brew update`

Simply clone this repository anywhere you'd like and reference the scripts with aliases.

1. `git clone https://github.com/clemblanco/bash-scripts.git ~/.scripts`
2. `cd ~/.scripts`
3. `make install` to install the dependencies

## Scripts

Install the scripts using some simple aliases you'd add to your RC file (such as `~/.zshrc`) by adding:

```
alias aws:login="bash ~/.scripts/aws/login.sh"
alias aws:login:chrome="bash ~/.scripts/aws/chrome.sh"
alias aws:login:ecr="bash ~/.scripts/aws/ecrlogin.sh"
alias aws:logout="bash ~/.scripts/aws/logout.sh"
alias aws:ecssh="bash ~/.scripts/aws/ecssh.sh"
```
