# View

A zsh plugin to view files such as markdown from command line with pandoc.

## Demo

<img src="https://i.imgur.com/qiRRsFj.gif" width="960" height="540">

## Installation

### Requirement

**view** use [pandoc](https://github.com/jgm/pandoc) to convert the files to html format, and then host a http server with [busybox](https://github.com/mirror/busybox). Therefore, installing the binary is required.

- Debian / Ubuntu
  ```bash
  sudo apt update
  sudo apt install pandoc busybox
  ```

- Arch Linux
  ```bash
  sudo pacman -Sy
  sudo pacman -S pandoc busybox
  ```
### Download

> It's currently available on [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh).

To install the plugin, downloads this repository and place it to `~/.oh-my-zsh/custom/plugins`, or run the following command.

```bash
git clone https://github.com/an920107/view "$HOME/.oh-my-zsh/custom/plugins/view"
```

### Configuration

After downloading the plugin, we also need to enable it by modifying `~/.zshrc`. Use any editor and add `view` into `plugins=(...)` section like the example below.

```zsh
plugins=(
    git
    any-other-plugin...
    view
)
```

Finally, run the following command or restart the terminal to apply the change.

```bash
source ~/.zshrc
```

## Usage

It's simple to use **view**, just put the file you want to view after view, and it should open the browser automatically. There are some example.

```bash
view README.md
view data.csv
```

To terminte the process, press CTRL+C.

## Future

- Detect the distro and intall the binary required automatically.
- Support flags to achieve more functionality such as
  - Printing plain text to stdout instead of opening browser
  - Customizing css style

