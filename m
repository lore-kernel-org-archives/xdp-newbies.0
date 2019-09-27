Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-ot1-f53.google.com ([209.85.210.53]:44581 "EHLO
        mail-ot1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725808AbfI0GzN (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 27 Sep 2019 02:55:13 -0400
Received: by mail-ot1-f53.google.com with SMTP id 21so1343188otj.11
        for <xdp-newbies@vger.kernel.org>; Thu, 26 Sep 2019 23:55:13 -0700 (PDT)
MIME-Version: 1.0
References: <7de437b13561433fa766aca690995c45@pantheon.tech>
In-Reply-To: <7de437b13561433fa766aca690995c45@pantheon.tech>
From: Magnus Karlsson <magnus.karlsson@gmail.com>
Date: Fri, 27 Sep 2019 08:55:02 +0200
Message-ID: <CAJ8uoz1OL5_R12A4Np-aMmRM8a3qwQpXbuH3V+ZOiiRc6HYBwA@mail.gmail.com>
Subject: Re: bug in AF_XDP socket cleanup?
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: =?UTF-8?Q?J=C3=BAlius_Milan?= <Julius.Milan@pantheon.tech>
Cc: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, Jesper Dangaard Brouer <brouer@redhat.com>, William Tu <u9012063@gmail.com>

Hi J=C3=BAlius,

The ring clean up routines in i40e and ixgbe are asynchronous, so they
will likely not be ready when you return from the xsk_socket__delete()
call. What happens if you add a sleep(1) before you create it a second
time?

/Magnus

On Wed, Sep 25, 2019 at 5:47 PM J=C3=BAlius Milan <Julius.Milan@pantheon.te=
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
>
>
>
> Thanks a lot
>
> Julius
