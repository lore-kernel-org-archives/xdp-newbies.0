Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-oln040092071014.outbound.protection.outlook.com ([40.92.71.14]:30862
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728547AbgFDNav (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 4 Jun 2020 09:30:51 -0400
From: Federico Parola <fede.parola@hotmail.it>
Subject: Lightweight packet timestamping
Date: Thu, 4 Jun 2020 13:30:48 +0000
Message-ID: <DB7PR08MB3130BA2C0F90E0819577C5289E890@DB7PR08MB3130.eurprd08.prod.outlook.com>
References: <DB7PR08MB3130BDD01387627E7FAD775F9E890@DB7PR08MB3130.eurprd08.prod.outlook.com>,<DB7PR08MB3130C02AB04133E07146F40D9E890@DB7PR08MB3130.eurprd08.prod.outlook.com>
In-Reply-To: <DB7PR08MB3130C02AB04133E07146F40D9E890@DB7PR08MB3130.eurprd08.prod.outlook.com>
Content-Language: it-IT
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>

Hello everybody,=0AI'm implementing a token bucket algorithm to apply rate =
limit to traffic and I need the timestamp of packets to update the bucket. =
To get this information I'm using the bpf_ktime_get_ns() helper but I've di=
scovered it has a non negligible impact on performance. I've seen there is =
work in progress to make hardware timestamps available to XDP programs, but=
 I don't know if this feature is already available. Is there a faster way t=
o retrieve this information?=0AThanks for your attention.=0A=0AFederico Par=
ola
