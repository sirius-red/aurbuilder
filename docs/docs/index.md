# aurbuilder

A helper to install packages from aur logged in as root using yay or makepkg (This uses mold as linker instead of ld)

| Attributes       | &nbsp;
|------------------|-------------
| Version:         | 2.2.0

## Usage

```bash
aurbuilder [OPTIONS] COMMAND
```

## Dependencies

#### *arch-chroot*

Install with `pacman -S arch-install-scripts`

#### *git*

Install with `pacman -S git`

#### *mold*

Install with `pacman -S mold`

#### *pacman*

This package is installed with the base Arch Linux installation

## Environment Variables

#### *CHROOT*

The chroot directory to use (Useful to use in arch linux installation environment)

| Attributes      | &nbsp;
|-----------------|-------------
| Default Value:  | /

## Install Commands

- [install](aurbuilder%20install) - Install package(s) from AUR

## Self Commands

- [self](aurbuilder%20self) - Performs aurbuilder management operations

## Options

#### *--chroot CHROOT*

The chroot directory to use (Useful to use in arch linux installation environment)


