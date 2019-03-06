Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qk1-f182.google.com ([209.85.222.182]:42290 "EHLO
        mail-qk1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728548AbfCFICV (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Wed, 6 Mar 2019 03:02:21 -0500
Received: by mail-qk1-f182.google.com with SMTP id y140so6284462qkb.9
        for <xdp-newbies@vger.kernel.org>; Wed, 06 Mar 2019 00:02:20 -0800 (PST)
MIME-Version: 1.0
References: <CAHApi-=wjBn54NkO5tn2Vb5vn0_YSUewrUMJ3yF1e+emJdwGvg@mail.gmail.com>
In-Reply-To: <CAHApi-=wjBn54NkO5tn2Vb5vn0_YSUewrUMJ3yF1e+emJdwGvg@mail.gmail.com>
From: =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date: Wed, 6 Mar 2019 09:02:08 +0100
Message-ID: <CAJ+HfNgU=Z68dMm6DHUP+sOkSJDxdy6-kW2AKCqwem++t3p_6Q@mail.gmail.com>
Subject: Re: XDP full jumbo frame support
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Kal Cutter Conley <kal.conley@dectris.com>
Cc: xdp-newbies@vger.kernel.org

On Wed, 27 Feb 2019 at 11:54, Kal Cutter Conley <kal.conley@dectris.com> wr=
ote:
>
> Hi,
> We would love to adopt AF_XDP with ZC (with i40e), however, we are a
> blocked by the lack of full jumbo frame support (8000-9000 bytes). I
> would like to get a feel for the feasibility of implementing support
> for this. Looking through the code it seems possible to support this
> through huge pages without a huge amount of effort (i may be wrong).
> The first thing that came to mind is something like:
> (1) Add a page_size (or similar) field to the xdp_umem struct.
> (2) During UMEM registration, check if the UMEM is only made up of
> huge pages, if so, save the huge page size into the umem page_size
> field instead of the default constant PAGE_SIZE value.
> (3) Use the umem page size (for dma mapping etc.) instead of the fixed
> standard PAGE_SIZE.
>
> Would this be a feasible solution? At least from the user (space)
> perspective, this seems like relatively straightforward change: when
> allocating the umem buffer, they only need to call mmap with the
> appropriate huge page flags if they want to receive packets >
> PAGE_SIZE.
>

Hi!

A lot of people has been asking for >4k chunk sizes to deal with jumbo
frames. Something in line with what you're suggesting is definitely
doable.

Somewhat related; we have some ideas of passing (huge)pages, instead
of chunks into the fill ring. This could be baked into the huge page
support as well.

OTOH a lot of people are also concerned about the internal
fragmentation with a chunk size of 2k, which is an opposing force to
the huge page support. :-)


Bj=C3=B6rn

> Thanks,
> Kal
