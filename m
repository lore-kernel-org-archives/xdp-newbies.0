Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726304AbgD0AUg (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Sun, 26 Apr 2020 20:20:36 -0400
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 165A3C061A0F
        for <xdp-newbies@vger.kernel.org>; Sun, 26 Apr 2020 17:20:36 -0700 (PDT)
Received: by mail-qv1-xf2b.google.com with SMTP id ck5so935474qvb.11
        for <xdp-newbies@vger.kernel.org>; Sun, 26 Apr 2020 17:20:36 -0700 (PDT)
Received: from gmail.com (pool-74-104-133-20.bstnma.fios.verizon.net. [74.104.133.20])
        by smtp.gmail.com with ESMTPSA id j9sm6077485qkg.88.2020.04.26.17.20.33
        for <xdp-newbies@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 26 Apr 2020 17:20:33 -0700 (PDT)
Date: Sun, 26 Apr 2020 20:20:27 -0400
From: Sowmini Varadhan <sowmini05@gmail.com>
Subject: Re: building eBPF
Message-ID: <20200427002027.GE488@gmail.com>
References: <20200425122225.GA455@gmail.com>
 <20200425145619.4405a50d@carbon>
MIME-Version: 1.0
In-Reply-To: <20200425145619.4405a50d@carbon>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: multipart/mixed; boundary="liOOAslEiF7prFVr"
Content-Disposition: inline
To: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>

--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


With the latest iproute2 (built from master, 'ip -V' reports
iproute2-ss200330) when I try to run tc_l2_redirect.sh
I get errors like the following. What am I missing?

(full transcript of output from run is in the run.out attachment)

  :
+ tc filter add dev ve2 ingress bpf da obj ./tc_l2_redirect_kern.o sec l2_to_iptun_ingress_forward

BTF debug data section '.BTF' rejected: Invalid argument (22)!
 - Length:       3554
Verifier analysis:

magic: 0xeb9f
version: 1
flags: 0x0
hdr_len: 24
type_off: 0
type_len: 984
str_off: 984
str_len: 2546
btf_total_size: 3554
[1] PTR (anon) type_id=2
[2] STRUCT __sk_buff size=184 vlen=32
        len type_id=3 bits_offset=0
        pkt_type type_id=3 bits_offset=32
        mark type_id=3 bits_offset=64
        queue_mapping type_id=3 bits_offset=96
        protocol type_id=3 bits_offset=128
        vlan_present type_id=3 bits_offset=160
        vlan_tci type_id=3 bits_offset=192
        vlan_proto type_id=3 bits_offset=224
         :
         :

--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="run.out"

+ [[ -z '' ]]
+ TC=tc
+ [[ -z '' ]]
+ IP=ip
+ REDIRECT_USER=./tc_l2_redirect
+ REDIRECT_BPF=./tc_l2_redirect_kern.o
+ RP_FILTER=0
+ IPV6_FORWARDING=1
+ cleanup
+ set +e
+ [[ -z '' ]]
+ ip netns delete ns1
+ ip netns delete ns2
+ ip link del ve1
+ ip link del ve2
+ ip link del ipt
+ ip link del ip6t
+ sysctl -q -w net.ipv4.conf.all.rp_filter=0
+ sysctl -q -w net.ipv6.conf.all.forwarding=1
+ rm -f /sys/fs/bpf/tc/globals/tun_iface
+ [[ -z '' ]]
+ set -e
+ test_names='l2_to_ipip l2_to_ip6tnl'
+ test_dirs='ingress egress'
+ [[ 0 -ge 2 ]]
+ [[ 0 -ge 1 ]]
+ for t in $test_names
+ for d in $test_dirs
+ l2_to_ipip ingress
+ echo -n 'l2_to_ipip ingress: '
l2_to_ipip ingress: + local dir=ingress
+ config_common ipip
+ local tun_type=ipip
+ ip netns add ns1
+ ip netns add ns2
+ ip link add ve1 type veth peer name vens1
+ ip link add ve2 type veth peer name vens2
+ ip link set dev ve1 up
+ ip link set dev ve2 up
+ ip link set dev ve1 mtu 1500
+ ip link set dev ve2 mtu 1500
+ ip link set dev vens1 netns ns1
+ ip link set dev vens2 netns ns2
+ ip -n ns1 link set dev lo up
+ ip -n ns1 link set dev vens1 up
+ ip -n ns1 addr add 10.1.1.101/24 dev vens1
+ ip -n ns1 addr add 2401:db01::65/64 dev vens1 nodad
+ ip -n ns1 route add default via 10.1.1.1 dev vens1
+ ip -n ns1 route add default via 2401:db01::1 dev vens1
+ ip -n ns2 link set dev lo up
+ ip -n ns2 link set dev vens2 up
+ ip -n ns2 addr add 10.2.1.102/24 dev vens2
+ ip -n ns2 addr add 2401:db02::66/64 dev vens2 nodad
+ ip -n ns2 addr add 10.10.1.102 dev lo
+ ip -n ns2 addr add 2401:face::66/64 dev lo nodad
+ ip -n ns2 link add ipt2 type ipip local 10.2.1.102 remote 10.2.1.1
+ ip -n ns2 link add ip6t2 type ip6tnl mode any local 2401:db02::66 remote 2401:db02::1
+ ip -n ns2 link set dev ipt2 up
+ ip -n ns2 link set dev ip6t2 up
+ ip netns exec ns2 tc qdisc add dev vens2 clsact
+ ip netns exec ns2 tc filter add dev vens2 ingress bpf da obj ./tc_l2_redirect_kern.o sec drop_non_tun_vip

BTF debug data section '.BTF' rejected: Invalid argument (22)!
 - Length:       3554
Verifier analysis:

magic: 0xeb9f
version: 1
flags: 0x0
hdr_len: 24
type_off: 0
type_len: 984
str_off: 984
str_len: 2546
btf_total_size: 3554
[1] PTR (anon) type_id=2
[2] STRUCT __sk_buff size=184 vlen=32
	len type_id=3 bits_offset=0
	pkt_type type_id=3 bits_offset=32
	mark type_id=3 bits_offset=64
	queue_mapping type_id=3 bits_offset=96
	protocol type_id=3 bits_offset=128
	vlan_present type_id=3 bits_offset=160
	vlan_tci type_id=3 bits_offset=192
	vlan_proto type_id=3 bits_offset=224
	priority type_id=3 bits_offset=256
	ingress_ifindex type_id=3 bits_offset=288
	ifindex type_id=3 bits_offset=320
	tc_index type_id=3 bits_offset=352
	cb type_id=5 bits_offset=384
	hash type_id=3 bits_offset=544
	tc_classid type_id=3 bits_offset=576
	data type_id=3 bits_offset=608
	data_end type_id=3 bits_offset=640
	napi_id type_id=3 bits_offset=672
	family type_id=3 bits_offset=704
	remote_ip4 type_id=3 bits_offset=736
	local_ip4 type_id=3 bits_offset=768
	remote_ip6 type_id=7 bits_offset=800
	local_ip6 type_id=7 bits_offset=928
	remote_port type_id=3 bits_offset=1056
	local_port type_id=3 bits_offset=1088
	data_meta type_id=3 bits_offset=1120
	(anon) type_id=8 bits_offset=1152
	tstamp type_id=10 bits_offset=1216
	wire_len type_id=3 bits_offset=1280
	gso_segs type_id=3 bits_offset=1312
	(anon) type_id=12 bits_offset=1344
	gso_size type_id=3 bits_offset=1408
[3] TYPEDEF __u32 type_id=4
[4] INT unsigned int size=4 bits_offset=0 nr_bits=32 encoding=(none)
[5] ARRAY (anon) type_id=3 index_type_id=6 nr_elems=5
[6] INT __ARRAY_SIZE_TYPE__ size=4 bits_offset=0 nr_bits=32 encoding=(none)
[7] ARRAY (anon) type_id=3 index_type_id=6 nr_elems=4
[8] UNION (anon) size=8 vlen=1
	flow_keys type_id=9 bits_offset=0
[9] PTR (anon) type_id=30
[10] TYPEDEF __u64 type_id=11
[11] INT long long unsigned int size=8 bits_offset=0 nr_bits=64 encoding=(none)
[12] UNION (anon) size=8 vlen=1
	sk type_id=13 bits_offset=0
[13] PTR (anon) type_id=31
[14] FUNC_PROTO (anon) return=15 args=(1 skb)
[15] INT int size=4 bits_offset=0 nr_bits=32 encoding=SIGNED
[16] FUNC _l2_to_iptun_ingress_forward type_id=14
[17] FUNC_PROTO (anon) return=15 args=(1 skb)
[18] FUNC _l2_to_iptun_ingress_redirect type_id=17
[19] FUNC_PROTO (anon) return=15 args=(1 skb)
[20] FUNC _l2_to_ip6tun_ingress_redirect type_id=19
[21] FUNC_PROTO (anon) return=15 args=(1 skb)
[22] FUNC _drop_non_tun_vip type_id=21
[23] STRUCT bpf_elf_map size=28 vlen=7
	type type_id=3 bits_offset=0
	size_key type_id=3 bits_offset=32
	size_value type_id=3 bits_offset=64
	max_elem type_id=3 bits_offset=96
	flags type_id=3 bits_offset=128
	id type_id=3 bits_offset=160
	pinning type_id=3 bits_offset=192
[24] VAR tun_iface type_id=23 linkage=1
[25] INT char size=1 bits_offset=0 nr_bits=8 encoding=SIGNED
[26] ARRAY (anon) type_id=25 index_type_id=6 nr_elems=4
[27] VAR _license type_id=26 linkage=1
[28] DATASEC license size=0 vlen=1 size == 0

+ [[ ipip == \i\p\i\p ]]
+ ip -n ns2 route add 10.1.1.0/24 dev ipt2
+ ip netns exec ns2 sysctl -q -w net.ipv4.conf.all.rp_filter=0
+ ip netns exec ns2 sysctl -q -w net.ipv4.conf.ipt2.rp_filter=0
+ ip addr add 10.1.1.1/24 dev ve1
+ ip addr add 2401:db01::1/64 dev ve1 nodad
+ ip addr add 10.2.1.1/24 dev ve2
+ ip addr add 2401:db02::1/64 dev ve2 nodad
+ tc qdisc add dev ve2 clsact
+ tc filter add dev ve2 ingress bpf da obj ./tc_l2_redirect_kern.o sec l2_to_iptun_ingress_forward

BTF debug data section '.BTF' rejected: Invalid argument (22)!
 - Length:       3554
Verifier analysis:

magic: 0xeb9f
version: 1
flags: 0x0
hdr_len: 24
type_off: 0
type_len: 984
str_off: 984
str_len: 2546
btf_total_size: 3554
[1] PTR (anon) type_id=2
[2] STRUCT __sk_buff size=184 vlen=32
	len type_id=3 bits_offset=0
	pkt_type type_id=3 bits_offset=32
	mark type_id=3 bits_offset=64
	queue_mapping type_id=3 bits_offset=96
	protocol type_id=3 bits_offset=128
	vlan_present type_id=3 bits_offset=160
	vlan_tci type_id=3 bits_offset=192
	vlan_proto type_id=3 bits_offset=224
	priority type_id=3 bits_offset=256
	ingress_ifindex type_id=3 bits_offset=288
	ifindex type_id=3 bits_offset=320
	tc_index type_id=3 bits_offset=352
	cb type_id=5 bits_offset=384
	hash type_id=3 bits_offset=544
	tc_classid type_id=3 bits_offset=576
	data type_id=3 bits_offset=608
	data_end type_id=3 bits_offset=640
	napi_id type_id=3 bits_offset=672
	family type_id=3 bits_offset=704
	remote_ip4 type_id=3 bits_offset=736
	local_ip4 type_id=3 bits_offset=768
	remote_ip6 type_id=7 bits_offset=800
	local_ip6 type_id=7 bits_offset=928
	remote_port type_id=3 bits_offset=1056
	local_port type_id=3 bits_offset=1088
	data_meta type_id=3 bits_offset=1120
	(anon) type_id=8 bits_offset=1152
	tstamp type_id=10 bits_offset=1216
	wire_len type_id=3 bits_offset=1280
	gso_segs type_id=3 bits_offset=1312
	(anon) type_id=12 bits_offset=1344
	gso_size type_id=3 bits_offset=1408
[3] TYPEDEF __u32 type_id=4
[4] INT unsigned int size=4 bits_offset=0 nr_bits=32 encoding=(none)
[5] ARRAY (anon) type_id=3 index_type_id=6 nr_elems=5
[6] INT __ARRAY_SIZE_TYPE__ size=4 bits_offset=0 nr_bits=32 encoding=(none)
[7] ARRAY (anon) type_id=3 index_type_id=6 nr_elems=4
[8] UNION (anon) size=8 vlen=1
	flow_keys type_id=9 bits_offset=0
[9] PTR (anon) type_id=30
[10] TYPEDEF __u64 type_id=11
[11] INT long long unsigned int size=8 bits_offset=0 nr_bits=64 encoding=(none)
[12] UNION (anon) size=8 vlen=1
	sk type_id=13 bits_offset=0
[13] PTR (anon) type_id=31
[14] FUNC_PROTO (anon) return=15 args=(1 skb)
[15] INT int size=4 bits_offset=0 nr_bits=32 encoding=SIGNED
[16] FUNC _l2_to_iptun_ingress_forward type_id=14
[17] FUNC_PROTO (anon) return=15 args=(1 skb)
[18] FUNC _l2_to_iptun_ingress_redirect type_id=17
[19] FUNC_PROTO (anon) return=15 args=(1 skb)
[20] FUNC _l2_to_ip6tun_ingress_redirect type_id=19
[21] FUNC_PROTO (anon) return=15 args=(1 skb)
[22] FUNC _drop_non_tun_vip type_id=21
[23] STRUCT bpf_elf_map size=28 vlen=7
	type type_id=3 bits_offset=0
	size_key type_id=3 bits_offset=32
	size_value type_id=3 bits_offset=64
	max_elem type_id=3 bits_offset=96
	flags type_id=3 bits_offset=128
	id type_id=3 bits_offset=160
	pinning type_id=3 bits_offset=192
[24] VAR tun_iface type_id=23 linkage=1
[25] INT char size=1 bits_offset=0 nr_bits=8 encoding=SIGNED
[26] ARRAY (anon) type_id=25 index_type_id=6 nr_elems=4
[27] VAR _license type_id=26 linkage=1
[28] DATASEC license size=0 vlen=1 size == 0

+ sysctl -q -w net.ipv4.conf.all.rp_filter=0
+ sysctl -q -w net.ipv6.conf.all.forwarding=1
+ ip link add ipt type ipip external
+ ip link set dev ipt up
+ sysctl -q -w net.ipv4.conf.ipt.rp_filter=0
+ sysctl -q -w net.ipv4.conf.ipt.forwarding=1
+ [[ ingress == \e\g\r\e\s\s ]]
+ tc qdisc add dev ve1 clsact
+ tc filter add dev ve1 ingress bpf da obj ./tc_l2_redirect_kern.o sec l2_to_iptun_ingress_redirect

BTF debug data section '.BTF' rejected: Invalid argument (22)!
 - Length:       3554
Verifier analysis:

magic: 0xeb9f
version: 1
flags: 0x0
hdr_len: 24
type_off: 0
type_len: 984
str_off: 984
str_len: 2546
btf_total_size: 3554
[1] PTR (anon) type_id=2
[2] STRUCT __sk_buff size=184 vlen=32
	len type_id=3 bits_offset=0
	pkt_type type_id=3 bits_offset=32
	mark type_id=3 bits_offset=64
	queue_mapping type_id=3 bits_offset=96
	protocol type_id=3 bits_offset=128
	vlan_present type_id=3 bits_offset=160
	vlan_tci type_id=3 bits_offset=192
	vlan_proto type_id=3 bits_offset=224
	priority type_id=3 bits_offset=256
	ingress_ifindex type_id=3 bits_offset=288
	ifindex type_id=3 bits_offset=320
	tc_index type_id=3 bits_offset=352
	cb type_id=5 bits_offset=384
	hash type_id=3 bits_offset=544
	tc_classid type_id=3 bits_offset=576
	data type_id=3 bits_offset=608
	data_end type_id=3 bits_offset=640
	napi_id type_id=3 bits_offset=672
	family type_id=3 bits_offset=704
	remote_ip4 type_id=3 bits_offset=736
	local_ip4 type_id=3 bits_offset=768
	remote_ip6 type_id=7 bits_offset=800
	local_ip6 type_id=7 bits_offset=928
	remote_port type_id=3 bits_offset=1056
	local_port type_id=3 bits_offset=1088
	data_meta type_id=3 bits_offset=1120
	(anon) type_id=8 bits_offset=1152
	tstamp type_id=10 bits_offset=1216
	wire_len type_id=3 bits_offset=1280
	gso_segs type_id=3 bits_offset=1312
	(anon) type_id=12 bits_offset=1344
	gso_size type_id=3 bits_offset=1408
[3] TYPEDEF __u32 type_id=4
[4] INT unsigned int size=4 bits_offset=0 nr_bits=32 encoding=(none)
[5] ARRAY (anon) type_id=3 index_type_id=6 nr_elems=5
[6] INT __ARRAY_SIZE_TYPE__ size=4 bits_offset=0 nr_bits=32 encoding=(none)
[7] ARRAY (anon) type_id=3 index_type_id=6 nr_elems=4
[8] UNION (anon) size=8 vlen=1
	flow_keys type_id=9 bits_offset=0
[9] PTR (anon) type_id=30
[10] TYPEDEF __u64 type_id=11
[11] INT long long unsigned int size=8 bits_offset=0 nr_bits=64 encoding=(none)
[12] UNION (anon) size=8 vlen=1
	sk type_id=13 bits_offset=0
[13] PTR (anon) type_id=31
[14] FUNC_PROTO (anon) return=15 args=(1 skb)
[15] INT int size=4 bits_offset=0 nr_bits=32 encoding=SIGNED
[16] FUNC _l2_to_iptun_ingress_forward type_id=14
[17] FUNC_PROTO (anon) return=15 args=(1 skb)
[18] FUNC _l2_to_iptun_ingress_redirect type_id=17
[19] FUNC_PROTO (anon) return=15 args=(1 skb)
[20] FUNC _l2_to_ip6tun_ingress_redirect type_id=19
[21] FUNC_PROTO (anon) return=15 args=(1 skb)
[22] FUNC _drop_non_tun_vip type_id=21
[23] STRUCT bpf_elf_map size=28 vlen=7
	type type_id=3 bits_offset=0
	size_key type_id=3 bits_offset=32
	size_value type_id=3 bits_offset=64
	max_elem type_id=3 bits_offset=96
	flags type_id=3 bits_offset=128
	id type_id=3 bits_offset=160
	pinning type_id=3 bits_offset=192
[24] VAR tun_iface type_id=23 linkage=1
[25] INT char size=1 bits_offset=0 nr_bits=8 encoding=SIGNED
[26] ARRAY (anon) type_id=25 index_type_id=6 nr_elems=4
[27] VAR _license type_id=26 linkage=1
[28] DATASEC license size=0 vlen=1 size == 0

+ ./tc_l2_redirect -U /sys/fs/bpf/tc/globals/tun_iface -i 19
+ ip netns exec ns1 ping -c1 10.10.1.102
+ [[ ingress == \e\g\r\e\s\s ]]
+ echo bail
bail
+ exit 1

--liOOAslEiF7prFVr--
