Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:47566 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726904AbgGUMdy (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 21 Jul 2020 08:33:54 -0400
Subject: Re: IP fragmentation
References: <CAH57y_Rxm9_eB5jyjJ2OryLd6HB6mXSG8s-MR3BWs-99PVNG0g@mail.gmail.com>
 <6de242a4-263a-bbde-7af4-68532904e4b3@solarflare.com>
 <CAH57y_T9_K0L_cGjBQ+2C9UuRtw28Nqjk1FUB+F+3=WJVVZaqg@mail.gmail.com>
From: Edward Cree <ecree@solarflare.com>
Message-ID: <8b809ac6-9e12-527c-d39e-0bab9dc743e2@solarflare.com>
Date: Tue, 21 Jul 2020 13:33:45 +0100
MIME-Version: 1.0
In-Reply-To: <CAH57y_T9_K0L_cGjBQ+2C9UuRtw28Nqjk1FUB+F+3=WJVVZaqg@mail.gmail.com>
Content-Language: en-GB
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: Alexander Petrovsky <askjuise@gmail.com>
Cc: xdp-newbies@vger.kernel.org

On 20/07/2020 15:47, Alexander Petrovsky wrote:
> Unfortunately, for UDP I can't pick some _random_ host in case the
> first _seen_ fragment it's not a First Fragment (frag_off=0, MF=1). In
> this case, I have to accumulate ALL fragments in map. And on each
> received fragment check, is all fragments are collected. I did it in
> my PoC with AF_XDP, but in PoC all seems unreliable.

That's why I say punt in that case (XDP_PASS and then have something
 else downstream of it to handle the slowpath.  However people did LB
 before XDP came along.  Idk, netfilter?  Does that have hooks post-
 reassembly?)
And probably when punting also record a map entry saying "we punted
 this IPID" so that when the First Frag shows up, the slowpath gets
 to see that one too and can do its reassembly.
So the map doesn't have to accumulate the fragments (the slowpath does
 that), just their offsets and lengths so XDP can tell when all frags
 have been passed to the slowpath and delete the map entry.

-ed
