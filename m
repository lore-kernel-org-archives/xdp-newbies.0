Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726381AbgGTOqn (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 20 Jul 2020 10:46:43 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 149F2C061794
        for <xdp-newbies@vger.kernel.org>; Mon, 20 Jul 2020 07:46:43 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id q74so17896402iod.1
        for <xdp-newbies@vger.kernel.org>; Mon, 20 Jul 2020 07:46:43 -0700 (PDT)
MIME-Version: 1.0
References: <CAH57y_Rxm9_eB5jyjJ2OryLd6HB6mXSG8s-MR3BWs-99PVNG0g@mail.gmail.com>
 <6de242a4-263a-bbde-7af4-68532904e4b3@solarflare.com>
In-Reply-To: <6de242a4-263a-bbde-7af4-68532904e4b3@solarflare.com>
From: Alexander Petrovsky <askjuise@gmail.com>
Date: Mon, 20 Jul 2020 17:47:23 +0300
Message-ID: <CAH57y_T9_K0L_cGjBQ+2C9UuRtw28Nqjk1FUB+F+3=WJVVZaqg@mail.gmail.com>
Subject: Re: IP fragmentation
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Edward Cree <ecree@solarflare.com>
Cc: xdp-newbies@vger.kernel.org

=D0=BF=D0=BD, 20 =D0=B8=D1=8E=D0=BB. 2020 =D0=B3. =D0=B2 15:17, Edward Cree=
 <ecree@solarflare.com>:
>
> On 20/07/2020 09:15, Alexander Petrovsky wrote:
> > But, the main problem for us it's fragmented IP packets. Some times
> > ago I tried to use for such packets AF_XDP, fast pass them into the
> > user space, accumulate and after that pass back to the network, it was
> > a PoC.
> Not 100% sure this works because I haven't tried it, but as long as
>  packets aren't being re-ordered, you can do it without needing to
>  save the payload in a map.
> All the map needs to store is (for each IPID being tracked) what host
>  this connection goes to.
> If you receive a First Fragment (frag_off=3D0, MF=3D1), you look up the
>  tuple through the regular LB to pick a server, and record that host
>  in the map entry for the IPID.
> For any other fragment, you look up the IPID in the map to get the
>  destination host, and if MF=3D0 you delete the map entry.
>  (If the IPID wasn't found, either drop or punt to userspace.)
> Then TX/REDIRECT the packet to the appropriate host.
> You might want to add some kind of simple ageing to this so that map
>  entries from interrupted/spurious fragment chains don't stick around
>  and build up over time.
>
> The problem comes when 'middle' fragments can either come after the
>  last (MF=3D0) fragment (technically this can be handled by tracking
>  the byte range seen for the IPID, and not deleting from the map
>  until all bytes up to the frag_off+total_len of the last-frag have
>  been seen), or worse, before the first fragment.  If the frag_off=3D0
>  fragment isn't the first one received, then this doesn't work
>  because you don't know at the time of receiving fragments what L4
>  ports they belong to.  But I don't know how common that situation is
>  and whether having it take the slow-path is acceptable.
>
> HTH,
> -ed

Unfortunately, for UDP I can't pick some _random_ host in case the
first _seen_ fragment it's not a First Fragment (frag_off=3D0, MF=3D1). In
this case, I have to accumulate ALL fragments in map. And on each
received fragment check, is all fragments are collected. I did it in
my PoC with AF_XDP, but in PoC all seems unreliable.

--=20
Alexander Petrovsky
