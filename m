Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725955AbgENMRp (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 14 May 2020 08:17:45 -0400
Received: from mail-ua1-x92c.google.com (mail-ua1-x92c.google.com [IPv6:2607:f8b0:4864:20::92c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98FB7C061A0C
        for <xdp-newbies@vger.kernel.org>; Thu, 14 May 2020 05:17:45 -0700 (PDT)
Received: by mail-ua1-x92c.google.com with SMTP id r2so1037744uam.7
        for <xdp-newbies@vger.kernel.org>; Thu, 14 May 2020 05:17:45 -0700 (PDT)
MIME-Version: 1.0
References: <ca3de1dca95241dda545c032a42b0152@hm.edu>
In-Reply-To: <ca3de1dca95241dda545c032a42b0152@hm.edu>
From: Magnus Karlsson <magnus.karlsson@gmail.com>
Date: Thu, 14 May 2020 14:17:34 +0200
Message-ID: <CAJ8uoz3ggjCx+c3kVLV2k-vivWuoDs7QJexM1uTFyupdCJTOjw@mail.gmail.com>
Subject: Re: Under which circumstances does `xsk_ring_prod__reserve` return 0?
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: "Gaul, Maximilian" <maximilian.gaul@hm.edu>
Cc: Xdp <xdp-newbies@vger.kernel.org>

On Thu, May 14, 2020 at 2:05 PM Gaul, Maximilian <maximilian.gaul@hm.edu> w=
rote:
>
> Hello,
>
> I have this system which handles multiple multicast-streams at once where=
 the user can choose the amount of RX-Queues of the NIC he wants to utilize=
.
>
> I am testing the scenario where only one RX-Queue is used. Thus, shared u=
mem is used.
>
> At the time a user decides to receive the first multicast-stream, a progr=
am ("AF-XDP") is launched by another program ("handler") which handles the =
user inputs.
> This AF-XDP program receives information about a Linux System V message q=
ueue through command line arguments.
> The first thing the AF-XDP program does is to map a shared memory segment=
 and configuring a umem with it.
> After the program launched successfully, the handler sends a message to s=
aid queue telling the AF-XDP program to create a new XSK and place its file=
 descriptor into a certain index in the XDP map.
> The XSK runs in a separate thread checking every millisecond for packets =
and sending information about those packet addresses in umem to the handler=
-program.
>
> To this point, everything works fine. But as soon as the user decides to =
receive another multicast-stream on the same RX-Queue, `xsk_ring_prod__rese=
rve` suddenly starts to return 0 (e.g. it wasn't able to reserve any packet=
s) even if I call this function a hundred times.
> So of course to create another XSK, I have to call `xsk_socket__create` w=
hich also takes the umem as an argument.
> As this system is running in parallel I was wondering if this problem can=
 occur because suddenly another XSK is registered at the same time as the f=
irst XSK tries to register umem frames for its packets?

Do not fully understand your set up, but here are some initial
observations and questions. When you use the XDP_SHARED_UMEM mode you
will end up with one unique set of fill and completion rings tied to
the umem you are sharing, but one set of Rx and Tx (if you use the
latter) rings per socket. So you need to serialize accesses to the
fill and completion rings. Are you doing that? You also need an XDP
program to route your traffic between the two sockets. Do you have
that? So everything works up until you create the second socket?

/Magnus

> Best regards
>
> Max
