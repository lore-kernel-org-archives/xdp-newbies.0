Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:53855 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725990AbfHKLdH (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Sun, 11 Aug 2019 07:33:07 -0400
Date: Sun, 11 Aug 2019 13:32:25 +0200
From: Jonathan =?utf-8?Q?Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
Subject: Re: [PATCH] Documentation/networking/af_xdp: Inhibit reference to
 struct socket
Message-ID: <20190811113225.GD1966@latitude>
References: <20190810121738.19587-1-j.neuschaefer@gmx.net>
 <20190810085821.11cee8b0@lwn.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="3Pql8miugIZX0722"
Content-Disposition: inline
In-Reply-To: <20190810085821.11cee8b0@lwn.net>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Jonathan =?utf-8?Q?Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>, linux-doc@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, netdev@vger.kernel.org, xdp-newbies@vger.kernel.org, bpf@vger.kernel.org, linux-kernel@vger.kernel.org


--3Pql8miugIZX0722
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 10, 2019 at 08:58:21AM -0600, Jonathan Corbet wrote:
> On Sat, 10 Aug 2019 14:17:37 +0200
> Jonathan Neusch=C3=A4fer <j.neuschaefer@gmx.net> wrote:
>=20
> > With the recent change to auto-detect function names, Sphinx parses
> > socket() as a reference to the in-kernel definition of socket. It then
> > decides that struct socket is a good match, which was obviously not
> > intended in this case, because the text speaks about the syscall with
> > the same name.
> >=20
> > Prevent socket() from being misinterpreted by wrapping it in ``inline
> > literal`` quotes.
> >=20
> > Signed-off-by: Jonathan Neusch=C3=A4fer <j.neuschaefer@gmx.net>
>=20
> Thanks for looking at that.  The better fix, though, would be to add
> socket() to the Skipfuncs array in Documentation/sphinx/automarkup.py.
> Then it will do the right thing everywhere without the need to add markup
> to the RST files.

Alright, I'll do that for v2.


Thanks,
Jonathan Neusch=C3=A4fer

--3Pql8miugIZX0722
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEvHAHGBBjQPVy+qvDCDBEmo7zX9sFAl1P/IAACgkQCDBEmo7z
X9sBYw//WDx7jJODlKacEnlPkuHTxAkanqNDkGnT1Ghh6pIMjM4kqaZSusMiTy77
BCcw1O+iDfYLGZgBVuEeOZzaQtmKPGiaYvaOCGlEse5I/FR51qxXJmH6joU7ernN
SktIdNBlV7GnisrZHoXvxVeBmnCtLUDX0mIdqstioLlkGNnu1zEduNhM+p/KkBzj
iSxlNeQ/NEETCj2e4UHpLpYynix8j17T7X7uG/uO4b8gzoMBRe1bSOfKp45+AOoN
0LwjbcS3rnsFqaYiP/7dJ8LaQUYCSWfUd4+f7yKgrvzA2cH3ObjYbDd8XeKHRm/R
Gndzkxqm3SzxaUfAo8xYBqzD9tl/lfVVDYz0LUl1S+zMWAVK9v6rLXvdX7Ab7YRX
dY3gRKCPYvL0jzyrLFHOZTBIlHqSHV9X/kECgVCS2ahOMIDx3ll8scb/Pw2XkM06
bKQ/M/4SEaW4kxbhIj3H8y3lzngY46I5kFW/R64vhiH5KITQvqNd31V5ZUNzkdAT
2+pQP1tBasxhur956ITqgW74t3KhwnqSTv8c7VS+VtmJQrB2QvXzaWT9RrodcrTo
Tm5mWmfVBy8d0xfUu6RFNZN7SuQ2aUwb5WxDmzvNrB7FGD3vFpd42SJN2ub3qSDZ
OeHDnYBFmcvbsYAi7JUi+Wg7yZzZoCeKsbKdgQdyxQG2UHYFpyg=
=rjZu
-----END PGP SIGNATURE-----

--3Pql8miugIZX0722--
