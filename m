Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726165AbgDZSiQ (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Sun, 26 Apr 2020 14:38:16 -0400
Received: from mail-ua1-x92f.google.com (mail-ua1-x92f.google.com [IPv6:2607:f8b0:4864:20::92f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D6EEC061A0F
        for <xdp-newbies@vger.kernel.org>; Sun, 26 Apr 2020 11:38:16 -0700 (PDT)
Received: by mail-ua1-x92f.google.com with SMTP id s5so15116557uad.4
        for <xdp-newbies@vger.kernel.org>; Sun, 26 Apr 2020 11:38:16 -0700 (PDT)
MIME-Version: 1.0
References: <CAJEJvEW31-O9x-0WsipVqSf-kPy8HnWnB6gG2jeQTH5WWm2iqw@mail.gmail.com>
In-Reply-To: <CAJEJvEW31-O9x-0WsipVqSf-kPy8HnWnB6gG2jeQTH5WWm2iqw@mail.gmail.com>
From: Magnus Karlsson <magnus.karlsson@gmail.com>
Date: Sun, 26 Apr 2020 20:38:03 +0200
Message-ID: <CAJ8uoz0mcu=6_Czw-Y=v-MgRcCRxspkPfFJ4SaQamE-6jCwfkQ@mail.gmail.com>
Subject: Re: Error creating a AF_XDP socket after deleting
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
To: Jesse DuMond <suttonshiredev@gmail.com>
Cc: Xdp <xdp-newbies@vger.kernel.org>

On Sun, Apr 26, 2020 at 6:08 PM Jesse DuMond <suttonshiredev@gmail.com> wrote:
>
> Hi there,
>
> I am writing some test code that tries  repeatedly to create a umem
> and socket and then deletes them both. I'm using the libbpf function
> xsk_umem__create/delete and xsk_socket__create/xsk_socket__delete. I
> am getting an EBUSY from xsk_socket__create when trying to create a
> socket after deleting a socket on the same interface and queue number.
> The attached program reproduces the error.
>
> I've traced the EBUSY error to this call to xdp_umem_assign_dev in the
> kernel: https://github.com/torvalds/linux/blob/v5.3/net/xdp/xsk.c#L500
> That call is made during the bind call in xsk_socket__create. As far
> as I can tell this error is because the work of xdp_umem_clear_dev is
> actually called asynchronously after xsk_socket__delete. Putting a
> sleep between xsk_socket__delete and xsk_socket__create makes this
> code succeed.
>
> Am I trying to do something that is not supposed to be supported?

No, you are doing everything correctly. The tear down of a socket is
unfortunately asynchronous due to legacy reasons that are not true
anymore. We do have a item in the backlog to make this synchronous,
but have not gotten around to it yet. So sorry, we have to live with
this for a while more.

/Magnus
