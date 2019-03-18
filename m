Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12908 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726868AbfCROWZ (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 18 Mar 2019 10:22:25 -0400
Date: Mon, 18 Mar 2019 15:22:18 +0100
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: XDP-tutorial: VM-image and setup instructions
Message-ID: <20190318152218.0b554e20@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: NetDevConf-people <people@netdevconf.org>
Cc: brouer@redhat.com, Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>


The XDP-tutorial early morning (8:30-10:30) Wednesday 20th March at
NetDevConf0x13, requires some preparations from the participants.

The requirement is a laptop with kernel v4.20 (minimum v4.19). Don't
panic if your kernel is older as we provide a VM-image, with all the
dependencies installed.  You should pre-download this (else it will be
provide on a USB stick).

There have been created a release tag, on github:
 https://github.com/xdp-project/xdp-tutorial/releases/tag/2019-03-18-netdev0x13

This links to an XZ compressed version of the VM-image you need
(use unxz to xz --decompress).

How to use this VM-image is described here:
 https://github.com/xdp-project/xdp-tutorial/blob/master/setup-testlab/using_vm_image.org
Remember to install kvm/libvirt on your laptop (described for Fedora).

-- 
Best regards,
 Jesper Dangaard Brouer and Toke Høiland-Jørgensen
