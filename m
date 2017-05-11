Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:54236 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752011AbdEKUW5 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 11 May 2017 16:22:57 -0400
Received: from localhost (cpe-66-108-81-97.nyc.res.rr.com [66.108.81.97])
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F202C1235ABD3
        for <xdp-newbies@vger.kernel.org>; Thu, 11 May 2017 12:41:25 -0700 (PDT)
Date: Thu, 11 May 2017 16:22:53 -0400 (EDT)
Message-Id: <20170511.162253.804759440262970080.davem@davemloft.net>
Subject: bpf.h and you...
From: David Miller <davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org


To write a proper eBPF program you're going to need some common
definitions and types defined in linux/bpf.h, so please include it. :)

	#include <linux/bpf.h>

You'll also need another header, bpf_helpers.h, include it too:

	#include "bpf_helpers.h"

The build environment should be setting up the include paths
so that the above two include directives work.

The first helper you should be aware of in those headers is
the macro "SEC()".  It is used to place data and code from
your eBPF program into specific named sections.

For example, all maps need to go into a section named "maps".
This is critical because the ELF loader for eBPF programs
looks for maps by scanning the ELF section named "maps".

So you would say something like this:

struct bpf_map_def SEC("maps") my_map = {
	.type = BPF_MAP_TYPE_PERCPU_ARRAY,
	.key_size = sizeof(__u32),
	.value_size = sizeof(__u64),
	.max_entries = 256,
};

You should also put your main code entry point function into a named
section as well.  Other than avoiding special section names such as
"maps", you can basically name it however you wish.

For example:

SEC("xdp_tx_iptunnel")
int _xdp_tx_iptunnel(struct xdp_md *xdp)
{

Or, for example:

SEC("xdp1")
int xdp_prog1(struct xdp_md *ctx)
{

And, finally:

SEC("socket1")
int bpf_prog1(struct __sk_buff *skb)
{

Another special section name is "license" which you can use like
this:

char _license[] SEC("license") = "GPL";

Certain symbols and helpers are only accessible to programs
which use a license which is "GPL compatible".  The following
licenses are accepted as "GPL comptaible"

	GPL
	GPL v2
	GPL and additional rights
	Dual BSD/GPL
	Dual MIT/GPL
	Dual MPL/GPL

There is also a special section named "version" and this stores a
kernel version code, for example:

u32 _version SEC("version") = LINUX_VERSION_CODE;

You can use this to define what kernel version your eBPF program is
compatible with.  This especially comes into play for eBPF programs
used for tracing, and which depend upon kernel function signatures
etc. for correct operation.

A neat thing you can do using sections is construct "tail calls".
These are eBPF programs called from other eBPF programs.  A good
example of this construct can be found in samples/bpg/sockex3_kern.c
in the kernel sources.  Here are the important parts for our
discussion here:

#define PROG(F) SEC("socket/"__stringify(F)) int bpf_func_##F

struct bpf_map_def SEC("maps") jmp_table = {
	.type = BPF_MAP_TYPE_PROG_ARRAY,
	.key_size = sizeof(u32),
	.value_size = sizeof(u32),
	.max_entries = 8,
};

#define PARSE_VLAN 1
#define PARSE_MPLS 2
#define PARSE_IP 3
#define PARSE_IPV6 4

So, tail calls are dispatched through a special eBPF map called
a "program array" which uses type "BPF_MAP_TYPE_PROG_ARRAY",
it always uses a key_size of 4 and a value_size of 4, or
more portably "sizeof(u32)".

To dispatch to programs in the table, use the helper function
named "bpf_tail_call()", which takes 3 arguments:

1) The "context pointer", which was the first argument given
   to your main entrypoint function.

2) A reference to the program array map, this would be
   "&jmp_table" for the above.

3) The index into the program array to be invoked.  This
   will be one of the 4 PARSE_* values defined above.

Here is the dispatch:

static inline void parse_eth_proto(struct __sk_buff *skb, u32 proto)
{
	switch (proto) {
	case ETH_P_8021Q:
	case ETH_P_8021AD:
		bpf_tail_call(skb, &jmp_table, PARSE_VLAN);
		break;
	case ETH_P_MPLS_UC:
	case ETH_P_MPLS_MC:
		bpf_tail_call(skb, &jmp_table, PARSE_MPLS);
		break;
	case ETH_P_IP:
		bpf_tail_call(skb, &jmp_table, PARSE_IP);
		break;
	case ETH_P_IPV6:
		bpf_tail_call(skb, &jmp_table, PARSE_IPV6);
		break;
	}
}

So, depending upon the ethernet protocol value, we invoke one of the 4
defined tail call routines.

Please note that tail calls aren't like normal function calls.  When
the tail call completes, the entire eBPF program finishes, it doesn't
continue on from the bpf_tail_call() call site.

Now we define the tail call functions themselves by putting them into
specially named sections:

PROG(PARSE_IP)(struct __sk_buff *skb)
{
 ...
}

PROG(PARSE_IPV6)(struct __sk_buff *skb)
{
 ...
}

PROG(PARSE_VLAN)(struct __sk_buff *skb)
{
 ...
}

PROG(PARSE_MPLS)(struct __sk_buff *skb)
{
 ...
}

And then finally we have the main program which calls into the
tail call dispatch after the ethernet protocol field has been
extracted from the packet's ethernet header:

SEC("socket/0")
int main_prog(struct __sk_buff *skb)
{
	__u32 nhoff = ETH_HLEN;
	__u32 proto = load_half(skb, 12);

	skb->cb[0] = nhoff;
	parse_eth_proto(skb, proto);
	return 0;
}

That should give you a good idea of the overall high level structure
of a reasonably sophisticated eBPF program.

Until next time...
