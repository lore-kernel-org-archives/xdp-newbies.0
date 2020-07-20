Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:47170 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728532AbgGTMRs (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 20 Jul 2020 08:17:48 -0400
Subject: Re: IP fragmentation
References: <CAH57y_Rxm9_eB5jyjJ2OryLd6HB6mXSG8s-MR3BWs-99PVNG0g@mail.gmail.com>
From: Edward Cree <ecree@solarflare.com>
Message-ID: <6de242a4-263a-bbde-7af4-68532904e4b3@solarflare.com>
Date: Mon, 20 Jul 2020 13:17:40 +0100
MIME-Version: 1.0
In-Reply-To: <CAH57y_Rxm9_eB5jyjJ2OryLd6HB6mXSG8s-MR3BWs-99PVNG0g@mail.gmail.com>
Content-Language: en-GB
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Alexander Petrovsky <askjuise@gmail.com>, xdp-newbies@vger.kernel.org

On 20/07/2020 09:15, Alexander Petrovsky wrote:
> But, the main problem for us it's fragmented IP packets. Some times
> ago I tried to use for such packets AF_XDP, fast pass them into the
> user space, accumulate and after that pass back to the network, it was
> a PoC.
Not 100% sure this works because I haven't tried it, but as long as
=C2=A0packets aren't being re-ordered, you can do it without needing to
=C2=A0save the payload in a map.
All the map needs to store is (for each IPID being tracked) what host
=C2=A0this connection goes to.
If you receive a First Fragment (frag_off=3D0, MF=3D1), you look up the
=C2=A0tuple through the regular LB to pick a server, and record that host
=C2=A0in the map entry for the IPID.
For any other fragment, you look up the IPID in the map to get the
=C2=A0destination host, and if MF=3D0 you delete the map entry.
=C2=A0(If the IPID wasn't found, either drop or punt to userspace.)
Then TX/REDIRECT the packet to the appropriate host.
You might want to add some kind of simple ageing to this so that map
=C2=A0entries from interrupted/spurious fragment chains don't stick around
=C2=A0and build up over time.

The problem comes when 'middle' fragments can either come after the
=C2=A0last (MF=3D0) fragment (technically this can be handled by tracking
=C2=A0the byte range seen for the IPID, and not deleting from the map
=C2=A0until all bytes up to the frag_off+total_len of the last-frag have
=C2=A0been seen), or worse, before the first fragment.=C2=A0 If the frag_of=
f=3D0
=C2=A0fragment isn't the first one received, then this doesn't work
=C2=A0because you don't know at the time of receiving fragments what L4
=C2=A0ports they belong to.=C2=A0 But I don't know how common that situatio=
n is
=C2=A0and whether having it take the slow-path is acceptable.

HTH,
-ed
