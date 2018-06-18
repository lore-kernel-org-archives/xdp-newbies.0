Return-Path: <zeffron@riotgames.com>
MIME-Version: 1.0
References: <CAC1LvL2x3=LRdMOmipEr-LZ5XwXVjirr1_oQcP305t0pfbPn1Q@mail.gmail.com>
 <20180618094056.4571a1c7@redhat.com>
In-Reply-To: <20180618094056.4571a1c7@redhat.com>
From: Zvi Effron <zeffron@riotgames.com>
Date: Mon, 18 Jun 2018 02:59:38 -0700
Message-ID: <CAC1LvL1iKVM_kNUcXRqUcpTQ7+LyoST28WJnEU57KNuO1wAWXA@mail.gmail.com>
Subject: Re: Packet access from bpf_perf_event_output
Content-Type: text/plain; charset="UTF-8"
List-ID: <xdp-newbies.vger.kernel.org>
To: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Xdp <xdp-newbies@vger.kernel.org>, toke@toke.dk

On Mon, Jun 18, 2018 at 12:41 AM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
> On Sun, 17 Jun 2018 18:07:02 -0700
> Zvi Effron <zeffron@riotgames.com> wrote:
>
> > Hi XDPeople!
> >
> > In /include/uapi/linux/bpf.h, (in 4.18-rc1) the comment describing
> > bpf_perf_event_output says:
> >
> > /*
> >  * Note that this helper is not restricted to tracing use cases
> >  * and can be used with programs attached to TC or XDP as well,
> >  * where it allows for passing data to user space listeners. Data
> >  * can be:
> >  *
> >  * * Only custom structs,
> >  * * Only the packet payload, or
> >  * * A combination of both.
> >  */
> >
> > This seems to imply that for both TC and XDP, the packet can be used
> > for passing data. When I try this, the verifier rejects the program
> > with "helper access to the packet is not allowed". Looking through the
> > kernel it doesn't look like bpf_perf_output_event has been tagged with
> > the appropriate metadata to allow it to access the packet structure,
> > either for TC or for XDP. Neither bpf_skb_event_output_proto nor
> > bpf_xdp_event_output_proto have pkt_acess set to true. Is the
> > documentation incorrect, should that metadata be updated to allow
> > packet access, or is there something I'm missing?
>
> Toke (Cc'ed) recently posted a samples/bpf/ program to the kernel that
> implement this (but it didn't reach the merge window).  Thus, I assume
> that this works...
>
>  http://lkml.kernel.org/r/152830792912.21161.3609946361971472545.stgit@alrua-kau

Thank you for the example. I was trying to pass the packet as the
event metadata, but it looks like the correct way is to simply pass
the length as the upper 32 bits of the flags. Might be beneficial to
update the documentation in bpf.h to say that instead of just having
some samples with comments. But that example in the samples folder
with the comment explaining the flags in more detail is super useful.

Interestingly, even without trying that, I'm now getting ENOTSUPP even
if continue outputting the string I was before without any packet
data. As far as I can tell, that means I'm somehow hitting the
implementation of bpf_perf_output() in kernel/bpf/core.c instead of
the one in kernel/trace/bpf_trace.c. I'm not sure what changed as I
was able to emit events before. I've tried rebuilding my VM to negate
any changes made by installing bcc (I'm using Fedora-29 from rawhide,
last known good from 2018-06-04).

I'll keep investigating, but if anyone has any ideas, they'd be appreciated.

Thank you!
--Zvi

> --
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
