Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-eopbgr670047.outbound.protection.outlook.com ([40.107.67.47]:39808
        "EHLO CAN01-TO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731751AbfHASx7 (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 1 Aug 2019 14:53:59 -0400
From: Brandon Cazander <brandon.cazander@multapplied.net>
Subject: Re: xdpgeneric, XDP_PASS, and bpf_xdp_adjust_head decapsulation
 dropping packets
Date: Thu, 1 Aug 2019 18:53:56 +0000
Message-ID: <20190801185345.GA746463@multapplied.net>
References: <20190731211211.GA87084@multapplied.net>
 <20190801101746.702431fc@carbon> <20190801173324.GA660183@multapplied.net>
 <20190801201612.3aef7783@carbon>
In-Reply-To: <20190801201612.3aef7783@carbon>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1D04C43178A4DC48A309C9D94E37DB91@CANPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>, David Miller <davem@davemloft.net>

[...]

> Thanks for also confirming. I've just send a patchset with fixes:
>  https://patchwork.ozlabs.org/project/netdev/list/?series=3D122796&state=
=3D%2a

Thank you for this; I tested this against my environment and it works as
expected again.

> I can recommend that you look at the selftest script test_xdp_vlan.sh:
>  https://github.com/torvalds/linux/blob/master/tools/testing/selftests/bp=
f/test_xdp_vlan.sh
>=20
> Which uses veth and network namespaces for testing.  If you get the
> hint, then you can actually create these small scripts, that can
> function as unit and regression tests for XDP code snippets.
>=20
> Our XDP-tutorial also uses veth as a development environment:
>  https://github.com/xdp-project/xdp-tutorial/tree/master/testenv

Great hint, I will definitely use these going forward!
