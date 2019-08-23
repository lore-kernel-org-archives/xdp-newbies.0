Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:52435 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726319AbfHWNgN (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 23 Aug 2019 09:36:13 -0400
Subject: Re: AF_XDP integration with FDio VPP? (Was: Questions about XDP)
References: <889477ed79c44e6a9395cf961f782209@pantheon.tech>
 <CA+_TK733RPSU=sEqSFpk-La6RNuJJM4m7xsDgOZ-EnaRAwKwKA@mail.gmail.com>
 <20190823102224.16141c87@carbon>
 <CALDO+SZeLFXyLct2NNME_FmtgsUmuOAjB9q1n3jZ6dDHvAiWCw@mail.gmail.com>
From: =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <a3609695-8a27-d636-f8eb-45ff9c861992@intel.com>
Date: Fri, 23 Aug 2019 15:36:08 +0200
MIME-Version: 1.0
In-Reply-To: <CALDO+SZeLFXyLct2NNME_FmtgsUmuOAjB9q1n3jZ6dDHvAiWCw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: William Tu <u9012063@gmail.com>, =?UTF-8?Q?Marek_Z=c3=a1vodsk=c3=bd?= <marek.zavodsky@pantheon.tech>
Cc: =?UTF-8?Q?J=c3=balius_Milan?= <Julius.Milan@pantheon.tech>, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, "Karlsson, Magnus" <magnus.karlsson@intel.com>, Eelco Chaudron <echaudro@redhat.com>, Thomas F Herbert <therbert@redhat.com>, Jesper Dangaard Brouer <brouer@redhat.com>

On 2019-08-23 15:15, William Tu wrote:
> But isn't most of the VPP deployment use DPDK as back-ends?
> If that's the case, why not use DPDK's AF_XDP implementation?

I'd say the other way around, but I might be wrong. (In fact, VPP comes
with their own userspace drivers as well.)

VPP and DPDK has many overlapping components (mempools, drivers), and 
AFAIK (last time I checked) VPP pretty much only used the PMDs from DPDK.

So, from my perspective, a standalone AF_XDP implementation makes much
sense!


Cheers,
Björn
