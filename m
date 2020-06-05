Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbgFEMP0 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Fri, 5 Jun 2020 08:15:26 -0400
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABC0AC08C5C2
        for <xdp-newbies@vger.kernel.org>; Fri,  5 Jun 2020 05:15:26 -0700 (PDT)
Received: by mail-vs1-xe2d.google.com with SMTP id k13so5446833vsm.13
        for <xdp-newbies@vger.kernel.org>; Fri, 05 Jun 2020 05:15:26 -0700 (PDT)
MIME-Version: 1.0
References: <a5741e0f3b90422f8c53a8bd54f06d8a@hm.edu> <CAJ8uoz3V1F4MB9yprixAReFqPCW9bE4SbV58Gs-D7qdSXtz6sg@mail.gmail.com>
 <0d6aad4ae9f9484cb158845d73c37f5d@hm.edu>
In-Reply-To: <0d6aad4ae9f9484cb158845d73c37f5d@hm.edu>
From: Magnus Karlsson <magnus.karlsson@gmail.com>
Date: Fri, 5 Jun 2020 14:15:14 +0200
Message-ID: <CAJ8uoz3d3u0MxVAFxpRjZzVTR41aHBu879FPFA0Z4uUL=6sQqg@mail.gmail.com>
Subject: Re: Intel X520 looses ethtool flow-type rule the moment a BPF / XDP
 program is loaded
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
To: "Gaul, Maximilian" <maximilian.gaul@hm.edu>, "Raczynski, Piotr" <piotr.raczynski@intel.com>, "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>, lihong.yang@intel.com
Cc: Xdp <xdp-newbies@vger.kernel.org>

On Fri, Jun 5, 2020 at 2:05 PM Gaul, Maximilian <maximilian.gaul@hm.edu> wrote:
>
> > Max,
> >
> > This is unfortunately a known issue with this older NIC. The newer
> > Intel NICs such as i40e (Fortville) and ice (Columbiaville) work as
> > you would expect. They do remember filter settings after enabling XDP.
> >
> > /Magnus
> >
>
> Thank you for your reply Magnus.
>
> That is unfortunate but looks like I am not able to change anything about it.
>
> Do you know if there are other problems with AF_XDP and that NIC?
>
> For example, I am adding a multicast address membership to a generic Linux socket and then loading a BPF / XDP program.
>
> After loading the BPF program I no longer receive any packets (tcpdump -i eth5).

I do not use this card in my AF_XDP lab setup, so unforuately I do not
know. I have included some persons from the networking division at
Intel. They might know of a "known issues" page or somewhere where you
can bug report this.

/Magnus

> Thank you
>
> Max
