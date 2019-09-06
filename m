Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qt1-f170.google.com ([209.85.160.170]:42013 "EHLO
        mail-qt1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387946AbfIFWvo (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Fri, 6 Sep 2019 18:51:44 -0400
Received: by mail-qt1-f170.google.com with SMTP id c9so9057125qth.9
        for <xdp-newbies@vger.kernel.org>; Fri, 06 Sep 2019 15:51:44 -0700 (PDT)
MIME-Version: 1.0
References: <889477ed79c44e6a9395cf961f782209@pantheon.tech>
 <CA+_TK733RPSU=sEqSFpk-La6RNuJJM4m7xsDgOZ-EnaRAwKwKA@mail.gmail.com>
 <20190823102224.16141c87@carbon> <87d6d1ccab164292bb050c55f2cd81f8@pantheon.tech>
 <CALDO+SZRLUopFfiP7C2_Q3LRHDMLQ6_BBN=xw+BQ6FQWGFpVQw@mail.gmail.com>
 <c58d5612-052c-cab1-ad9a-0e0e1a838f5b@intel.com> <a6d5b3562fd148619c09ffbed54d84ea@pantheon.tech>
In-Reply-To: <a6d5b3562fd148619c09ffbed54d84ea@pantheon.tech>
From: William Tu <u9012063@gmail.com>
Date: Fri, 6 Sep 2019 15:51:07 -0700
Message-ID: <CALDO+SZsbbHL8ndhQiwb3EAEY22ucTYy5yy0xo_Ng3EzGisj1w@mail.gmail.com>
Subject: Re: AF_XDP integration with FDio VPP? (Was: Questions about XDP)
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: =?UTF-8?Q?J=C3=BAlius_Milan?= <Julius.Milan@pantheon.tech>
Cc: =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>, =?UTF-8?B?TWFyZWsgWsOhdm9kc2vDvQ==?= <marek.zavodsky@pantheon.tech>, Jesper Dangaard Brouer <brouer@redhat.com>, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, "Karlsson, Magnus" <magnus.karlsson@intel.com>, Eelco Chaudron <echaudro@redhat.com>, Thomas F Herbert <therbert@redhat.com>

On Fri, Aug 30, 2019 at 9:37 AM J=C3=BAlius Milan <Julius.Milan@pantheon.te=
ch> wrote:
>
> Hi all
>
> Regarding 4K frame size constraint of AF_XDP, what does AF_XDP when recei=
ves frame bigger than 4K? Drops it or cut it or split it between more frame=
s?
> Thinking about what to do with them on TX side.
>
> If you are interested in mentioned AF_XDP driver for vpp, here you can fi=
nd it: https://gerrit.fd.io/r/c/vpp/+/21606

Hi J=C3=BAlius,

I took a look at the patch, I can passed compile but I haven't run it.
In the src/plugins/af_xdp/device.c and src/plugins/af_xdp/xsk_defs.h,
since you already link libbpf, you can remove a lot of existing code by
using AF_XDP APIs in libbpf (see xsk_ring_*, xsk_umem_*)

If you want to load your custom XDP program, you can enable
XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD and load XDP program

Regards,
William
