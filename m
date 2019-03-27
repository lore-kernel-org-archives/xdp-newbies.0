Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qt1-f169.google.com ([209.85.160.169]:44698 "EHLO
        mail-qt1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726810AbfC0GA0 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 27 Mar 2019 02:00:26 -0400
Received: by mail-qt1-f169.google.com with SMTP id w5so17464854qtb.11
        for <xdp-newbies@vger.kernel.org>; Tue, 26 Mar 2019 23:00:25 -0700 (PDT)
MIME-Version: 1.0
References: <CALDO+SYM1jcds1_duzRrVWFJd-DHOcC8DCqfgDsey26eXrf8Sw@mail.gmail.com>
In-Reply-To: <CALDO+SYM1jcds1_duzRrVWFJd-DHOcC8DCqfgDsey26eXrf8Sw@mail.gmail.com>
From: =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date: Wed, 27 Mar 2019 07:00:13 +0100
Message-ID: <CAJ+HfNj7+Cn1eJUwk+6UR-am_ugNYVJ_DykV25-G0ePpEPmc1w@mail.gmail.com>
Subject: Re: AF_XDP xdpsock rxdrop not seeing packets
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: William Tu <u9012063@gmail.com>
Cc: Xdp <xdp-newbies@vger.kernel.org>, Magnus Karlsson <magnus.karlsson@gmail.com>

On Tue, 26 Mar 2019 at 21:18, William Tu <u9012063@gmail.com> wrote:
>
> Hi,
>
> I'm testing xdpsock on the latest bpf-next and found that rxdrop does not=
 work.
>
> To reproduce the issue:
> -------------------------------
> ip netns add at_ns0
> ip link add p0 type veth peer name afxdp-p0
> ip link set p0 netns at_ns0
> ip link set dev afxdp-p0 up
> ip netns exec at_ns0 sh << NS_EXEC_HEREDOC
> ip addr add "10.1.1.1/24" dev p0
> ip link set dev p0 up
> NS_EXEC_HEREDOC
>
> ip addr add "10.1.1.2/24" dev afxdp-p0
> ip netns exec at_ns0 ping 10.1.1.2
> # the afxdp-p0 will receive ping packets
>
> At another console, run SKB mode rxdrop
> ------------------------------------------------------
> root@osboxes:~/bpf-next/samples/bpf# ./xdpsock -r -S -p -i afxdp-p0
>  sock0@afxdp-p0:0 rxdrop xdp-skb poll()
>                 pps         pkts        1.00
> rx              0           0
> tx              0           0
>
> Where I think xdpsock should receive packet here, but it's not.
> it turns out at rx_drop(),
> 514     ret =3D xsk_ring_prod__reserve(&xsk->umem->fq, rcvd, &idx_fq);
> 515     while (ret !=3D rcvd) {
> 518         if (ret < 0)
> 519             exit_with_error(-ret);
> 520         ret =3D xsk_ring_prod__reserve(&xsk->umem->fq, rcvd, &idx_fq)=
;
> 521     }
>
> It keeps retrying to reserve blocks in FQ but fails. I'm debugging
> this but any suggestions
> are welcome.
>

I tried your setup on bpf-next b4b6aa83433e ("selftests: bpf: don't
depend on hardcoded perf sample_freq"), and it works for me (both with
and w/o poll).

What do you get if you run the xdp_rxq_info?
  # xdp_rxq_info --dev afxdp-p0 --action XDP_DROP
  # xdp_rxq_info --dev afxdp-p0 -S --action XDP_DROP

I run "ping -fb 10.1.1.255" on the veth pair's other end.


Bj=C3=B6rn

> Regards,
> William
