Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qk1-f193.google.com ([209.85.222.193]:44950 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727444AbfIZQnv (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 26 Sep 2019 12:43:51 -0400
Received: by mail-qk1-f193.google.com with SMTP id u22so2321785qkk.11
        for <xdp-newbies@vger.kernel.org>; Thu, 26 Sep 2019 09:43:50 -0700 (PDT)
MIME-Version: 1.0
References: <7de437b13561433fa766aca690995c45@pantheon.tech>
In-Reply-To: <7de437b13561433fa766aca690995c45@pantheon.tech>
From: William Tu <u9012063@gmail.com>
Date: Thu, 26 Sep 2019 09:43:12 -0700
Message-ID: <CALDO+SZWdVNCBimVdBivJMYDw+9jCycU3jcVBL+zBJwpMvb8=Q@mail.gmail.com>
Subject: Re: bug in AF_XDP socket cleanup?
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: =?UTF-8?Q?J=C3=BAlius_Milan?= <Julius.Milan@pantheon.tech>
Cc: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, Magnus Karlsson <magnus.karlsson@gmail.com>, Jesper Dangaard Brouer <brouer@redhat.com>

On Wed, Sep 25, 2019 at 8:47 AM J=C3=BAlius Milan <Julius.Milan@pantheon.te=
ch> wrote:
>
> Hi folks
>
>
>
> I am stuck with proper cleanup of AF_XDP socket. Not sure if I am doing s=
omething wrong or is it a bug.
>
> I create xdp socket, then I remove it and then I am trying to create it a=
gain and got EBUSY from bind syscall
>
> of xsk_socket__create.
>
>
>
> My cleanup looks like this:
>
> xsk_socket__delete();
>
> xsk_umem__delete();
>
> bpf_set_link_xdp_fd(ifindex, -1, opt_xdp_flags);
>
>
>
> Attaching simple test case. It=E2=80=99s just reduced and modified xdpsoc=
k_user.c form kernel samples.
>
> Tested on kernel v5.3 4d856f72c10ecb060868ed10ff1b1453943fc6c8 and relate=
d libbpf.

There are a couple of fixes related to cleanup.
Can you make sure your kernel has these patches

commit 0402acd683c678874df6bdbc23530ca07ea19353
Author: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
Date:   Thu Aug 15 11:30:13 2019 +0200

    xsk: remove AF_XDP socket from map when the socket is released

And libbpf has
commit 5750902a6e9bc6adb77da8257c0e34db2bfdebb2
Author: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
Date:   Tue Apr 30 14:45:36 2019 +0200

    libbpf: proper XSKMAP cleanup

commit 0e6741f092979535d159d5a851f12c88bfb7cb9a
Author: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
Date:   Tue Apr 30 14:45:35 2019 +0200

    libbpf: fix invalid munmap call


Thanks
William
