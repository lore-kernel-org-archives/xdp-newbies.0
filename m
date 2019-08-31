Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:33832 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726251AbfHaIle (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Sat, 31 Aug 2019 04:41:34 -0400
Subject: Re: AF_XDP integration with FDio VPP? (Was: Questions about XDP)
References: <889477ed79c44e6a9395cf961f782209@pantheon.tech>
 <CA+_TK733RPSU=sEqSFpk-La6RNuJJM4m7xsDgOZ-EnaRAwKwKA@mail.gmail.com>
 <20190823102224.16141c87@carbon>
 <87d6d1ccab164292bb050c55f2cd81f8@pantheon.tech>
 <CALDO+SZRLUopFfiP7C2_Q3LRHDMLQ6_BBN=xw+BQ6FQWGFpVQw@mail.gmail.com>
 <c58d5612-052c-cab1-ad9a-0e0e1a838f5b@intel.com>
 <97f984e84a7049bc80cdf6438d1f5f4d@pantheon.tech>
 <CALDO+SbQeRjrPg5jFEOesEjtAVZSKv8CWipnHOE6FX5CgXBbOw@mail.gmail.com>
 <CAHOxX0xC42SOrP9133QEHw19E4j3_6bPpRzj5jsOzH7TGvaC2Q@mail.gmail.com>
From: =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <aa9edd29-1833-90d8-61fc-6b2d50b8e4e1@intel.com>
Date: Sat, 31 Aug 2019 10:41:29 +0200
MIME-Version: 1.0
In-Reply-To: <CAHOxX0xC42SOrP9133QEHw19E4j3_6bPpRzj5jsOzH7TGvaC2Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Pavel Popa <pashinho1990@gmail.com>, William Tu <u9012063@gmail.com>
Cc: =?UTF-8?Q?J=c3=balius_Milan?= <Julius.Milan@pantheon.tech>, =?UTF-8?Q?Marek_Z=c3=a1vodsk=c3=bd?= <marek.zavodsky@pantheon.tech>, Jesper Dangaard Brouer <brouer@redhat.com>, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, "Karlsson, Magnus" <magnus.karlsson@intel.com>, Eelco Chaudron <echaudro@redhat.com>, Thomas F Herbert <therbert@redhat.com>

On 2019-08-24 09:36, Pavel Popa wrote:
> I'd like to join the questions too, specifically more oriented towards
> AF_XDP devs.
> I understand why the choice of SPSC ring queue design, however what
> would be the cost of a MPSC design (Multiple Producer Single
> Consumer)? In order to have a single UMEM available to the entire net
> device (i.e. bound to all net device's hardware queues), imho this
> would have a huge impact because now, among other things, one wouldn't
> have to bother with ethtool. And do we really want to question the
> convenience of "UMEM per hardware queue" vs "UMEM per net device"?
> Btw, congrats for the great work guys.

Late on the ball...

A MPSC will definitely have a negative performance impact (let me see if
I can find some number from back when we started), but also open up
other issues like shared/multiple address spaces. We opted in for a
simple, performant model where filtering should be done in HW (zero-copy
mode).

What you're describing (SW based switching) might be a better fit for a
XDP + (say) tap with AF_XDP.

Most, if not all, users looking into AF_XDP do it for the zero-copy
performance, and going to the model you're describing will impact
performance too much.



Cheers,
Björn
