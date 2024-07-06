# aurbuilder install

Install package(s) from AUR

| Attributes       | &nbsp;
|------------------|-------------
| Alias:           | i

## Usage

```bash
aurbuilder install PACKAGE... [OPTIONS]
```

## Dependencies

#### *git*

$(missing_dependencie git)

#### *mold*

$(missing_dependencie mold)

#### *pacman*



## Environment Variables

#### *NOCONFIRM*

Do not prompt for confirmation

| Attributes      | &nbsp;
|-----------------|-------------
| Default Value:  | false

#### *INSTALLER*

The package installer to use

| Attributes      | &nbsp;
|-----------------|-------------
| Default Value:  | yay

#### *MAKEFLAGS*

Make flags to use when installing packages

| Attributes      | &nbsp;
|-----------------|-------------
| Default Value:  | --jobs=$(nproc)

#### *BUILDDIR*

The build directory to use (The number $(magenta $AB_TMP_NUMBER) is randomly generated at each run)

| Attributes      | &nbsp;
|-----------------|-------------
| Default Value:  | $AB_USER_HOME/build-$AB_TMP_NUMBER

## Arguments

#### *PACKAGE*

One or more packages to install

| Attributes      | &nbsp;
|-----------------|-------------
| Required:       | ✓ Yes
| Repeatable:     |  ✓ Yes

## Options

#### *--noconfirm, -y*

Do not prompt for confirmation

#### *--installer, -i INSTALLER*

The package installer to use

| Attributes      | &nbsp;
|-----------------|-------------
| Allowed Values: | yay, makepkg

#### *--makeflags, -m MAKEFLAGS*

Make flags to use when installing packages

#### *--build-dir, -b BUILDDIR*

The build directory to use


