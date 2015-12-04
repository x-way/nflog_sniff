#!/usr/bin/perl
#
# Written by Andreas Jaggi <andreas.jaggi@waterwave.ch> in December 2015
#

use strict;
use warnings;

use nflog;
use NetPacket::IP qw(IP_PROTO_UDP);
use NetPacket::UDP;
use Socket qw(AF_INET AF_INET6);
use Net::DNS::Packet;

my $l;

sub callback {
	my ($payload) = @_;
	if ($payload) {
		my $ip_obj = NetPacket::IP->decode($payload->get_data());
		if ($ip_obj->{proto} == IP_PROTO_UDP) {
			my $packet = new Net::DNS::Packet(\NetPacket::UDP->decode($ip_obj->{data})->{data});
			if($packet->header->qr){
				foreach my $answer ( $packet->answer ) {
					print "answer(".$answer->type.")[".$answer->ttl."]: ".$answer->name." -> ".$answer->rdstring."\n";
				}
			}
		}
	}
	return 0;
}

sub cleanup {
	$l->unbind(AF_INET);
	$l->close();
}

sub main {
	$l = new nflog::log();
	$SIG{INT} =  "cleanup";
	$l->set_callback(\&callback);
	$l->fast_open(123,AF_INET);
	$l->try_run();
}

main();
