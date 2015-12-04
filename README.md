# nflog_sniff
DNS packet sniffing with NFLOG in Perl or Python.

# usage

1. run start.sh
2. run ./nflog_sniffer.py or ./nflog_sniffer.pl
3. make some DNS queries and observe the extracted names and IPs

# requirements

nflog_sniffer.py requires dpkt and the nflog-bindings
nflog_sniffer.pl requires Net::DNS::Packet, NetPacket::IP, NetPacket::UDP and the nflog-bindings
