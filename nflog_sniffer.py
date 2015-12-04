#!/usr/bin/python
#
# Written by Andreas Jaggi <andreas.jaggi@waterwave.ch> in December 2015
#

from socket import AF_INET, AF_INET6, inet_ntop

import nflog

from dpkt import ip, dns

def callback(payload):
	pkt = ip.IP(payload.get_data())
	if pkt.p == ip.IP_PROTO_UDP:
		pack = dns.DNS(pkt.udp.data)
		if pack.qr == dns.DNS_R:
			for rr in pack.an:
				if rr.type == dns.DNS_A:
					print "answer(%s)[%d]: %s" % (rr.name, rr.ttl, inet_ntop(AF_INET,rr.ip))
				if rr.type == dns.DNS_AAAA:
					print "answer(%s)[%d]: %s" % (rr.name, rr.ttl, inet_ntop(AF_INET6,rr.ip6))
				if rr.type == dns.DNS_CNAME:
					print "answer(%s)[%d]: %s" % (rr.name, rr.ttl, rr.cname)
		

def main():
	l = nflog.log()
	l.set_callback(callback)
	l.fast_open(123,AF_INET)
	try:
		l.try_run()
	except KeyboardInterrupt, e:
		print "interrupted, terminating..."
	l.unbind(AF_INET)
	l.close()
	

if __name__ == "__main__":
	main()
