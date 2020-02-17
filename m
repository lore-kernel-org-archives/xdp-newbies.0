Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:20941 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726707AbgBQNsg (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 17 Feb 2020 08:48:36 -0500
From: "Eelco Chaudron" <echaudro@redhat.com>
Subject: Re: Doing a bpf trace of an XDP bpf program using
 bpf_perf_event_output()
Date: Mon, 17 Feb 2020 14:48:27 +0100
Message-ID: <0B4AECED-C783-465B-9A7D-0335CF775CE7@redhat.com>
In-Reply-To: <8768549E-2139-4CB0-ACDC-024AF14E2C3C@redhat.com>
References: <8768549E-2139-4CB0-ACDC-024AF14E2C3C@redhat.com>
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; format=flowed
To: Xdp <xdp-newbies@vger.kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>



On 10 Feb 2020, at 15:41, Eelco Chaudron wrote:

<SNIP<

> SEC("fentry/xdpfilt_blk_all")
> int BPF_PROG(trace_on_entry, struct xdp_buff *xdp)
> {
>     trace_to_perf_buffer(xdp);
>     bpf_debug("fentry: [ifindex = %u, queue =  %u]\n",
>           xdp->rxq->dev->ifindex, xdp->rxq->queue_index);
>     return 0;
> }

Ignore this email, as I totally missed the ctx hidden in the BPF_PROG() 
macro :(

> The verifier does not like the context I pass:
>
> ...
> from 9 to 13: R1=ptr_xdp_buff(id=0,off=0,imm=0) R2=inv(id=0) 
> R3=inv(id=0) R4=ptr_xdp_buff(id=0,off=8,imm=0) R10=fp0
> ; metadata.pkt_len = (__u16)(data_end - data);
> 13: (1f) r2 -= r3
> ...
> ...
> ; bpf_perf_event_output((void *)xdp, &capture_map, flags,
> 42: (18) r2 = 0xffff9a55f047c000
> 44: (b7) r5 = 12
> 45: (85) call bpf_perf_event_output#25
> R1 type=ptr_ expected=ctx
>
>
> What context should I pass, or do I even have it in the bpf trace 
> program?
>
> Thanks,
>
> Eelco
