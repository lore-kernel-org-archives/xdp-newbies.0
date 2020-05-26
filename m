Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-db8eur05on2068.outbound.protection.outlook.com ([40.107.20.68]:30049
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731341AbgEZHAd (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 26 May 2020 03:00:33 -0400
From: Denis Salopek <Denis.Salopek@fer.hr>
Subject: XDP_REDIRECT forwarding speed
Date: Tue, 26 May 2020 07:00:30 +0000
Message-ID: <AM0PR08MB3345DF6A3FABBCF262B39E968BB00@AM0PR08MB3345.eurprd08.prod.outlook.com>
Content-Language: en-US
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>

Hi!=0A=0AI want to make sure I did everything right to make my XDP program=
=0A(simple forwarding with bpf_redirect_map) as fast as possible. Is follow=
ing=0Aadvices and gotchas from this:=20=0Ahttps://www.mail-archive.com/netd=
ev@vger.kernel.org/msg184139.html enough=0Aor are there some additional/new=
er recommendations? I managed to get near=0Aline-rate on my Intel X520s (on=
 Ryzen 3700X and one queue/CPU), but not=0Aquite 14.88 Mpps so I was wonder=
ing is there something else to speed=0Athings up even more.=0A=0AAlso, are =
there any recommended settings/tweaks for bidirectional=0Aforwarding? I sup=
pose there would be a drop in performance compared to=0Asingle direction, b=
ut has anyone done any benchmarks?=0A=0ARegards,=0ADenis
