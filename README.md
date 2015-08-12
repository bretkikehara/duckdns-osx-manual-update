Duck DNS Manual Update Script
-----------------------------

## Quickstart

1. Edit the ./duckdns.sh script.
2. Set the `SUBDOMAIN` and the `TOKEN` variables from the [Duck DNS](https://www.duckdns.org/) website.
3. Run these commands:

    ./duckdns.sh list
    ./duckdns.sh bind $interface

### List available IPv4 interfaces

Running the script will list available IPv4 interfaces:

    ./duckdns.sh list
    ./duckdns.sh -l

### Bind on an interface

In the terminal run:

    ./duckdns.sh bind $interface
    ./duckdns.sh -b $interface

### Help

Run the command by itself for help:

    ./duckdns.sh
