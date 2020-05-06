Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33225 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728474AbgEFJIw (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Wed, 6 May 2020 05:08:52 -0400
Date: Wed, 6 May 2020 11:08:25 +0200
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: Fighting BPF verifier to reach end-of-packet with XDP
Message-ID: <20200506110825.2079224f@carbon>
In-Reply-To: <20200501174132.4388983e@carbon>
References: <20200501174132.4388983e@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Daniel Borkmann <borkmann@iogearbox.net>, Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: BPF-dev-list <bpf@vger.kernel.org>, Toke =?UTF-8?B?SMO4aWxhbmQtSsO4?= =?UTF-8?B?cmdlbnNlbg==?= <toke@redhat.com>, Matteo Croce <mcroce@redhat.com>, Lorenzo Bianconi <lorenzo.bianconi@redhat.com>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, brouer@redhat.com, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>

On Fri, 1 May 2020 17:41:32 +0200
Jesper Dangaard Brouer <brouer@redhat.com> wrote:

> Hi Daniel,
> 
> One use-case for tail grow patchset, is to add a kernel timestamp at
> XDP time in the extended tailroom of packet and return XDP_PASS to let
> packet travel were it needs to go, and then via tcpdump we can extract
> this timestamp. (E.g. this could improve on Ilias TSN measurements[2]).
>
> I have implemented it here[3]. It works, but it is really a hassle to
> convince the BPF verifier, that my program was safe.  I use the
> IP-headers total length to find the end-of-packet.

I moved the code example here experiment01-tailgrow[4]:
 [4] https://github.com/xdp-project/xdp-tutorial/blob/master/experiment01-tailgrow/xdp_prog_kern.c

People can follow the changes via PR# [123].
 [123] https://github.com/xdp-project/xdp-tutorial/pull/123


> Is there an easier BPF way to move a data pointer to data_end?

I've also added some "fail" examples[5]:
 [5] https://github.com/xdp-project/xdp-tutorial/tree/master/experiment01-tailgrow

That I will appreciate someone to review my explaining comments, on why
verifier chooses to fail these programs... as they might be wrong.

 
> Any suggestion on how I could extend the kernel (or verifier) to
> provide easier access to the tailroom I grow?

Is it possible to use the cls_bpf older style load_byte() helpers?
 
 
> [3] https://github.com/xdp-project/xdp-tutorial/blob/tailgrow01.public/packet04-tailgrow/xdp_prog_kern.c#L97-L115
> [1] https://patchwork.ozlabs.org/project/netdev/list/?series=173782&state=%2A&archive=both
> [2] https://github.com/xdp-project/xdp-project/blob/master/areas/arm64/xdp_for_tsn.org
> 
> 
> Relevant code copy-pasted below, to make it easier to email comment:
> 
> SEC("xdp_tailgrow_parse")
> int grow_parse(struct xdp_md *ctx)
> {
> 	void *data_end;
> 	void *data;
> 	int action = XDP_PASS;
> 	int eth_type, ip_type;
> 	struct hdr_cursor nh;
> 	struct iphdr *iphdr;
> 	struct ethhdr *eth;
> 	__u16 ip_tot_len;
> 
> 	struct my_timestamp *ts;
> 
> 	/* Increase packet size (at tail) and reload data pointers */
> 	__u8 offset = sizeof(*ts);
> 	if (bpf_xdp_adjust_tail(ctx, offset))
> 		goto out;
> 	data_end = (void *)(long)ctx->data_end;
> 	data = (void *)(long)ctx->data;
> 
> 	/* These keep track of the next header type and iterator pointer */
> 	nh.pos = data;
> 
> 	eth_type = parse_ethhdr(&nh, data_end, &eth);
> 	if (eth_type < 0) {
> 		action = XDP_ABORTED;
> 		goto out;
> 	}
> 
> 	if (eth_type == bpf_htons(ETH_P_IP)) {
> 		ip_type = parse_iphdr(&nh, data_end, &iphdr);
> 	} else {
> 		action = XDP_PASS;
> 		goto out;
> 	}
> 
> 	/* Demo use-case: Add timestamp in extended tailroom to ICMP packets,
> 	 * before sending to network-stack via XDP_PASS.  This can be
> 	 * captured via tcpdump, and provide earlier (XDP layer) timestamp.
> 	 */
> 	if (ip_type == IPPROTO_ICMP) {
> 
> 		/* Packet size in bytes, including IP header and data */
> 		ip_tot_len = bpf_ntohs(iphdr->tot_len);
> 
> 		/*
> 		 * Tricks to get pass the verifier. Being allowed to use
> 		 * packet value iphdr->tot_len, involves bounding possible
> 		 * values to please verifier.
> 		 */
> 		if (ip_tot_len < 2) {
> 			/* This check seems strange on unsigned ip_tot_len,
> 			 * but is needed, else verifier complains:
> 			 * "unbounded min value is not allowed"
> 			 */
> 			goto out;
> 		}
> 		ip_tot_len &= 0xFFF; /* Max 4095 */
> 
> 		/* Finding end of packet + offset, and bound access */
> 		if ((void *)iphdr + ip_tot_len + offset > data_end) {
> 			action = XDP_ABORTED;
> 			goto out;
> 		}
> 
> 		/* Point ts to end-of-packet, that have been offset extended */
> 		ts = (void *)iphdr + ip_tot_len;
> 		ts->magic = 0x5354; /* String "TS" in network-byte-order */
> 		ts->time  = bpf_ktime_get_ns();
> 	}
> out:
> 	return xdp_stats_record_action(ctx, action);
> }
> 



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
