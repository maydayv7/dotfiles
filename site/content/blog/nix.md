+++
title = "What is Nix?"
description = "An Introductory Article about the Nix Ecosystem"
date = 2022-02-20

[taxonomies]
series = ["NixOS Desktop"]
tags = ["Linux", "Nix", "NixOS"]

[extra]
ToC = true
edit = true
comments = true
+++

# Under Construction!

This Page is still under heavy development and may remain unfinished or subjected to major changes over time

# Terminology

**Nix** is a purely **_functional_** _package manager_. This means that it treats packages like _values_ built by _functions_ that don’t have side-effects, and never change after they have been built (known as **immutability**). This results in the _purity_ of a package which ensures _reproducibility_ in any environment and at any future point in time. For every package that it builds, it firsts computes a **derivation** (by evaluating expressions written in the Nix _language_) which consists of information about all the _dependencies_ of a package, build commands, miscellaneous meta-information, and a _prefix_ or **_store path_** into which said package shall be installed, which is in the form of <code>/nix/store/<b>HASH</b>-<i>NAME</i>-<i>VERSION</i></code>, where the _hash_ is built from all the input dependencies required to build the package. Then, it **_realises_** that derivation by running the specified build commands in an isolated environment (in a **_sandbox_**). This allows Nix to guarantee reproducibility, and allows it to support **_binary cache_**, by _substituting_ the store path from some other location. This also enables us to have **_multiple versions_** of the same package, since each one will have it's own isolated prefix, and makes easy to **_rollback_** to a previous version of a package. And since the build environment is completely isolated from the host system, non-privileged users can install software completely _securely_

**NixOS** is a GNU/Linux distribution that uses Nix, both a package manager, as well as a _configuration_ manager. The system derivation is realised from **_configuration files_** written in the Nix language containing data about all the applications to be installed on the system and subsequently their configuration. In addition to all the benefits provided by Nix, because of the way it is configured, all updates and rollbacks are atomic (and can be automated), and in case anything doesn't function as intended, such as when the system doesn't even boot, every single derivation that was installed [^1] is listed in the boot loader, and you can boot directly into it. This, along with the fact that NixOS provides for completely reproducible configurations, and allows to easily switch between conflicting package arrangements, makes it an ideal choice for use in multi-PC setups, such as home office configurations, for small organizations or even to rejuvenate individual setups with the amount of benefits that it offers. Thus, I have chosen NixOS above all others in pursuit of a reliable, relatively stable distro that I could conveniently use to manage the computers that I own

