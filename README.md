

# How to build

`.github/workflows/actions.yml` has the formal description on how things are set up and built on Ubuntu 20.04.

- `make init` sets up minimum submodules (note that it performs `git submodule update` which will reset those submodules to the specificed commits).
- `make` builds everything
- `make dist` collects the target apks.

