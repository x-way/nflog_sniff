all:
	g++ nflog_sniffer.cpp -std=c++11 -ltins -lnetfilter_log -o nflog_sniffer
