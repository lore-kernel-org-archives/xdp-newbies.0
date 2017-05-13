Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:46666 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756333AbdEMWgb (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Sat, 13 May 2017 18:36:31 -0400
Received: from localhost (cpe-66-108-81-97.nyc.res.rr.com [66.108.81.97])
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 21C9812363DF3
        for <xdp-newbies@vger.kernel.org>; Sat, 13 May 2017 14:55:00 -0700 (PDT)
Date: Sat, 13 May 2017 18:36:28 -0400 (EDT)
Message-Id: <20170513.183628.2041405131228393819.davem@davemloft.net>
Subject: Contextually speaking...
From: David Miller <davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org


Every eBPF program has a type, and that type is important because it
determines the kind of "context" which will be passed into your
program so that it can do it's work.

The context is the argument passed into the main entry point of your
eBPF program.

The eBPF program type is specified when the program is loaded via the
sys_bpf() system call.  For most of us this is usually achieved by
calling bpf_load_program() in libbpf.  "enum bpf_prog_type" currently
has the following values:

	BPF_PROG_TYPE_SOCKET_FILTER
	BPF_PROG_TYPE_KPROBE
	BPF_PROG_TYPE_SCHED_CLS
	BPF_PROG_TYPE_SCHED_ACT
	BPF_PROG_TYPE_TRACEPOINT
	BPF_PROG_TYPE_XDP
	BPF_PROG_TYPE_PERF_EVENT
	BPF_PROG_TYPE_CGROUP_SKB
	BPF_PROG_TYPE_CGROUP_SOCK
	BPF_PROG_TYPE_LWT_IN
	BPF_PROG_TYPE_LWT_OUT
	BPF_PROG_TYPE_LWT_XMIT

More can appear in the future.

For example, BPF_PROG_TYPE_SOCK_FILTER takes a "struct __sk_buff *" as
it's context argument.  Programs of type BPF_PROG_TYPE_SCHED_CLS and
BPF_PROG_TYPE_SCHED_ACT also take "struct __sk_buff *" as their
context argument.

These three program types have another thing in common, they are
allowed to use the LD_ABS and LD_IND instructions to access packet
data.  You cannot (currently) generate these from C code, only from
hand written eBPF assembler.  But they are important to understand
in their historical context.

LD_ABS and LD_IND simply allow byte, half-word, and word sized loads
to the packet data.  The value returned is in cpu endianness.  These
two instructions come from classical BPF, and are thus older than some
of you reading this text right now.

Therefore, if you look at libpcap or any other piece of code that
generates classical BPF, you will see that it makes use of LD_ABS and
LD_IND.

But from C code, you can load members of "struct __sk_buff" and access
packet data directly using what you get from there.  We will refer to
this as "direct packet access" And this brings us to an important
topic.

Any direct packet access must be properly validated before it is
performed.  We'll get into what that means exactly in just a second.
If proper validation is not performed, the eBPF verifier will reject
your program and refuse to load it.

Here is how you do it.  Let's write a very simple program that returns
"1" if we have an ipv4 ethernet packet, and "0" otherwise.

SEC("my_program")
int my_main(struct __sk_buff *skb)
{
	void *data_end = (void *)(long)skb->data_end;
	void *data = (void *)(long)skb->data;

Here we load the extents of the packet data, basically the start and
end pointers.  The casts in the assignments are necessary, so please
just copy this pattern into your programs.

The packet starts with the ethernet header, so let's get that going:

	struct ethhdr *eth = (struct ethhdr *)(data);

Now, we can't just go "eth->h_proto", that's illegal.  We have to
explicitly test that such an access is in range and doesn't go
beyond "data_end".

So let's make that test:

	if (eth + 1 > data_end)
		return 0;

The eBPF verifier will see that "eth" holds a packet pointer,
and also that you have made sure that from "eth" to "eth + 1"
is inside the valid access range for the packet.

Therefore, from this point forward you may validly access any part of
"struct ethhdr" via the variable "eth".  Let's do that.

	if (eth->h_proto == bpf_htons(ETH_P_IP))
		return 1;
	return 0;
}

And that's it.

The program type has another influence on your program.  It determines
the meaning of your program's return value.

A program of type BPF_PROG_TYPE_SOCK_FILTER returns the number of
bytes of the packet which should be accepted by the filter.  A return
value of zero means drop the packet.  A non-zero return value means to
truncate the packet to that many bytes, and accept it.

So our example program above needs a little bit of an adjustment to
make it suitable for BPF_PROG_TYPE_SOCK_FILTER:

SEC("my_program")
int my_main(struct __sk_buff *skb)
{
	void *data_end = (void *)(long)skb->data_end;
	void *data = (void *)(long)skb->data;
	struct ethhdr *eth = (struct ethhdr *)(data);
	int len = skb->len;

	if (eth + 1 > data_end)
		return 0;
	if (eth->h_proto == bpf_htons(ETH_P_IP))
		return len;
	return 0;
}

So what changed is that we load "len" from the context metadata and
return "len" when we want to accept the packet.  This says "accept
the packet and do not truncate it."
