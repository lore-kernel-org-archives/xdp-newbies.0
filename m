Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:25523 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726961AbgBJOl2 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 10 Feb 2020 09:41:28 -0500
From: "Eelco Chaudron" <echaudro@redhat.com>
Subject: Doing a bpf trace of an XDP bpf program using bpf_perf_event_output()
Date: Mon, 10 Feb 2020 15:41:20 +0100
Message-ID: <8768549E-2139-4CB0-ACDC-024AF14E2C3C@redhat.com>
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; format=flowed
To: Xdp <xdp-newbies@vger.kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>

I'm trying to send a packet capture to user space using 
bpf_perf_event_output(). However, the verifier is not liking the context 
I pass to it.

Code looks something like this (note this is an fentry bpf type trace):

static inline void trace_to_perf_buffer(struct xdp_buff *xdp)
{
...
...
     bpf_perf_event_output(xdp, &capture_map, flags,
                   &metadata, sizeof(metadata));
}

SEC("fentry/xdpfilt_blk_all")
int BPF_PROG(trace_on_entry, struct xdp_buff *xdp)
{
     trace_to_perf_buffer(xdp);
     bpf_debug("fentry: [ifindex = %u, queue =  %u]\n",
           xdp->rxq->dev->ifindex, xdp->rxq->queue_index);
     return 0;
}

The verifier does not like the context I pass:

...
from 9 to 13: R1=ptr_xdp_buff(id=0,off=0,imm=0) R2=inv(id=0) 
R3=inv(id=0) R4=ptr_xdp_buff(id=0,off=8,imm=0) R10=fp0
; metadata.pkt_len = (__u16)(data_end - data);
13: (1f) r2 -= r3
...
...
; bpf_perf_event_output((void *)xdp, &capture_map, flags,
42: (18) r2 = 0xffff9a55f047c000
44: (b7) r5 = 12
45: (85) call bpf_perf_event_output#25
R1 type=ptr_ expected=ctx


What context should I pass, or do I even have it in the bpf trace 
program?

Thanks,

Eelco
