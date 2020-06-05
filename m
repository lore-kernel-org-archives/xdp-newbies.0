Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726314AbgFEL54 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Fri, 5 Jun 2020 07:57:56 -0400
Received: from mail-vs1-xe31.google.com (mail-vs1-xe31.google.com [IPv6:2607:f8b0:4864:20::e31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11834C08C5C2
        for <xdp-newbies@vger.kernel.org>; Fri,  5 Jun 2020 04:57:56 -0700 (PDT)
Received: by mail-vs1-xe31.google.com with SMTP id u17so5426368vsu.7
        for <xdp-newbies@vger.kernel.org>; Fri, 05 Jun 2020 04:57:56 -0700 (PDT)
MIME-Version: 1.0
References: <a5741e0f3b90422f8c53a8bd54f06d8a@hm.edu>
In-Reply-To: <a5741e0f3b90422f8c53a8bd54f06d8a@hm.edu>
From: Magnus Karlsson <magnus.karlsson@gmail.com>
Date: Fri, 5 Jun 2020 13:57:44 +0200
Message-ID: <CAJ8uoz3V1F4MB9yprixAReFqPCW9bE4SbV58Gs-D7qdSXtz6sg@mail.gmail.com>
Subject: Re: Intel X520 looses ethtool flow-type rule the moment a BPF / XDP
 program is loaded
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
To: "Gaul, Maximilian" <maximilian.gaul@hm.edu>
Cc: Xdp <xdp-newbies@vger.kernel.org>

On Fri, Jun 5, 2020 at 1:18 PM Gaul, Maximilian <maximilian.gaul@hm.edu> wrote:
>
> Hello,
>
> I have an Intel X520 10Gbit/s NIC with driver:
>
>                 $ sudo ethtool -i eth5
>                 driver: ixgbe
>                 version: 5.7.1
>                 firmware-version: 0x80000827, 16.5.19
>                 expansion-rom-version:
>                 bus-info: 0000:04:00.1
>                 supports-statistics: yes
>                 supports-test: yes
>                 supports-eeprom-access: yes
>                 supports-register-dump: yes
>                 supports-priv-flags: yes
>
> and Kernel:
>
>                 $ uname -a
>                 Linux 5.6.0-2-amd64
>
> I tried this tutorial before hand: https://software.intel.com/content/www/us/en/develop/articles/setting-up-intel-ethernet-flow-director.html
>
> Unfortunately I am experiencing some strange behavior in combination with AF_XDP.
>
> For example, I am adding an ethtool flow-type rule like this:
>
>                 $ sudo ethtool -N eth5 flow-type udp4 dst-ip 239.0.1.1 dst-port 5500 action 0
>                 Added rule with ID 4093
>
> Checking it is there:
>
>                 $ sudo ethtool -n eth5
>                 16 RX rings available
>                 Total 1 rules
>
>                 Filter: 4093
>                                 Rule Type: UDP over IPv4
>                                 Src IP addr: 0.0.0.0 mask: 255.255.255.255
>                                 Dest IP addr: 239.0.1.1 mask: 0.0.0.0
>                                 TOS: 0x0 mask: 0xff
>                                 Src port: 0 mask: 0xffff
>                                 Dest port: 5500 mask: 0x0
>                                 VLAN EtherType: 0x0 mask: 0xffff
>                                 VLAN: 0x0 mask: 0xffff
>                                 User-defined: 0x0 mask: 0xffffffffffffffff
>                                 Action: Direct to queue 0
>
> After that I am launching my AF_XDP program which firsts loads a compiled BPF-object file into the kernel (without any errors).
> I am checking ethtool again:
>
>                 $ sudo ethtool -n eth5
>                 16 RX rings available
>                 Total 0 rules
>
> Any ideas why that is? I am not saying that my program is bug-free but it worked fine in combination with Mellannox ConnectX5 and Broadcom 1Gbit/s NIC (without zcopy on the broadcom though).

Max,

This is unfortunately a known issue with this older NIC. The newer
Intel NICs such as i40e (Fortville) and ice (Columbiaville) work as
you would expect. They do remember filter settings after enabling XDP.

/Magnus

> Thank you
>
> Max
