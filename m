Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:21474 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727308AbgBDRU7 (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 4 Feb 2020 12:20:59 -0500
Subject: Re: Cannot run multiple 'xdpsock' concurrently?
References: <CAMyc9bVixUDEJ-WHLJaCCTF3iV4pFF2j+RPM0hM1XOKh6S2yBw@mail.gmail.com>
 <CAJ8uoz0btU4L80d2DHv+=ivL3RJmunnAsmetL=2zBo_2xfpgAA@mail.gmail.com>
 <20200203031104.GA19512@ranger.igk.intel.com>
 <afcf4030-aee3-7e9c-a57f-c5458c285b74@mellanox.com>
 <20200204065000.GA44903@ranger.igk.intel.com>
 <CAJ+HfNj0+o3A9TM+K=Eiqrj_wwSOsnPw2f00u_P-sX_-ckp5=g@mail.gmail.com>
 <20200204094640.GA46254@ranger.igk.intel.com>
From: =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <c92afb6b-28a3-3ec5-f358-b434d73617c4@intel.com>
Date: Tue, 4 Feb 2020 18:20:48 +0100
MIME-Version: 1.0
In-Reply-To: <20200204094640.GA46254@ranger.igk.intel.com>
Content-Language: en-US
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=utf-8;
        format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Maciej Fijalkowski <maciej.fijalkowski@intel.com>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc: Maxim Mikityanskiy <maximmi@mellanox.com>, Magnus Karlsson <magnus.karlsson@gmail.com>, Cameron Elliott <cameron@cameronelliott.com>, Xdp <xdp-newbies@vger.kernel.org>



On 2020-02-04 10:46, Maciej Fijalkowski wrote:
> On Tue, Feb 04, 2020 at 04:41:31PM +0100, Bj=C3=B6rn T=C3=B6pel wrote:
[...]
>=20
> So to summarize that:
> - return EAGAIN instead of ENETDOWN within ndo_xsk_wakeup implementations
>    in i40e/ixgbe,
> - check for ENETDOWN in kick_tx() as well
>=20
> Do you guys agree?
>

Well, start with latter. From some perspective, changing the return=20
value is ABI breakage, no?

> What about timeout and syscall repetition? That's the last question.
>

Hmm, timeout in what context? When to redo the syscall?
