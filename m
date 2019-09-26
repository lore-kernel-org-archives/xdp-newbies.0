Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qk1-f176.google.com ([209.85.222.176]:42384 "EHLO
        mail-qk1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726029AbfIZQrO (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 26 Sep 2019 12:47:14 -0400
Received: by mail-qk1-f176.google.com with SMTP id f16so2336674qkl.9
        for <xdp-newbies@vger.kernel.org>; Thu, 26 Sep 2019 09:47:14 -0700 (PDT)
MIME-Version: 1.0
References: <8292781f95b84d97a5e40684a4202175@pantheon.tech>
In-Reply-To: <8292781f95b84d97a5e40684a4202175@pantheon.tech>
From: William Tu <u9012063@gmail.com>
Date: Thu, 26 Sep 2019 09:46:36 -0700
Message-ID: <CALDO+SbOaGzFJ9oEH10N6Q=nvvNpkF_RykgRZwrC55GmOpxj3g@mail.gmail.com>
Subject: Re: bug? or how to properly clean up AF_XDP socket
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: =?UTF-8?Q?J=C3=BAlius_Milan?= <Julius.Milan@pantheon.tech>
Cc: Magnus Karlsson <magnus.karlsson@gmail.com>, Jesper Dangaard Brouer <brouer@redhat.com>, =?UTF-8?B?TWFyZWsgWsOhdm9kc2vDvQ==?= <marek.zavodsky@pantheon.tech>, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, Thomas F Herbert <therbert@redhat.com>

On Thu, Sep 26, 2019 at 12:05 AM J=C3=BAlius Milan
<Julius.Milan@pantheon.tech> wrote:
>
> Hi folks
>
> I am stuck with proper cleanup of AF_XDP socket. Not sure if I am doing s=
omething wrong or is it a bug.
> I create xdp socket, then I remove it and then I am trying to create it a=
gain in the same process but getting -EBUSY from bind syscall
> of xsk_socket__create.
>
> My cleanup looks like this:
> xsk_socket__delete();
> xsk_umem__delete();
> bpf_set_link_xdp_fd(ifindex, -1, opt_xdp_flags);

Hi Julius,

I think that's all you need.

>
> Attaching simple test case. It=E2=80=99s just reduced and slightly modifi=
ed xdpsock_user.c form kernel samples.
> Tested on kernel v5.3 4d856f72c10ecb060868ed10ff1b1453943fc6c8 and relate=
d libbpf.

I comment in another email, let me know if you do not see it.

William
>
> Thanks a lot
> Julius
>
