Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbgFELRf (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Fri, 5 Jun 2020 07:17:35 -0400
Received: from postout1.mail.lrz.de (postout1.mail.lrz.de [IPv6:2001:4ca0:0:103::81bb:ff89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04369C08C5C2
        for <xdp-newbies@vger.kernel.org>; Fri,  5 Jun 2020 04:17:35 -0700 (PDT)
Received: from lxmhs51.srv.lrz.de (localhost [127.0.0.1])
        by postout1.mail.lrz.de (Postfix) with ESMTP id 49dg9960T3zyZG
        for <xdp-newbies@vger.kernel.org>; Fri,  5 Jun 2020 13:17:33 +0200 (CEST)
Received: from postout1.mail.lrz.de ([127.0.0.1])
        by lxmhs51.srv.lrz.de (lxmhs51.srv.lrz.de [127.0.0.1]) (amavisd-new, port 20024)
        with LMTP id x2dHLChTK6el for <xdp-newbies@vger.kernel.org>;
        Fri,  5 Jun 2020 13:17:33 +0200 (CEST)
Received: from BADWLRZ-SWMBX04.ads.mwn.de (BADWLRZ-SWMBX04.ads.mwn.de [IPv6:2001:4ca0:0:108::160])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (Client CN "BADWLRZ-SWMBX04", Issuer "BADWLRZ-SWMBX04" (not verified))
        by postout1.mail.lrz.de (Postfix) with ESMTPS id 49dg994ML8zyZ5
        for <xdp-newbies@vger.kernel.org>; Fri,  5 Jun 2020 13:17:33 +0200 (CEST)
From: "Gaul, Maximilian" <maximilian.gaul@hm.edu>
Subject: Intel X520 looses ethtool flow-type rule the moment a BPF / XDP
 program is loaded
Date: Fri, 5 Jun 2020 11:17:33 +0000
Message-ID: <a5741e0f3b90422f8c53a8bd54f06d8a@hm.edu>
Content-Language: de-DE
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Xdp <xdp-newbies@vger.kernel.org>

Hello,

I have an Intel X520 10Gbit/s NIC with driver:

=09=09$ sudo ethtool -i eth5
=09=09driver: ixgbe
=09=09version: 5.7.1
=09=09firmware-version: 0x80000827, 16.5.19
=09=09expansion-rom-version:=20
=09=09bus-info: 0000:04:00.1
=09=09supports-statistics: yes
=09=09supports-test: yes
=09=09supports-eeprom-access: yes
=09=09supports-register-dump: yes
=09=09supports-priv-flags: yes

and Kernel:

=09=09$ uname -a
=09=09Linux 5.6.0-2-amd64

I tried this tutorial before hand: https://software.intel.com/content/www/u=
s/en/develop/articles/setting-up-intel-ethernet-flow-director.html

Unfortunately I am experiencing some strange behavior in combination with A=
F_XDP.

For example, I am adding an ethtool flow-type rule like this:

=09=09$ sudo ethtool -N eth5 flow-type udp4 dst-ip 239.0.1.1 dst-port 5500 =
action 0
=09=09Added rule with ID 4093

Checking it is there:

=09=09$ sudo ethtool -n eth5
=09=0916 RX rings available
=09=09Total 1 rules

=09=09Filter: 4093
=09=09=09=09Rule Type: UDP over IPv4
=09=09=09=09Src IP addr: 0.0.0.0 mask: 255.255.255.255
=09=09=09=09Dest IP addr: 239.0.1.1 mask: 0.0.0.0
=09=09=09=09TOS: 0x0 mask: 0xff
=09=09=09=09Src port: 0 mask: 0xffff
=09=09=09=09Dest port: 5500 mask: 0x0
=09=09=09=09VLAN EtherType: 0x0 mask: 0xffff
=09=09=09=09VLAN: 0x0 mask: 0xffff
=09=09=09=09User-defined: 0x0 mask: 0xffffffffffffffff
=09=09=09=09Action: Direct to queue 0

After that I am launching my AF_XDP program which firsts loads a compiled B=
PF-object file into the kernel (without any errors).
I am checking ethtool again:

=09=09$ sudo ethtool -n eth5
=09=0916 RX rings available
=09=09Total 0 rules

Any ideas why that is? I am not saying that my program is bug-free but it w=
orked fine in combination with Mellannox ConnectX5 and Broadcom 1Gbit/s NIC=
 (without zcopy on the broadcom though).

Thank you

Max
