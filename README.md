# Tools for use in the CancerGov build process

This repository contains a set of tools which are shared amongst multiple projects
in the CancerGov ecosystem.

## The tools

* [GitHub Release tool](github-release) - PowerShell script for managing releases in GitHub.
* [Nexus Tools](nexus-tools/) - Scripts for working with a Nexus repository.
* [Text Substitution](text-substitution/) - Simple script for replacing placeholder values.

## Git sub-module

The cancergov-build-tools repository is used as a [git sub-module ](https://git-scm.com/docs/git-submodule)
(A shared component which is stored in a separate repository).

Each project is synced to a separate branch. This allows the updates to take place in a given project without
confusion about which project is using which revision of the code. At the end of a release iteration, the branch
is merged to `master` to make the changes available for other projects, but the project-specific branch is
never removed.