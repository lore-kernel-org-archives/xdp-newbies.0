Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-eopbgr670062.outbound.protection.outlook.com ([40.107.67.62]:30752
        "EHLO CAN01-TO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729053AbfGaVM0 (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 31 Jul 2019 17:12:26 -0400
From: Brandon Cazander <brandon.cazander@multapplied.net>
Subject: xdpgeneric, XDP_PASS, and bpf_xdp_adjust_head decapsulation dropping
 packets
Date: Wed, 31 Jul 2019 21:12:23 +0000
Message-ID: <20190731211211.GA87084@multapplied.net>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BF71F0F10D0DF045AC9D883445D48440@CANPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>


I am having an issue with xdpgeneric specifically when using XDP_PASS after
bpf_xdp_adjust_head to pop some headers off. My test environment is qemu us=
ing
virtio_net specifically, but it also happens with e1000 in qemu/physical de=
vices.

On a real NIC (ixgbe), the same program is successfully passing decapsulate=
d
traffic, but fails in the same way when forcing xdpgeneric mode.

Here is the packet outside of my VM, with the IP+UDP+tun header.

# sudo tcpdump -ni ens5-outside -e udp -vvvXc1
tcpdump: listening on ens5-outside, link-type EN10MB (Ethernet), capture si=
ze 262144 bytes
15:54:14.263306 06:54:00:00:00:01 > 06:54:01:00:00:01, ethertype IPv4 (0x08=
00), length 127: (tos 0x0, ttl 255, id 0, offset 0, flags [DF], proto UDP (=
17), length 113)
    172.64.0.108.39999 > 172.64.0.101.7803: [no cksum] UDP, length 85
	0x0000:  4500 0071 0000 4000 ff11 222a ac40 006c  E..q..@..."*.@.l
	0x0010:  ac40 0065 9c3f 1e7b 005d 0000 0145 0000  .@.e.?.{.]...E..
	0x0020:  54e3 6b40 003f 01d5 e8c0 a800 02c0 a801  T.k@.?..........
	0x0030:  0208 002c b1b0 5eb8 f196 ca40 5d00 0000  ...,..^....@]...
	0x0040:  00c8 0304 0000 0000 0010 1112 1314 1516  ................
	0x0050:  1718 191a 1b1c 1d1e 1f20 2122 2324 2526  ..........!"#$%&
	0x0060:  2728 292a 2b2c 2d2e 2f30 3132 3334 3536  '()*+,-./0123456
	0x0070:  37                                       7

My XDP program copies the original ethhdr to the new offset and adjusts the=
 head
forward, and I can see the resulting ICMP packet is valid with tcpdump insi=
de
the VM:

# tcpdump -niens5 icmp -c1 -vXe
tcpdump: listening on ens5, link-type EN10MB (Ethernet), capture size 26214=
4 bytes
15:53:25.602109 06:54:00:00:00:01 > 06:54:01:00:00:01, ethertype IPv4 (0x08=
00), length 98: (tos 0x0, ttl 63, id 35986, offset 0, flags [DF], proto ICM=
P (1), length 84)
    192.168.0.2 > 192.168.1.2: ICMP echo request, id 45150, seq 43683, leng=
th 64
	0x0000:  4500 0054 8c92 4000 3f01 2cc2 c0a8 0002  E..T..@.?.,.....
	0x0010:  c0a8 0102 0800 ed79 b05e aaa3 6dca 405d  .......y.^..m.@]
	0x0020:  0000 0000 3589 0d00 0000 0000 1011 1213  ....5...........
	0x0030:  1415 1617 1819 1a1b 1c1d 1e1f 2021 2223  .............!"#
	0x0040:  2425 2627 2829 2a2b 2c2d 2e2f 3031 3233  $%&'()*+,-./0123
	0x0050:  3435 3637                                4567

Unfortunately, at this point, the packet is dropped in ip_rcv_core. I added=
 a
perf probe on the specific drop line that I'm hitting, and printing the skb=
->len
and len (from ntohs(iph->tot_len)) variables. You can see the obviously wro=
ng
len value below, while a packet capture in the VM does show the correct val=
ue
for tot_len in the IP header.

# perf probe -L ip_rcv_core:64+4 | cat
<ip_rcv_core@/usr/src/debug/kernel-debug-5.2.2-1.2.x86_64/linux-5.2/linux-o=
bj/../net/ipv4/ip_input.c:64>
     64  	if (pskb_trim_rcsum(skb, len)) {
     65  		__IP_INC_STATS(net, IPSTATS_MIB_INDISCARDS);
     66  		goto drop;
         	}

# perf probe -a 'ip_rcv_core:66 skb=3Dskb->len:u32 len=3Dlen:u32'
	swapper     0 [001] 84794.954487: probe:ip_rcv_core: (ffffffffbcbd5a7d) sk=
b=3D84 len=3D4294931717
	swapper     0 [001] 84794.965473: probe:ip_rcv_core: (ffffffffbcbd5a7d) sk=
b=3D84 len=3D4294936833

In contrast, here's what it looks like in XDP native mode (different line n=
umber
but looking):

# perf probe -a 'ip_rcv_core:57 skb=3Dskb->len:u32 len=3Dlen:u32'
	swapper     0 [000]   353.187439: probe:ip_rcv_core: (ffffffffac9dcca7) sk=
b=3D84 len=3D84
	swapper     0 [003]   353.187577: probe:ip_rcv_core: (ffffffffac9dcca7) sk=
b=3D84 len=3D84

Here's the relevant portion of my program where I decapsulate:

static __always_inline int handle_peer_data_ipv4(struct xdp_md *ctx)
{
	void *data, *data_end;
	struct ethhdr *eth, *orig_eth;
	__u32 csum =3D 0;

	data =3D (void *)(unsigned long)ctx->data;
	data_end =3D (void *)(unsigned long)ctx->data_end;

	if (data + sizeof(struct ethhdr) + sizeof(struct iphdr) + sizeof(struct ud=
phdr) + sizeof(struct tunnel_header) > data_end) {
		return XDP_DROP;
	}

	orig_eth =3D data;
	eth =3D data + sizeof(struct iphdr) + sizeof(struct udphdr) + sizeof(struc=
t tunnel_header);
	memcpy(&eth->h_source, &orig_eth->h_source, ETH_ALEN);
	memcpy(&eth->h_dest, &orig_eth->h_dest, ETH_ALEN);
	eth->h_proto =3D __constant_htons(ETH_P_IP);

	/* Decapsulate by removing IP + UDP + tunnel headers */
	if (bpf_xdp_adjust_head(ctx, (int)(sizeof(struct iphdr) + sizeof(struct ud=
phdr) +
					   sizeof(struct tunnel_header)))) {
		return XDP_DROP;
	}

	return XDP_PASS;
}

struct tunnel_header {
	__u8 flags;
};

Kernel is 5.2.2-1-debug, OS is openSUSE Tumbleweed 20190724. For qemu I run=
 with
these arguments for the NICs:

# qemu (...) -netdev tap,br=3Dvm-bridge,id=3Dhostnet1,ifname=3Dens5-outside=
,queues=3D4,vhost=3Don \
-device virtio-net-pci,mq=3Don,vectors=3D9,guest_tso4=3Doff,guest_tso6=3Dof=
f,netdev=3Dhostnet1,id=3Dnet1,mac=3D06:54:01:00:00:01
