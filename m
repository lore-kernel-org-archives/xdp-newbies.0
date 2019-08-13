Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-ot1-f68.google.com ([209.85.210.68]:37229 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725899AbfHMGpp (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 13 Aug 2019 02:45:45 -0400
Received: by mail-ot1-f68.google.com with SMTP id f17so33182488otq.4
        for <xdp-newbies@vger.kernel.org>; Mon, 12 Aug 2019 23:45:44 -0700 (PDT)
MIME-Version: 1.0
References: <CAEaYocZ3awg1aW=7Z7Ut_G64Ov9ZdyOAeYWNMdTBTf7scJM6EQ@mail.gmail.com>
 <CAH3MdRXcFtxi1mPq2KXUbDLhzHLtm3W=e6XTpFvsgFKH8hjogA@mail.gmail.com>
In-Reply-To: <CAH3MdRXcFtxi1mPq2KXUbDLhzHLtm3W=e6XTpFvsgFKH8hjogA@mail.gmail.com>
From: Magnus Karlsson <magnus.karlsson@gmail.com>
Date: Tue, 13 Aug 2019 08:45:33 +0200
Message-ID: <CAJ8uoz1+8s3x28jVfLey=qaYa6KdyKN5WgRtBnPckV=bHN0uHw@mail.gmail.com>
Subject: Re: libbpf expected backward compatibility
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Y Song <ys114321@gmail.com>
Cc: Rafael Vargas <vargas@khomp.com>, Xdp <xdp-newbies@vger.kernel.org>

On Mon, Aug 12, 2019 at 10:52 PM Y Song <ys114321@gmail.com> wrote:
>
> On Mon, Aug 12, 2019 at 11:13 AM Rafael Vargas <vargas@khomp.com> wrote:
> >
> > Hi,
> > Reading the tools/lib/bpf/README.rst file, I could find what should be
> > the expected backward compatibility of the library with older kernels.
>
> Now, libbpf tries to maintain backward compatibility with itself.
> That is, APIs introduced in older versions are expected to work
> in new versions.
>
> This has nothing to do with old or new kernels.
>
> >
> > Should I be able to use a libbpf compiled from a kernel newer than the
> > one I will be running or vice-versa?
>
> On the other hand, when libbpf is able to able to load a program or map,
> it tries to reload by resetting some debug/info fields. But depending on
> which API you are using, you may not be able to retry successfully
> on old kernels.
>
> >
> > I've noticed that the following diff (part of
> > 421ecf02c8e73e1d95e16e5e12aa19146561edba) makes the xsk_socket__create
> > function return errno 95 'Operation not supported' on older kernels
> > (5.1.0 in this particular case).
> >
> >
> > diff --git a/src/xsk.c b/src/xsk.c
> > index 7ef6293..bf15a80 100644
> > @@ -597,6 +599,16 @@ int xsk_socket__create(struct xsk_socket
> > **xsk_ptr, const char *ifname,
> >         }
> >
> >         xsk->prog_fd = -1;
> > +
> > +       optlen = sizeof(opts);
> > +       err = getsockopt(xsk->fd, SOL_XDP, XDP_OPTIONS, &opts, &optlen);
> > +       if (err) {
> > +               err = -errno;
> > +               goto out_mmap_tx;
> > +       }
> > +
> > +       xsk->zc = opts.flags & XDP_OPTIONS_ZEROCOPY;
> >
> > Should this really return Operation not supported or should it handle
> > this particular error and set the zc flag as false?
>
> maybe xdp expert can commit on this.
> From my understanding of the code, XDP_OPTIONS_ZEROCOPY
> does not involve any user parameters, so it is totally okay
> to test whether kernel has XDP_OPTIONS or not.
> If not, xdk->zc = 0. Also seems xdk->zc is not really used?

Thanks for spotting this. We should remove the zc field from the
struct as it is not used anymore. Not good to have dead code in there.
Who wants to produce a patch?

/Magnus

> >
> > --
> > Rafael Vargas
