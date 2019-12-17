Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail.nic.cz ([217.31.204.67]:60130 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726560AbfLQO5c (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 17 Dec 2019 09:57:32 -0500
Received: from [IPv6:2001:1488:fffe:6:9595:ecab:ab88:6713] (unknown [IPv6:2001:1488:fffe:6:9595:ecab:ab88:6713])
        by mail.nic.cz (Postfix) with ESMTPSA id 6D8C9140A5B
        for <xdp-newbies@vger.kernel.org>; Tue, 17 Dec 2019 15:57:29 +0100 (CET)
From: =?UTF-8?B?VmxhZGltw61yIMSMdW7DoXQ=?= <vladimir.cunat@nic.cz>
Subject: AF_XDP headroom
Message-ID: <b36728e9-4cb8-4127-2127-2cbdcd9a0068@nic.cz>
Date: Tue, 17 Dec 2019 15:58:58 +0100
MIME-Version: 1.0
Content-Language: en-US
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To: xdp-newbies@vger.kernel.org

Hello.

I configured .frame_headroom =3D 0 (default) but I receive packets with
larger one (256).=C2=A0 Am I doing something wrong?=C2=A0 Kernel [docs] say=
s:

> There is also an option to set the headroom of each single buffer in
the UMEM. If you set this to N bytes, it means that the packet will
start N bytes into the buffer leaving the first N bytes for the
application to use.

which doesn't sound to leave an option for kernel-space to
change/increase it, but apparently it does so for me.=C2=A0 In my case it
wouldn't really be an issue, except it makes me unsure e.g. whether 2k
frames are guaranteed to handle standard 1.5k payloads.

[docs]
https://www.kernel.org/doc/html/latest/networking/af_xdp.html?highlight=3Dh=
eadroom

Thanks
--Vladimir
