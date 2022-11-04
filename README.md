# RuFans: SSU development project.

## Getting started
1. Install important dependencies:
    - Linux (Debian-based distros):
        - `sudo apt install git make`
    - MacOS
        - `brew install git make`
1. Clone this repository.
1. Enter the directory of cloned repository.
1. `make setup`
1. `make preinstall`

## Running the server
- Open a console and do `make install`
- Open another console and do `make runserver`

- NOTE #1: `make install` is doing only a migration and then starts the server.
  - If you want to drop DB and rebuild the dependencies, use `make preinstall` again.
- NOTE #2: Use `make install` console to do `rake` \ `rails` - specific stuff.
