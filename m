Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:22857 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728841AbgEMO6z (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 13 May 2020 10:58:55 -0400
From: "Eelco Chaudron" <echaudro@redhat.com>
Subject: Re: fentry/fexit trace to BPF_PROG_TYPE_EXT BPF program not working
Date: Wed, 13 May 2020 16:58:46 +0200
Message-ID: <917D3B95-2FB0-4785-9B5E-F4AA6B9104BE@redhat.com>
In-Reply-To: <CAADnVQJGdEJaW6oQbFOQYJWJxhjY-P=jawYYedb_qDN4zZufQg@mail.gmail.com>
References: <666CF27B-18B4-420B-A0FC-29947DB1682D@redhat.com>
 <CAADnVQJGdEJaW6oQbFOQYJWJxhjY-P=jawYYedb_qDN4zZufQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Alexei Starovoitov <ast@kernel.org>, Xdp <xdp-newbies@vger.kernel.org>, Toke =?utf-8?b?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>



On 6 May 2020, at 3:45, Alexei Starovoitov wrote:

> On Wed, Apr 29, 2020 at 4:51 AM Eelco Chaudron <echaudro@redhat.com> 
> wrote:
>>
>> Hi Alexie at al.
>>
>> I was trying to attach a fentry/fexit trace to BPF_PROG_TYPE_EXT BPF
>> program but I'm getting a verifier error, and not sure why. Is this
>> supported?
>
> The intent was to make it possible.
> The verifier comment says:
>                         /* Cannot fentry/fexit another fentry/fexit 
> program.
>                          * Cannot attach program extension to another 
> extension.
>                          * It's ok to attach fentry/fexit to extension 
> program.
>                          */
>

I tried it with the freplace in the fexit_bpf2bpf.c test, and here it 
works fine.

>> This is the error:
>>
>> libbpf: -- BEGIN DUMP LOG ---
>> libbpf:
>> arg#0 type is not a struct
>> Unrecognized arg#0 type PTR
>
> looks like verifier got confused here.
> It should have detected correct btf_id from freplace prog.
> not sure what's going on.

This is an EXT BPF program using the, struct xdp_md *xdp, so not sure 
how to connect.
So I did try both:

- int BPF_PROG(trace_on_entry, struct xdp_md *xdp)
- int BPF_PROG(trace_on_entry, struct xdp_buff *xdp)

This is the information from bpftool:

./bpftool prog show id 46
46: ext  name xdp_test_I  tag b5a46c6e9935298c  gpl
	loaded_at 2020-05-13T08:54:53+0000  uid 0
	xlated 136B  jited 108B  memlock 4096B
	btf_id 16

./bpftool btf dump id 16
[1] PTR '(anon)' type_id=2
[2] STRUCT 'xdp_md' size=20 vlen=5
	'data' type_id=3 bits_offset=0
	'data_end' type_id=3 bits_offset=32
	'data_meta' type_id=3 bits_offset=64
	'ingress_ifindex' type_id=3 bits_offset=96
	'rx_queue_index' type_id=3 bits_offset=128
[3] TYPEDEF '__u32' type_id=4
[4] INT 'unsigned int' size=4 bits_offset=0 nr_bits=32 encoding=(none)
[5] FUNC_PROTO '(anon)' ret_type_id=6 vlen=1
	'ctx' type_id=1
[6] INT 'int' size=4 bits_offset=0 nr_bits=32 encoding=SIGNED
[7] FUNC 'xdp_test_I' type_id=5 linkage=global
[8] INT 'char' size=1 bits_offset=0 nr_bits=8 encoding=SIGNED
[9] ARRAY '(anon)' type_id=8 index_type_id=10 nr_elems=4
[10] INT '__ARRAY_SIZE_TYPE__' size=4 bits_offset=0 nr_bits=32 
encoding=(none)
[11] VAR '_license' type_id=9, linkage=global-alloc
[12] DATASEC 'license' size=4 vlen=1
	type_id=11 offset=0 size=4


./bpftool prog dump xlated id 46
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
   14: (85) call bpf_trace_printk#-56048
; return XDP_PASS;
   15: (b7) r0 = 2
   16: (95) exit

#include <linux/bpf.h>
#include <bpf/bpf_helpers.h>
#include <xdp/xdp_helpers.h>

#define bpf_debug(fmt, ...)                         \
     {                                               \
         char __fmt[] = fmt;                         \
         bpf_trace_printk(__fmt, sizeof(__fmt),      \
                          ##__VA_ARGS__);            \
     }

SEC("xdp_test_prog_I")
int xdp_test_I(struct xdp_md *ctx)
{
     bpf_debug("PASS[1]: prog %u\n", ctx->ingress_ifindex);
     return XDP_PASS;
}


Any idea??
