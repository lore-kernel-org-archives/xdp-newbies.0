Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:31809 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726511AbgD2LvY (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 29 Apr 2020 07:51:24 -0400
From: "Eelco Chaudron" <echaudro@redhat.com>
Subject: fentry/fexit trace to BPF_PROG_TYPE_EXT BPF program not working
Date: Wed, 29 Apr 2020 13:51:15 +0200
Message-ID: <666CF27B-18B4-420B-A0FC-29947DB1682D@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Alexei Starovoitov <ast@kernel.org>, Xdp <xdp-newbies@vger.kernel.org>
Cc: Toke =?utf-8?b?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>

Hi Alexie at al.

I was trying to attach a fentry/fexit trace to BPF_PROG_TYPE_EXT BPF 
program but I'm getting a verifier error, and not sure why. Is this 
supported?

This is the error:

libbpf: -- BEGIN DUMP LOG ---
libbpf:
arg#0 type is not a struct
Unrecognized arg#0 type PTR
; int BPF_PROG(trace_on_entry, struct xdp_md *xdp)
0: (79) r1 = *(u64 *)(r1 +0)
invalid bpf_context access off=0 size=8
processed 1 insns (limit 1000000) max_states_per_insn 0 total_states 0 
peak_states 0 mark_read 0
libbpf: -- END LOG --

This is the actual fentry code using the BPF_PROG macro from 
tools/lib/bpf/bpf_tracing.h:

SEC("fentry/func")
int BPF_PROG(trace_on_entry, struct xdp_md *xdp)
{
     trace_to_perf_buffer(xdp, false, 0);
     return 0;
}

And some more details from bpftool on the program I try to attach to:

# bpftool prog show id 165
165: ext  name xdp_test_I  tag b5a46c6e9935298c  gpl
     loaded_at 2020-04-28T13:41:00+0000  uid 0
     xlated 136B  jited 108B  memlock 4096B
     btf_id 432

# bpftool prog dump xlated id 165
int xdp_test_I(struct xdp_md * ctx):
; int xdp_test_I(struct xdp_md *ctx)
    0: (b7) r2 = 10
; bpf_debug("PASS[1]: prog %u\n", ctx->ingress_ifindex);
    1: (6b) *(u16 *)(r10 -8) = r2
    2: (18) r2 = 0x752520676f727020
    4: (7b) *(u64 *)(r10 -16) = r2
    5: (18) r2 = 0x3a5d315b53534150
    7: (7b) *(u64 *)(r10 -24) = r2
    8: (79) r3 = *(u64 *)(r1 +40)
    9: (79) r3 = *(u64 *)(r3 +0)
   10: (61) r3 = *(u32 *)(r3 +256)
   11: (bf) r1 = r10
;
   12: (07) r1 += -24
; bpf_debug("PASS[1]: prog %u\n", ctx->ingress_ifindex);
   13: (b7) r2 = 18
   14: (85) call bpf_trace_printk#-54752
; return XDP_PASS;
   15: (b7) r0 = 2
   16: (95) exit

Thanks in advance...

//Eelco
