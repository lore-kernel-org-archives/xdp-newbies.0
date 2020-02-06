Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-ot1-f42.google.com ([209.85.210.42]:40757 "EHLO
        mail-ot1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbgBFHDH (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Thu, 6 Feb 2020 02:03:07 -0500
Received: by mail-ot1-f42.google.com with SMTP id i6so4516789otr.7
        for <xdp-newbies@vger.kernel.org>; Wed, 05 Feb 2020 23:03:06 -0800 (PST)
MIME-Version: 1.0
References: <CAMyc9bVixUDEJ-WHLJaCCTF3iV4pFF2j+RPM0hM1XOKh6S2yBw@mail.gmail.com>
 <CAJ8uoz0btU4L80d2DHv+=ivL3RJmunnAsmetL=2zBo_2xfpgAA@mail.gmail.com>
 <20200203031104.GA19512@ranger.igk.intel.com> <afcf4030-aee3-7e9c-a57f-c5458c285b74@mellanox.com>
 <20200204065000.GA44903@ranger.igk.intel.com> <CAJ+HfNj0+o3A9TM+K=Eiqrj_wwSOsnPw2f00u_P-sX_-ckp5=g@mail.gmail.com>
 <20200204094640.GA46254@ranger.igk.intel.com> <c92afb6b-28a3-3ec5-f358-b434d73617c4@intel.com>
In-Reply-To: <c92afb6b-28a3-3ec5-f358-b434d73617c4@intel.com>
From: Magnus Karlsson <magnus.karlsson@gmail.com>
Date: Thu, 6 Feb 2020 08:02:55 +0100
Message-ID: <CAJ8uoz2qLq_nN+gNT6da0cy6xf_evw=fHDkszxuVzP_n88tA_A@mail.gmail.com>
Subject: Re: Cannot run multiple 'xdpsock' concurrently?
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Cc: Maciej Fijalkowski <maciej.fijalkowski@intel.com>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>, Maxim Mikityanskiy <maximmi@mellanox.com>, Cameron Elliott <cameron@cameronelliott.com>, Xdp <xdp-newbies@vger.kernel.org>

On Tue, Feb 4, 2020 at 6:20 PM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com=
> wrote:
>
>
>
> On 2020-02-04 10:46, Maciej Fijalkowski wrote:
> > On Tue, Feb 04, 2020 at 04:41:31PM +0100, Bj=C3=B6rn T=C3=B6pel wrote:
> [...]
> >
> > So to summarize that:
> > - return EAGAIN instead of ENETDOWN within ndo_xsk_wakeup implementatio=
ns
> >    in i40e/ixgbe,
> > - check for ENETDOWN in kick_tx() as well
> >
> > Do you guys agree?
> >
>
> Well, start with latter. From some perspective, changing the return
> value is ABI breakage, no?
>
> > What about timeout and syscall repetition? That's the last question.
> >
>
> Hmm, timeout in what context? When to redo the syscall?

Cameron,

FYI: https://lore.kernel.org/netdev/20200205212147.GA5358@pc-9.home/T/#r715=
e0a78ae13c0fc1ce67b3219e9a532b2bfd011

/Magnus
