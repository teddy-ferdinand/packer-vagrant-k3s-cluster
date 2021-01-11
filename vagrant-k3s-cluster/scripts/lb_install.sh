#!/bin/bash
# Download and deploy Traefik as a front load balancer
/home/packer/traefik --configFile=/tmp/traefikconf/static_conf.toml &> /dev/null&
