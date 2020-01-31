Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-oi1-f181.google.com ([209.85.167.181]:44512 "EHLO
        mail-oi1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727741AbgAaCQJ (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 30 Jan 2020 21:16:09 -0500
Received: by mail-oi1-f181.google.com with SMTP id d62so5751135oia.11
        for <xdp-newbies@vger.kernel.org>; Thu, 30 Jan 2020 18:16:08 -0800 (PST)
MIME-Version: 1.0
From: Cameron Elliott <cameron@cameronelliott.com>
Date: Thu, 30 Jan 2020 18:15:55 -0800
Message-ID: <CAMyc9bXvhK2a-m9KEj34rnc3EBM4mgFicdfvRWay=cwuNVDg8g@mail.gmail.com>
Subject: Cannot run multiple 'xdpsock' concurrently?
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
To: Xdp <xdp-newbies@vger.kernel.org>

Hello, I am trying to measure the maximum mpps I can push using AF_XDP
on a 40G X710

I can do ~22 mpps after resolving a few bumbles I made with drivers,
etc., (Thanks Magnus!)
when using a single instance of 'xdpsock'


Apparently the way to upto 50, 60 or 70? mpps is to use multiple cores...
And apparently the simple way to do that, is multiple instances of
xdpsock on different queues.

But, my attempts with multiple instances fail. :(



First, I checked my channel setup:

$ sudo ethtool --set-channels enp1s0f0
no channel parameters changed.
current values: rx 0 tx 0 other 1 combined 4

I presume that is okay...

Then I run these two commands in two different windows:

sudo  /home/c/bpf-next/samples/bpf/xdpsock -i enp1s0f0 -t -N -z -q 0
sudo  /home/c/bpf-next/samples/bpf/xdpsock -i enp1s0f0 -t -N -z -q 1

With the only difference being the queue id.

The first will start and show ~22 mpps tx rate.
When I start the second, both instances die:

The first instace dies with:
/home/c/bpf-next/samples/bpf/xdpsock_user.c:kick_tx:794: errno:
100/"Network is down"

The second instance dies with:
/home/c/bpf-next/samples/bpf/xdpsock_user.c:kick_tx:794: errno: 6/"No
such device or address"


Do I understand correctly I should be able to run two instances like
this concurrently?



Thank you for any ideas, input.



# ethtool dump / i40e driver from recent bpf-next clone
c@lumen ~> ethtool -i enp1s0f0
driver: i40e
version: 2.8.20-k
firmware-version: 7.10 0x80006456 1.2527.0
expansion-rom-version:
bus-info: 0000:01:00.0
supports-statistics: yes
supports-test: yes
supports-eeprom-access: yes
supports-register-dump: yes
supports-priv-flags: yes
