Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-ot1-f66.google.com ([209.85.210.66]:40068 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729151AbfBRIU4 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 18 Feb 2019 03:20:56 -0500
MIME-Version: 1.0
References: <1549631126-29067-1-git-send-email-magnus.karlsson@intel.com>
 <36557463-D23A-432E-AA18-7731F43CEBA6@gmail.com> <CAJ8uoz19UjmEHTc28Qd_9KdY9D-ojXSBRTbmffRhUTX49mnWvg@mail.gmail.com>
 <20190213125530.4a7fb8bc@carbon> <20ba7719-b660-462c-a6bf-6c749e1f2f30@iogearbox.net>
In-Reply-To: <20ba7719-b660-462c-a6bf-6c749e1f2f30@iogearbox.net>
From: Magnus Karlsson <magnus.karlsson@gmail.com>
Date: Mon, 18 Feb 2019 09:20:43 +0100
Message-ID: <CAJ8uoz3kRrXJCthhm4u=0Z-7=uNryB_r8Yj3p7inYEPjtLp2Kw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 0/2] libbpf: adding AF_XDP support
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>, Jonathan Lemon <jonathan.lemon@gmail.com>, Magnus Karlsson <magnus.karlsson@intel.com>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>, ast@kernel.org, Network Development <netdev@vger.kernel.org>, Jakub Kicinski <jakub.kicinski@netronome.com>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>, "Zhang, Qi Z" <qi.z.zhang@intel.com>, xiaolong.ye@intel.com, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>

On Fri, Feb 15, 2019 at 5:48 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 02/13/2019 12:55 PM, Jesper Dangaard Brouer wrote:
> > On Wed, 13 Feb 2019 12:32:47 +0100
> > Magnus Karlsson <magnus.karlsson@gmail.com> wrote:
> >> On Mon, Feb 11, 2019 at 9:44 PM Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
> >>> On 8 Feb 2019, at 5:05, Magnus Karlsson wrote:
> >>>
> >>>> This patch proposes to add AF_XDP support to libbpf. The main reason
> >>>> for this is to facilitate writing applications that use AF_XDP by
> >>>> offering higher-level APIs that hide many of the details of the AF_XDP
> >>>> uapi. This is in the same vein as libbpf facilitates XDP adoption by
> >>>> offering easy-to-use higher level interfaces of XDP
> >>>> functionality. Hopefully this will facilitate adoption of AF_XDP, make
> >>>> applications using it simpler and smaller, and finally also make it
> >>>> possible for applications to benefit from optimizations in the AF_XDP
> >>>> user space access code. Previously, people just copied and pasted the
> >>>> code from the sample application into their application, which is not
> >>>> desirable.
> >>>
> >>> I like the idea of encapsulating the boilerplate logic in a library.
> >>>
> >>> I do think there is an important missing piece though - there should be
> >>> some code which queries the netdev for how many queues are attached, and
> >>> create the appropriate number of umem/AF_XDP sockets.
> >>>
> >>> I ran into this issue when testing the current AF_XDP code - on my test
> >>> boxes, the mlx5 card has 55 channels (aka queues), so when the test program
> >>> binds only to channel 0, nothing works as expected, since not all traffic
> >>> is being intercepted.  While obvious in hindsight, this took a while to
> >>> track down.
> >>
> >> Yes, agreed. You are not the first one to stumble upon this problem
> >> :-). Let me think a little bit on how to solve this in a good way. We
> >> need this to be simple and intuitive, as you say.
> >
> > I see people hitting this with AF_XDP all the time... I had some
> > backup-slides[2] in our FOSDEM presentation[1] that describe the issue,
> > give the performance reason why and propose a workaround.
>
> Magnus, I presume you're going to address this for the initial libbpf merge
> since the plan is to make it easier to consume for users?

I think the first thing we need is education and documentation. Have a
FAQ or "common mistakes" section in the Documentation. And of course,
sending Jesper around the world reminding people about this ;-).

To address this on a libbpf interface level, I think the best way is
to reprogram the NIC to send all traffic to the queue that you
provided in the xsk_socket__create call. This "set up NIC routing"
behavior can then be disable with a flag, just as the XDP program
loading can be disabled. The standard config of xsk_socket__create
will then set up as many things for the user as possible just to get
up and running quickly. More advanced users can then disable parts of
it to gain more flexibility. Does this sound OK? Do not want to go the
route of polling multiple sockets and aggregating the traffic as this
will have significant negative performance implications.

/Magnus

> Few more minor items in individual patches, will reply there.
>
> Thanks,
> Daniel
>
> > [1] https://github.com/xdp-project/xdp-project/tree/master/conference/FOSDEM2019
> > [2] https://github.com/xdp-project/xdp-project/blob/master/conference/FOSDEM2019/xdp_building_block.org#backup-slides
> >
> > Alternative work-around
> >   * Create as many AF_XDP sockets as RXQs
> >   * Have userspace poll()/select on all sockets
> >
>
