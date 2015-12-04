#!/bin/bash


iptables -I INPUT -p udp --sport 53 -j NFLOG --nflog-group 123
