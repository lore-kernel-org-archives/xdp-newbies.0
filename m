Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qk1-f176.google.com ([209.85.222.176]:41342 "EHLO
        mail-qk1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbfLFNux (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Fri, 6 Dec 2019 08:50:53 -0500
MIME-Version: 1.0
References: <CALDO+Sbd82Eqb27PezcUxTOhrD-YEsVw8cGW-abraZCLZ3fEAg@mail.gmail.com>
 <851ad28e-dc8b-da7c-66fa-ef88d684d7d2@intel.com>
In-Reply-To: <851ad28e-dc8b-da7c-66fa-ef88d684d7d2@intel.com>
From: William Tu <u9012063@gmail.com>
Date: Fri, 6 Dec 2019 05:50:14 -0800
Message-ID: <CALDO+SbciaNy5EReV5YHvciOSJmdMRPBQdF6XbhxfBF6gvPFDw@mail.gmail.com>
Subject: Re: Possible race condition on xsk_socket__create/xsk_bind
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Cc: Linux Kernel Network Developers <netdev@vger.kernel.org>, Xdp <xdp-newbies@vger.kernel.org>, "Karlsson, Magnus" <magnus.karlsson@intel.com>

On Thu, Dec 5, 2019 at 10:25 PM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.co=
m> wrote:
>
> On 2019-12-06 00:21, William Tu wrote:
> > Hi,
> >
> > While testing XSK using OVS, we hit an issue when create xsk,
> > destroy xsk, create xsk in a short time window.
> > The call to xsk_socket__create returns EBUSY due to
> >    xsk_bind
> >      xdp_umem_assign_dev
> >        xdp_get_umem_from_qid --> return EBUSY
> >
> > I found that when everything works, the sequence is
> >    <ovs creates xsk>
> >    xsk_bind
> >      xdp_umem_assign_dev
> >    <ovs destroy xsk> ...
> >    xsk_release
> >    xsk_destruct
> >      xdp_umem_release_deferred
> >        xdp_umem_release
> >          xdp_umem_clear_dev --> avoid the error above
> >
> > But sometimes xsk_destruct has not yet called, the
> > next call to xsk_bind shows up, ex:
> >
> >    <ovs creates xsk>
> >    xsk_bind
> >      xdp_umem_assign_dev
> >    <ovs destroy xsk> ...
> >    xsk_release
> >    xsk_bind
> >      xdp_umem_assign_dev
> >        xdp_get_umem_from_qid (failed!)
> >    ....
> >    xsk_destruct
> >
> > Is there a way to make sure the previous xsk is fully cleanup,
> > so we can safely call xsk_socket__create()?
> >
>
> Yes, the async cleanup is annoying. I *think* it can be done
> synchronous, since the map doesn't linger on a sockref anymore --
> 0402acd683c6 ("xsk: remove AF_XDP socket from map when the socket is
> released").
>
> So, it's not a race, it just asynch. :-(
>
Yes, thank you for quick response.
Now I can work around it by adding a sleep.
Look forward to your patch.

Thanks
William
