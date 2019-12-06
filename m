Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:35040 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726076AbfLFGZj (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 6 Dec 2019 01:25:39 -0500
Subject: Re: Possible race condition on xsk_socket__create/xsk_bind
References: <CALDO+Sbd82Eqb27PezcUxTOhrD-YEsVw8cGW-abraZCLZ3fEAg@mail.gmail.com>
From: =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <851ad28e-dc8b-da7c-66fa-ef88d684d7d2@intel.com>
Date: Fri, 6 Dec 2019 07:25:35 +0100
MIME-Version: 1.0
In-Reply-To: <CALDO+Sbd82Eqb27PezcUxTOhrD-YEsVw8cGW-abraZCLZ3fEAg@mail.gmail.com>
Content-Language: en-US
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: William Tu <u9012063@gmail.com>, Linux Kernel Network Developers <netdev@vger.kernel.org>, Xdp <xdp-newbies@vger.kernel.org>
Cc: "Karlsson, Magnus" <magnus.karlsson@intel.com>

On 2019-12-06 00:21, William Tu wrote:
> Hi,
>=20
> While testing XSK using OVS, we hit an issue when create xsk,
> destroy xsk, create xsk in a short time window.
> The call to xsk_socket__create returns EBUSY due to
>  =C2=A0 xsk_bind
>  =C2=A0 =C2=A0 xdp_umem_assign_dev
>  =C2=A0 =C2=A0 =C2=A0 xdp_get_umem_from_qid --> return EBUSY
>=20
> I found that when everything works, the sequence is
>  =C2=A0 <ovs creates xsk>
>  =C2=A0 xsk_bind
>  =C2=A0 =C2=A0 xdp_umem_assign_dev
>  =C2=A0 <ovs destroy xsk> ...
>  =C2=A0 xsk_release
>  =C2=A0 xsk_destruct
>  =C2=A0 =C2=A0 xdp_umem_release_deferred
>  =C2=A0 =C2=A0 =C2=A0 xdp_umem_release
>  =C2=A0 =C2=A0 =C2=A0 =C2=A0 xdp_umem_clear_dev --> avoid the error above
>=20
> But sometimes xsk_destruct has not yet called, the
> next call to xsk_bind shows up, ex:
>=20
>  =C2=A0 <ovs creates xsk>
>  =C2=A0 xsk_bind
>  =C2=A0 =C2=A0 xdp_umem_assign_dev
>  =C2=A0 <ovs destroy xsk> ...
>  =C2=A0 xsk_release
>  =C2=A0 xsk_bind
>  =C2=A0 =C2=A0 xdp_umem_assign_dev
>  =C2=A0 =C2=A0 =C2=A0 xdp_get_umem_from_qid (failed!)
>  =C2=A0 ....
>  =C2=A0 xsk_destruct
>=20
> Is there a way to make sure the previous xsk is fully cleanup,
> so we can safely call xsk_socket__create()?
>

Yes, the async cleanup is annoying. I *think* it can be done=20
synchronous, since the map doesn't linger on a sockref anymore --=20
0402acd683c6 ("xsk: remove AF_XDP socket from map when the socket is=20
released").

So, it's not a race, it just asynch. :-(

I'll take a stab at fixing this!


Cheers,
Bj=C3=B6rn


> The error is reproduced by OVS using:
> ovs-vsctl -- set interface afxdp-p0 options:n_rxq=3D1 type=3D"afxdp"=20
> options:xdp-mode=3Dnative
> ovs-vsctl -- set interface afxdp-p0 options:n_rxq=3D1 type=3D"afxdp"=20
> options:xdp-mode=3Dgeneric
> ovs-vsctl -- set interface afxdp-p0 options:n_rxq=3D1 type=3D"afxdp"=20
> options:xdp-mode=3Dnative
> This just keeps create and destroy xsk on the same device.
>=20
> Thanks
> William
