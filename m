Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:54804 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726642AbgATRET (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 20 Jan 2020 12:04:19 -0500
Subject: Re: zero-copy between interfaces
References: <14f9e1bf5c3a41dbaec53f83cb5f0564@isi.edu>
 <CAJ+HfNhdPEe34DVUAj4eHxLkBUSTo2CXbLHoWu+dwFCp753oMg@mail.gmail.com>
 <20200117171637.GB69024@smtp.ads.isi.edu>
From: =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <a0f645bc-82b6-5b14-4608-bfde991a6678@intel.com>
Date: Mon, 20 Jan 2020 18:04:15 +0100
MIME-Version: 1.0
In-Reply-To: <20200117171637.GB69024@smtp.ads.isi.edu>
Content-Language: en-US
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Ryan Goodfellow <rgoodfel@isi.edu>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, "Karlsson, Magnus" <magnus.karlsson@intel.com>, intel-wired-lan <intel-wired-lan@lists.osuosl.org>, Magnus Karlsson <magnus.karlsson@gmail.com>


On 2020-01-17 18:16, Ryan Goodfellow wrote:
[...]
>=20
> https://gitlab.com/mergetb/tech/network-emulation/kernel/snippets/1931080
>=20

Ryan, thanks a lot for the detailed report! Much appreciated!

Long story short, the i40e crash is that the drivers tries to allocate=20
256 queues, but the HW is short on queues. The drivers enters a broken=20
state, which triggers the crash.

I'll make sure we'll get a patch for this.


Bj=C3=B6rn
