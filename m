Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387656AbgEXRfy (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Sun, 24 May 2020 13:35:54 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0967FC061A0E
        for <xdp-newbies@vger.kernel.org>; Sun, 24 May 2020 10:35:54 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id v4so12339322qte.3
        for <xdp-newbies@vger.kernel.org>; Sun, 24 May 2020 10:35:53 -0700 (PDT)
Subject: Re: AF_XDP Side Of Project Breaking With XDP-Native
References: <50fe1ab5-55e7-980b-54d4-cd1d5e864865@gflclan.com>
 <20200522175136.5a6fdc55@carbon>
 <cd32e639-018e-2346-9570-f2167dfe651e@gflclan.com>
From: David Ahern <dsahern@gmail.com>
Message-ID: <6709130c-a676-127d-ac9d-d0ab35397b0d@gmail.com>
Date: Sun, 24 May 2020 11:35:51 -0600
MIME-Version: 1.0
In-Reply-To: <cd32e639-018e-2346-9570-f2167dfe651e@gflclan.com>
Content-Language: en-US
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Christian Deacon <gamemann@gflclan.com>, Jesper Dangaard Brouer <brouer@redhat.com>
Cc: xdp-newbies@vger.kernel.org

On 5/22/20 10:12 AM, Christian Deacon wrote:
> Hey Jesper,
> 
> 
> I apologize for not providing that information before. The driver is
> `virtio_net`. Unfortunately, I'm not sure what the NIC driver on the
> cluster is. Once my program's code is confirmed to be correct, I will
> try reaching out to our hosting provider to see if they can provide this
> information if the NIC's driver is the suspected cause to this issue.
> 
> ```
> 
> root@SEAV21:~/AF_XDP-Test# ethtool -i ens3
> driver: virtio_net
> version: 1.0.0
> firmware-version:
> expansion-rom-version:
> bus-info: 0000:00:03.0
> supports-statistics: yes
> supports-test: no
> supports-eeprom-access: no
> supports-register-dump: no
> supports-priv-flags: no
> ```
> 
> 

Is this a 4-cpu VM or 8 cpu VM?

A previous response had:

root@SEAV21:~/AF_XDP-Test# ethtool -l ens3
Channel parameters for ens3:
Pre-set maximums:
RX:             0
TX:             0
Other:          0
Combined:       8
Current hardware settings:
RX:             0
TX:             0
Other:          0
Combined:       1

The 8 for pre-set max says the nic has 8 queues. If it is a 4-vcpu vm,
then try

ethtool -L ens3 combined 4

which leaves 4 for xdp. If it is an 8 cpu VM I believe you are out of
luck given current requirements.
