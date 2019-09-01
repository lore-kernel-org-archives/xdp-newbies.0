Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-wm1-f42.google.com ([209.85.128.42]:56287 "EHLO
        mail-wm1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728874AbfIAQrb (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Sun, 1 Sep 2019 12:47:31 -0400
Received: by mail-wm1-f42.google.com with SMTP id g207so8138893wmg.5
        for <xdp-newbies@vger.kernel.org>; Sun, 01 Sep 2019 09:47:29 -0700 (PDT)
MIME-Version: 1.0
References: <CAHApi-mMi2jYAOCrGhpkRVybz0sDpOSkLFCZfVe-2wOcAO_MqQ@mail.gmail.com>
In-Reply-To: <CAHApi-mMi2jYAOCrGhpkRVybz0sDpOSkLFCZfVe-2wOcAO_MqQ@mail.gmail.com>
From: Kal Cutter Conley <kal.conley@dectris.com>
Date: Sun, 1 Sep 2019 18:47:15 +0200
Message-ID: <CAHApi-=YSo=sOTkRxmY=fct3TePFFdG9oPTRHWYd1AXjk0ACfw@mail.gmail.com>
Subject: Re: net/mlx5e: bind() always returns EINVAL with XDP_ZEROCOPY
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org

Hi,
I figured out the problem. Let me document the issue here for others
and hopefully start a discussion.

The mlx5 driver uses special queue ids for ZC. If N is the number of
configured queues, then for XDP_ZEROCOPY the queue ids start at N. So
queue ids [0..N) can only be used with XDP_COPY and queue ids [N..2N)
can only be used with XDP_ZEROCOPY.

sudo ethtool -L eth0 combined 16
sudo samples/bpf/xdpsock -r -i eth0 -c -q 0   # OK
sudo samples/bpf/xdpsock -r -i eth0 -z -q 0   # ERROR
sudo samples/bpf/xdpsock -r -i eth0 -c -q 16  # ERROR
sudo samples/bpf/xdpsock -r -i eth0 -z -q 16  # OK

Why was this done? To use zerocopy if available and fallback on copy
mode normally you would set sxdp_flags=0. However, here this is no
longer possible. To support this driver, you have to first try binding
with XDP_ZEROCOPY and the special queue id, then if that fails, you
have to try binding again with a normal queue id. Peculiarities like
this complicate the XDP user api. Maybe someone can explain the
benefits?

Kal


On Wed, Aug 7, 2019 at 2:49 PM Kal Cutter Conley <kal.conley@dectris.com> wrote:
>
> Hello,
> I am testing the mlx5e driver with AF_XDP. When I specify
> XDP_ZEROCOPY, bind() always returns EINVAL. I observe the same problem
> with the xdpsock sample:
>
> sudo samples/bpf/xdpsock -r -i dcb1-port1 -z
> samples/bpf/xdpsock_user.c:xsk_configure_socket:322: errno:
> 22/"Invalid argument"
>
> Without XDP_ZEROCOPY, everything works as expected. Is this a known
> issue/limitation? I expected this to be supported looking at the
> code/commit history.
>
> Thanks,
> Kal
