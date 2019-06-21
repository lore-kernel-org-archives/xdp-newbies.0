Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-lj1-f179.google.com ([209.85.208.179]:43465 "EHLO
        mail-lj1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726108AbfFUTUP (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 21 Jun 2019 15:20:15 -0400
Received: by mail-lj1-f179.google.com with SMTP id 16so6893921ljv.10
        for <xdp-newbies@vger.kernel.org>; Fri, 21 Jun 2019 12:20:13 -0700 (PDT)
MIME-Version: 1.0
From: Rafael Vargas <vargas@khomp.com>
Date: Fri, 21 Jun 2019 16:20:00 -0300
Message-ID: <CAEaYocYhic1UC2p60gO6rzJYzHaHob=0-GUN1Z2e0XgMaPoMBg@mail.gmail.com>
Subject: AF_XDP only releasing from FQ in batches
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org

Hi,

I'm trying to use AF_XDP and I'm using the xdpsock sample
implementation as a guide.

I've noticed that the Fill Queue slots are released in batches of 16
(kernel 5.1)

The xdpsock (rx_drop) implementation will lock waiting for the space in the FQ.
This seems it will work fine when receiving lots of packets, but will
loop indefinetely if traffic stops.

This is the expected behavior for the FQ?
Should I keep the FQ always with free slots in order to avoid blocking
when waiting for more packets?

Rafael Vargas
