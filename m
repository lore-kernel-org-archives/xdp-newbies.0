Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:37396 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754876AbeFRHlA (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 18 Jun 2018 03:41:00 -0400
Date: Mon, 18 Jun 2018 09:40:56 +0200
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: Packet access from bpf_perf_event_output
Message-ID: <20180618094056.4571a1c7@redhat.com>
In-Reply-To: <CAC1LvL2x3=LRdMOmipEr-LZ5XwXVjirr1_oQcP305t0pfbPn1Q@mail.gmail.com>
References: <CAC1LvL2x3=LRdMOmipEr-LZ5XwXVjirr1_oQcP305t0pfbPn1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Zvi Effron <zeffron@riotgames.com>
Cc: Xdp <xdp-newbies@vger.kernel.org>, brouer@redhat.com, Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@toke.dk>

On Sun, 17 Jun 2018 18:07:02 -0700
Zvi Effron <zeffron@riotgames.com> wrote:

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
> bpf_xdp_event_output_proto have pkt_acess set to true. Is the
> documentation incorrect, should that metadata be updated to allow
> packet access, or is there something I'm missing?

Toke (Cc'ed) recently posted a samples/bpf/ program to the kernel that
implement this (but it didn't reach the merge window).  Thus, I assume
that this works...

 http://lkml.kernel.org/r/152830792912.21161.3609946361971472545.stgit@alrua-kau

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
