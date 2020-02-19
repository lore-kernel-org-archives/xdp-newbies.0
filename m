Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-lj1-f194.google.com ([209.85.208.194]:36646 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726760AbgBSWUx (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 19 Feb 2020 17:20:53 -0500
MIME-Version: 1.0
References: <F844EC8A-902B-4BF7-95E3-B0D6DC618F1B@redhat.com>
 <20200219203626.ozkdoyhyexwxwbbt@ast-mbp> <87o8tuw7gj.fsf@toke.dk>
In-Reply-To: <87o8tuw7gj.fsf@toke.dk>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Wed, 19 Feb 2020 14:20:39 -0800
Message-ID: <CAADnVQJzbAu3tdqn1DbyK+VFwYjp5rpgJOpPFLEcoe_mEr3YEw@mail.gmail.com>
Subject: Re: Capture xdp packets in an fentry BPF hook
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc: Eelco Chaudron <echaudro@redhat.com>, Alexei Starovoitov <ast@kernel.org>, Xdp <xdp-newbies@vger.kernel.org>, bpf <bpf@vger.kernel.org>, Jesper Dangaard Brouer <brouer@redhat.com>

On Wed, Feb 19, 2020 at 2:14 PM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>
> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>
> > On Wed, Feb 19, 2020 at 03:38:40PM +0100, Eelco Chaudron wrote:
> >> Hi Alexei at al.,
> >>
> >> I'm getting closer to finally have an xdpdump tool that uses the bpf
> >> fentry/fexit tracepoints, but I ran into a final hurdle...
> >>
> >> To stuff the packet into a perf ring I'll need to use the
> >> bpf_perf_event_output(), but unfortunately, this is a program of trace type,
> >> and not XDP so the packet data is not added automatically :(
> >>
> >> Secondly even trying to pass the actual packet data as a reference to
> >> bpf_perf_event_output() will not work as the verifier wants the data to be
> >> on the fp.
> >>
> >> Even worse, the trace program gets the XDP info not thought the ctx, but
> >> trough the fentry/fexit input value, i.e.:
> >>
> >>      SEC("fentry/func")
> >>      int BPF_PROG(trace_on_entry, struct xdp_buff *xdp)...
> >>
> >>      struct net_device {
> >>          int ifindex;
> >>      } __attribute__((preserve_access_index));
> >>
> >>      struct xdp_rxq_info {
> >>          struct net_device *dev;
> >>          __u32 queue_index;
> >>      } __attribute__((preserve_access_index));
> >>
> >>      struct xdp_buff {
> >>          void *data;
> >>          void *data_end;
> >>          void *data_meta;
> >>          void *data_hard_start;
> >>          unsigned long handle;
> >>          struct xdp_rxq_info *rxq;
> >>      } __attribute__((preserve_access_index));
> >>
> >> Hence even trying to copy in bytes to a local buffer is not allowed by the
> >> verifier, i.e. __u8 *data = (u8 *)(long)xdp->data;
> >>
> >> Can you let me know how you envisioned a BPF entry hook to capture packets
> >> from XDP. Am I missing something, or is there something missing from the
> >> infrastructure?
> >
> > Tracing of XDP is missing a helper similar to bpf_skb_output() for skb.
> > Its first arg will be 'struct xdp_buff *' and .arg1_type = ARG_PTR_TO_BTF_ID
> > then it will work similar to bpf_skb_output() in progs/kfree_skb.c.
>
> What about freplace? Since that is also using the tracing
> infrastructure, will the replacing program also be considered a tracing
> program by the verifier? Or is it possible to load a program with an XDP
> type, but still use it for freplace?

Please see freplace example in progs/fexit_bpf2bpf.c
freplace is not a separate type of program.
It's not tracing and it's not networking.
It's an extension of the target program.
If target prog is xdp prog the extension will have access
to the same struct xdp_md and the same xdp helpers.