[**`nixpkgs`**](https://github.com/nixos/nixpkgs), basically the main _package repository_ to use with Nix, is a giant collection of package descriptions as well as configuration modules written in the Nix language, that serves to build multiple applications for our day-to-day use, as well as the tools required to properly define a NixOS Configuration. It provides a vast number of applications, programs and services, language-specific package sets, cross-compilation tools, and many other such packages, which makes Nix such a powerful tool

The Nix **programming language** is simple, _lazy_ (which means evaluation of expressions is delayed until their values are actually needed), pure, functional, and dynamically typed, which specializes in building packages

# Language Basics

`nix repl` is a simple CLI tool for playing around with the Nix language. It is advisable to use it in order to completely understand all the quirks of the syntax

## Types

Nix supports the basic `+`, `-`, `*` and `/` arithmetic operations (although using `/` with single space converts a string to a path)
Other operators are: _Booleans_ - `||`, `&&` and `!`, _Relationals_ - `!=`, `==`, `<`, `>`, `<=`, `>=`.
It has _integer_, _floating point_, _string_, _path_, _boolean_ and `null` simple types. Then there are also lists, sets and functions
Nix is **_strongly typed_**, strings and integers must be _converted_ to be mixed together and used

#### Strings

They are enclosed in either `""` for a single line or `''` for multiple lines. It is also possible to **_interpolate_** Nix expressions using `${ ... }` (which can also be escaped using `''$`)

#### Lists

Sequence of expressions delimited by space. Ex - `[ "1" "2" true var ]`

#### Attribute Sets

They are association between string keys (Unquoted identifiers can also be used) and Nix Values. Ex - `{ a = "foo"; "a-b" = "bar"; }`. Members can be accessed using the `.` operator. **_Recursive_** Sets are created using the `rec` keyword which allows members of the `attrset` to be referenced by the other elements. For example, when `msg = rec { hi = "Hello"; world = hi + "World!"}`, `msg.world` equals `"HelloWorld!"`

## Expressions

**_if_** **Expression:** Conditional used for evaluation. Ex - `if 7 > 3 then "yes" else "no"` evaluates to `"yes"`

**_let_** **Expression:** Allows for definition of local variables to be used in inner elements (recursively). Ex - `let a = 7; in a + 3` evaluates to `10`. The same variable cannot be assigned twice

## Functions

Functions are of two types. The first makes use of positional parameters. A simple function `add = x: y: x + y`, when called using `add 7 3`, will return `10`. Such a function has to be called with exactly the same number of arguments as explicitly defined, or will return an error. The second type of functions allows more complex substitutions. For example, when `add = { x ? 7, y }: x + y` is called using `add { y = 3; }`, it will still return 10, as `?` allows you to specify the default value when the argument isn't provided

## Derivation

Given below is an simple Nix derivation, just as an example:

```nix
{ lib, pkgs, ... }:
with pkgs;
stdenv.mkDerivation rec {
  pname = "Dotfiles";
  version = "v5.0";
  longVersion = "20220220";

  src = fetchFromGitHub
  {
    owner = "maydayv7";
    repo = "dotfiles";
    sha256 = lib.fakeSha256;
    rev = version;
  };

  dontBuild = true;
  buildInputs = [ coreutils ];
  installPhase = "mkdir -p $out/ && cp -r . $out/";

  meta = with lib; {
    description = "My PC Dotfiles";
    homepage = "https://github.com/maydayv7/dotfiles";
    license = licenses.mit;
    platform = platforms.all;
    maintainers = [ "maydayv7" ];
  };
}
```

Let us inspect it line by line

1. `{ lib, pkgs, ... }`: `lib` refers to the cores set of library functions provided by `nixpkgs` which act as tools to perform a number of package management functions using Nix. `pkgs` refers to all the other packages already present in `nixpkgs` which may be used as dependencies by the program to be built
2. `with` is a keyword that allows us to directly call the members of an `attrset` without prefixing it's name multiple times. For example, instead of using `pkgs.fetchFromGitHub` or `pkgs.coreutils` (later in the file), we can directly reference using their names
3. `stdenv` is a standard derivation which serves as base for packaging software. It is used to pull in dependencies and basic tools needed to compile the program. `mkDerivation` is a wrapper around the raw derivation function which pulls in the `stdenv` for us, and runs a generic `make` builder
4. `src` specifies the root source tree from which the program is to be built. `fetchFromGitHub` is a convenience function used to specify a GitHub repository as the source

# Resources

Below is a list of handy, helpful resources and documentation that can be used to learn more about the Nix ecosystem in depth:

- Official [Documentation](https://nixos.org/learn.html) and the NixOS [Manual](https://nixos.org/manual/nixpkgs/stable)
- The Nix [Pills](https://nixos.org/guides/nix-pills/) Tutorial
- Serokell's [Blog](https://serokell.io/blog/what-is-nix) introducing Nix
- Justin's [Notes](https://github.com/justinwoo/nix-shorts) on using Nix

# Footnotes

[^1]: Provided that they are not **_garbage collected_** - Removing or modifying a package from the configuration doesn't exactly delete older versions from the system. All they do is create a new derivation that no longer contains symlinks to the older packages. Since disk space is limited, unused packages should be removed at some point, which can be done using `nix-collect-garbage -d` or `nix store --gc`
