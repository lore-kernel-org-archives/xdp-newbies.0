Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-c.ads.isi.edu ([128.9.180.198]:50716 "EHLO
        mail-c.ads.isi.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726642AbgATSdN (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 20 Jan 2020 13:33:13 -0500
Date: Mon, 20 Jan 2020 13:33:09 -0500
From: Ryan Goodfellow <rgoodfel@isi.edu>
Subject: Re: zero-copy between interfaces
Message-ID: <20200120183309.GA10990@smtp.ads.isi.edu>
References: <14f9e1bf5c3a41dbaec53f83cb5f0564@isi.edu>
 <CAJ+HfNhdPEe34DVUAj4eHxLkBUSTo2CXbLHoWu+dwFCp753oMg@mail.gmail.com>
 <20200117171637.GB69024@smtp.ads.isi.edu>
 <CAJ8uoz0i2NVxBty18Cq=kK5_Ysue=pt1psBBahLFiZqN168OiQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAJ8uoz0i2NVxBty18Cq=kK5_Ysue=pt1psBBahLFiZqN168OiQ@mail.gmail.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
To: Magnus Karlsson <magnus.karlsson@gmail.com>
Cc: =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, "Karlsson, Magnus" <magnus.karlsson@intel.com>, intel-wired-lan <intel-wired-lan@lists.osuosl.org>, =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>

On Mon, Jan 20, 2020 at 09:24:05AM +0100, Magnus Karlsson wrote:
>=20
> I was wondering if you could run two small experiments since I cannot
> reproduce this?
>=20
> 1: Run your program using the two ports on your X710 card. Does it
> work? This is my setup and works for me.

The X710 card works without issue.

> 2: On your Mellanox setup, insert a kick_tx() call for each of your
> two sockets before the poll() call in your forward() function. Just to
> see if it works when we explicitly wake up the driver.

This did not have an effect on the observed behavior. Exactly N packets go
through the interface where N is equal to the size of the FQ/CQ rings and t=
hen
forwarding halts.

--
~ ry
