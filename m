Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-oi1-f176.google.com ([209.85.167.176]:35505 "EHLO
        mail-oi1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731332AbfISHWX (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 19 Sep 2019 03:22:23 -0400
Received: by mail-oi1-f176.google.com with SMTP id x3so1904755oig.2
        for <xdp-newbies@vger.kernel.org>; Thu, 19 Sep 2019 00:22:22 -0700 (PDT)
MIME-Version: 1.0
References: <889477ed79c44e6a9395cf961f782209@pantheon.tech>
 <CA+_TK733RPSU=sEqSFpk-La6RNuJJM4m7xsDgOZ-EnaRAwKwKA@mail.gmail.com>
 <20190823102224.16141c87@carbon> <87d6d1ccab164292bb050c55f2cd81f8@pantheon.tech>
 <CALDO+SZRLUopFfiP7C2_Q3LRHDMLQ6_BBN=xw+BQ6FQWGFpVQw@mail.gmail.com>
 <c58d5612-052c-cab1-ad9a-0e0e1a838f5b@intel.com> <a6d5b3562fd148619c09ffbed54d84ea@pantheon.tech>
 <CALDO+SZsbbHL8ndhQiwb3EAEY22ucTYy5yy0xo_Ng3EzGisj1w@mail.gmail.com> <6a4ee5d2cc88403bafc749f7b855b597@pantheon.tech>
In-Reply-To: <6a4ee5d2cc88403bafc749f7b855b597@pantheon.tech>
From: Magnus Karlsson <magnus.karlsson@gmail.com>
Date: Thu, 19 Sep 2019 09:22:11 +0200
Message-ID: <CAJ8uoz23kBsAsmO4qGpx=0fK8_vqgXv4a-jJfy_qfSSnVsgauQ@mail.gmail.com>
Subject: Re: AF_XDP integration with FDio VPP? (Was: Questions about XDP)
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: =?UTF-8?Q?J=C3=BAlius_Milan?= <Julius.Milan@pantheon.tech>
Cc: William Tu <u9012063@gmail.com>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>, =?UTF-8?B?TWFyZWsgWsOhdm9kc2vDvQ==?= <marek.zavodsky@pantheon.tech>, Jesper Dangaard Brouer <brouer@redhat.com>, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, "Karlsson, Magnus" <magnus.karlsson@intel.com>, Eelco Chaudron <echaudro@redhat.com>, Thomas F Herbert <therbert@redhat.com>, Kevin Laatz <kevin.laatz@intel.com>

On Wed, Sep 18, 2019 at 8:14 PM J=C3=BAlius Milan <Julius.Milan@pantheon.te=
ch> wrote:
>
> Hi
>
> > On Fri, Aug 30, 2019 at 9:37 AM J=C3=BAlius Milan <Julius.Milan@pantheo=
n.tech> wrote:
> >>
> >> Hi all
> >>
> >> Regarding 4K frame size constraint of AF_XDP, what does AF_XDP when re=
ceives frame bigger than 4K? Drops it or cut it or split it between more fr=
ames?
> >> Thinking about what to do with them on TX side.
> >>
> >> If you are interested in mentioned AF_XDP driver for vpp, here you can
> >> find it: https://gerrit.fd.io/r/c/vpp/+/21606
> >
> > Hi J=C3=BAlius,
> >
> > I took a look at the patch, I can passed compile but I haven't run it.
> > In the src/plugins/af_xdp/device.c and src/plugins/af_xdp/xsk_defs.h, s=
ince you already link libbpf, you can remove a lot of existing code by usin=
g AF_XDP APIs in libbpf (see xsk_ring_*, xsk_umem_*)
> >
> > If you want to load your custom XDP program, you can enable XSK_LIBBPF_=
FLAGS__INHIBIT_PROG_LOAD and load XDP program
>
> Thank you William, I updated it, but its still work in progress, I inspir=
ed by OVS implementation as well.
>
> >
> > Regards,
> > William
>
> I have next 2 questions:
>
> 1] When I use xsk_ring_prod__reserve and successive xsk_ring_prod__submit=
. Is it correct to submit also less than I reserved?
>     In some cases I can't exactly determine how much to reserve in advanc=
e, since vpp buffers have different size than xdp frames.

Let me see so I understand this correctly. Ponder you reserve 10 slots
and later submit 4. This means you have reserved 6 more than you need.
Do you want to "unreserve" these and give them back to the ring? This
is not supported by the interface today. Another way of solving this
(if this is your problem and I am understanding it correctly, that is)
is that you in the next iteration only reserve 10 - 6 =3D 4 slots
because you already have 6 slots available from the last iteration.
You could still submit 10 after this. But adding something like an
unreserve option would be easy as long as we made sure it only
affected local ring state. The global state seen in the shared
variables between user space and kernel would not be touched, as this
would affect performance negatively. Please let me know what you
think.

> 2] Can I use hugepage backed memory for umem? If not, is it planned for f=
uture?
>     Yet it does copy pakets from rx rings to vpp buffers, but speculating=
 about straight zerocopy way.

Yes you can use huge pages today, but the internal AF_XDP code has not
been optimized to use huge pages, so you will not get the full benefit
from them today. Kevin Laatz, added to this mail, is working on
optimizing the AF_XDP code for huge pages. If you want to know more or
have some requirements, do not hesitate to contact him.

/Magnus

> Many thanks
> J=C3=BAlius
