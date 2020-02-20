Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:52912 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728056AbgBTNRy (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 20 Feb 2020 08:17:54 -0500
From: "Eelco Chaudron" <echaudro@redhat.com>
Subject: Re: Capture xdp packets in an fentry BPF hook
Date: Thu, 20 Feb 2020 14:17:41 +0100
Message-ID: <0B0D36B7-283E-468A-8DE1-C733FD9A9896@redhat.com>
In-Reply-To: <20200219203626.ozkdoyhyexwxwbbt@ast-mbp>
References: <F844EC8A-902B-4BF7-95E3-B0D6DC618F1B@redhat.com>
 <20200219203626.ozkdoyhyexwxwbbt@ast-mbp>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Alexei Starovoitov <ast@kernel.org>, Xdp <xdp-newbies@vger.kernel.org>, bpf <bpf@vger.kernel.org>, Toke =?utf-8?b?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>, Jesper Dangaard Brouer <brouer@redhat.com>



On 19 Feb 2020, at 21:36, Alexei Starovoitov wrote:

> On Wed, Feb 19, 2020 at 03:38:40PM +0100, Eelco Chaudron wrote:
>> Hi Alexei at al.,
>>
>> I'm getting closer to finally have an xdpdump tool that uses the bpf
>> fentry/fexit tracepoints, but I ran into a final hurdle...
>>
>> To stuff the packet into a perf ring I'll need to use the
>> bpf_perf_event_output(), but unfortunately, this is a program of 
>> trace type,
>> and not XDP so the packet data is not added automatically :(
>>
>> Secondly even trying to pass the actual packet data as a reference to
>> bpf_perf_event_output() will not work as the verifier wants the data 
>> to be
>> on the fp.
>>
>> Even worse, the trace program gets the XDP info not thought the ctx, 
>> but
>> trough the fentry/fexit input value, i.e.:
>>
>> 	SEC("fentry/func")
>> 	int BPF_PROG(trace_on_entry, struct xdp_buff *xdp)...
>>
>> 	struct net_device {
>> 	    int ifindex;
>> 	} __attribute__((preserve_access_index));
>>
>> 	struct xdp_rxq_info {
>> 	    struct net_device *dev;
>> 	    __u32 queue_index;
>> 	} __attribute__((preserve_access_index));
>>
>> 	struct xdp_buff {
>> 	    void *data;
>> 	    void *data_end;
>> 	    void *data_meta;
>> 	    void *data_hard_start;
>> 	    unsigned long handle;
>> 	    struct xdp_rxq_info *rxq;
>> 	} __attribute__((preserve_access_index));
>>
>> Hence even trying to copy in bytes to a local buffer is not allowed 
>> by the
>> verifier, i.e. __u8 *data = (u8 *)(long)xdp->data;
>>
>> Can you let me know how you envisioned a BPF entry hook to capture 
>> packets
>> from XDP. Am I missing something, or is there something missing from 
>> the
>> infrastructure?
>
> Tracing of XDP is missing a helper similar to bpf_skb_output() for 
> skb.
> Its first arg will be 'struct xdp_buff *' and .arg1_type = 
> ARG_PTR_TO_BTF_ID
> then it will work similar to bpf_skb_output() in progs/kfree_skb.c.

Thanks for clarifying the needs for a new helper. I will be on PTO next 
week but will work on a bpf_xdp_output() helper when I get back.

Cheers,

Eelco
