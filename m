Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-vk0-f67.google.com ([209.85.213.67]:36463 "EHLO
        mail-vk0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753951AbeFRByt (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Sun, 17 Jun 2018 21:54:49 -0400
Received: by mail-vk0-f67.google.com with SMTP id o138-v6so8617284vkd.3
        for <xdp-newbies@vger.kernel.org>; Sun, 17 Jun 2018 18:54:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAC1LvL2x3=LRdMOmipEr-LZ5XwXVjirr1_oQcP305t0pfbPn1Q@mail.gmail.com>
References: <CAC1LvL2x3=LRdMOmipEr-LZ5XwXVjirr1_oQcP305t0pfbPn1Q@mail.gmail.com>
From: Y Song <ys114321@gmail.com>
Date: Sun, 17 Jun 2018 18:54:08 -0700
Message-ID: <CAH3MdRXd8q+pgFrEX23C5oDYS7aQeZhiy=TEZWGL3G0etdz7AA@mail.gmail.com>
Subject: Re: Packet access from bpf_perf_event_output
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Zvi Effron <zeffron@riotgames.com>
Cc: Xdp <xdp-newbies@vger.kernel.org>

On Sun, Jun 17, 2018 at 6:07 PM, Zvi Effron <zeffron@riotgames.com> wrote:
> Hi XDPeople!
>
> In /include/uapi/linux/bpf.h, (in 4.18-rc1) the comment describing
> bpf_perf_event_output says:
>
> /*
>  * Note that this helper is not restricted to tracing use cases
>  * and can be used with programs attached to TC or XDP as well,
>  * where it allows for passing data to user space listeners. Data
>  * can be:
>  *
>  * * Only custom structs,
>  * * Only the packet payload, or
>  * * A combination of both.
>  */
>
> This seems to imply that for both TC and XDP, the packet can be used
> for passing data. When I try this, the verifier rejects the program
> with "helper access to the packet is not allowed". Looking through the
> kernel it doesn't look like bpf_perf_output_event has been tagged with
> the appropriate metadata to allow it to access the packet structure,
> either for TC or for XDP. Neither bpf_skb_event_output_proto nor

The implementation is in net/core/filter.c

static const struct bpf_func_proto *
xdp_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
{
        switch (func_id) {
        case BPF_FUNC_perf_event_output:
                return &bpf_xdp_event_output_proto;
......

BPF_CALL_5(bpf_xdp_event_output, struct xdp_buff *, xdp, struct bpf_map *, map,
           u64, flags, void *, meta, u64, meta_size)
{
        u64 xdp_size = (flags & BPF_F_CTXLEN_MASK) >> 32;

        if (unlikely(flags & ~(BPF_F_CTXLEN_MASK | BPF_F_INDEX_MASK)))
                return -EINVAL;
        if (unlikely(xdp_size > (unsigned long)(xdp->data_end - xdp->data)))
                return -EFAULT;

        return bpf_event_output(map, flags, meta, meta_size, xdp->data,
                                xdp_size, bpf_xdp_copy);
}

static const struct bpf_func_proto bpf_xdp_event_output_proto = {
        .func           = bpf_xdp_event_output,
        .gpl_only       = true,
        .ret_type       = RET_INTEGER,
        .arg1_type      = ARG_PTR_TO_CTX,
        .arg2_type      = ARG_CONST_MAP_PTR,
        .arg3_type      = ARG_ANYTHING,
        .arg4_type      = ARG_PTR_TO_MEM,
        .arg5_type      = ARG_CONST_SIZE_OR_ZERO,
};

Both tracing and networking uses the same func id
BPF_FUNC_perf_event_output, but depending on program type,
the implementation of the helper is different.

> bpf_xdp_event_output_proto have pkt_acess set to true. Is the
> documentation incorrect, should that metadata be updated to allow
> packet access, or is there something I'm missing?
>
> Thank you!
> --Zvi
