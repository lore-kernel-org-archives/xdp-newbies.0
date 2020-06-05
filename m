Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from postout1.mail.lrz.de ([129.187.255.137]:42467 "EHLO
        postout1.mail.lrz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbgFEMFc (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Fri, 5 Jun 2020 08:05:32 -0400
From: "Gaul, Maximilian" <maximilian.gaul@hm.edu>
Subject: AW: Intel X520 looses ethtool flow-type rule the moment a BPF / XDP
 program is loaded
Date: Fri, 5 Jun 2020 12:05:29 +0000
Message-ID: <0d6aad4ae9f9484cb158845d73c37f5d@hm.edu>
References: <a5741e0f3b90422f8c53a8bd54f06d8a@hm.edu>,<CAJ8uoz3V1F4MB9yprixAReFqPCW9bE4SbV58Gs-D7qdSXtz6sg@mail.gmail.com>
In-Reply-To: <CAJ8uoz3V1F4MB9yprixAReFqPCW9bE4SbV58Gs-D7qdSXtz6sg@mail.gmail.com>
Content-Language: de-DE
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Magnus Karlsson <magnus.karlsson@gmail.com>
Cc: Xdp <xdp-newbies@vger.kernel.org>

> Max,
>=20
> This is unfortunately a known issue with this older NIC. The newer
> Intel NICs such as i40e (Fortville) and ice (Columbiaville) work as
> you would expect. They do remember filter settings after enabling XDP.
>=20
> /Magnus
>=20

Thank you for your reply Magnus.

That is unfortunate but looks like I am not able to change anything about i=
t.

Do you know if there are other problems with AF_XDP and that NIC?

For example, I am adding a multicast address membership to a generic Linux =
socket and then loading a BPF / XDP program.

After loading the BPF program I no longer receive any packets (tcpdump -i e=
th5).

Thank you

Max
