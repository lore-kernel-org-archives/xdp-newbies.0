Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qk0-f171.google.com ([209.85.220.171]:44321 "EHLO
        mail-qk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752257AbeAEWWg (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Fri, 5 Jan 2018 17:22:36 -0500
Received: by mail-qk0-f171.google.com with SMTP id v188so7751247qkh.11
        for <xdp-newbies@vger.kernel.org>; Fri, 05 Jan 2018 14:22:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170513.183628.2041405131228393819.davem@davemloft.net>
References: <20170513.183628.2041405131228393819.davem@davemloft.net>
From: Charlemagne Lasse <charlemagnelasse@gmail.com>
Date: Fri, 5 Jan 2018 23:22:34 +0100
Message-ID: <CAFGhKbwwPKmpDqH3eTXD9AAV+CsLfepkb_fLtqdNVzUHywzqwQ@mail.gmail.com>
Subject: Re: Contextually speaking...
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: David Miller <davem@davemloft.net>
Cc: xdp-newbies@vger.kernel.org

2017-05-13 23:36 GMT+02:00 David Miller <davem@davemloft.net>:
<snip>
> So our example program above needs a little bit of an adjustment to
> make it suitable for BPF_PROG_TYPE_SOCK_FILTER:
>
> SEC("my_program")
> int my_main(struct __sk_buff *skb)
> {
>         void *data_end = (void *)(long)skb->data_end;
>         void *data = (void *)(long)skb->data;
>         struct ethhdr *eth = (struct ethhdr *)(data);
>         int len = skb->len;
>
>         if (eth + 1 > data_end)
>                 return 0;
>         if (eth->h_proto == bpf_htons(ETH_P_IP))
>                 return len;
>         return 0;
> }
>
> So what changed is that we load "len" from the context metadata and
> return "len" when we want to accept the packet.  This says "accept
> the packet and do not truncate it."

This cannot work with BPF_PROG_TYPE_SOCKET_FILTER because skb->data_end
and skb->data cannot be accessed by this BPF_PROG type. The verifier will
reject it with

0: (b7) r0 = 0
1: (61) r2 = *(u32 *)(r1 +80)
invalid bpf_context access off=80 size=4

Reason for that is the function sk_filter_is_valid_access which checks
the access to the __sk_buff context pointer (r1):

static bool sk_filter_is_valid_access(int off, int size,
      enum bpf_access_type type,
      struct bpf_insn_access_aux *info)
{
    switch (off) {
    case bpf_ctx_range(struct __sk_buff, tc_classid):
    case bpf_ctx_range(struct __sk_buff, data):
    case bpf_ctx_range(struct __sk_buff, data_meta):
    case bpf_ctx_range(struct __sk_buff, data_end):
    case bpf_ctx_range_till(struct __sk_buff, family, local_port):
        return false;
    }
