# AUR Builder

Installing packages from the AUR when logged in as root on arch linux is sometimes a mess, especially if you are trying to do it when installing the system, whether manually or with a script. I created AUR Builder with the motivation of solving this problem, since for all the installations I do of arch, I create a script for them, and having to add some packages manually after installation is really annoying, the option beyond this installation system post-installation manual would be to add the code from this repository to my installation scripts, so I found it more practical to create a separate package for this.

Although the focus is on use during Arch installation, AUR Builder works very well for common use.

- [Installation](#installation)
  - [Automatic installation](#automatic-installation)
  - [Building from source](#building-from-source)
- [How to use](#how-to-use)
- [Contributing](#contributing)

## Installation

### Automatic installation

```bash
curl -L https://sirius-red.github.io/install | bash
```

### Building from source

```bash
git clone https://github.com/sirius-red/aurbuilder.git --depth 1
cd aurbuilder
scripts/builder --production --install
```

## How to use

When trying to install a package, aurbuilder will use `yay` if it is installed, otherwise the installation will be done by cloning the AUR repository and installing with `makepkg`.

Just use the command below:

```bash
aurbuilder <package_name>

# Installing multiple packages
aurbuilder package1 package2 package3
```

If you are using aurbuilder to install packages when installing Arch:

```bash
# Replace `/mnt` to the directory where you mounted the root partition
aurbuilder --chroot /mnt <package_name>
```

**All** necessary information is in the help command:

```bash
aurbuilder --help
```

But if you want, follow the link to [official documentation](docs)

## Contributing

Install the required dependencies:

- **zip** (install with your package manager)
- **ruby** (install with your package manager)
- **bashly** (Installation information in [official documentation](https://bashly.dannyb.co/installation/))

**Read the bashly documentation first, you won't be able to do anything without knowing how it works.**

Use bashly's watch mode to generate the binary as you save changes:

```bash
bashly generate --watch
```

In the `scripts` folder there is an auxiliary script to build the project (run it from the project root as shown below):

```bash
scripts/builder --help
```
