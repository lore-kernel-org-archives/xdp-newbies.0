Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-ed1-f45.google.com ([209.85.208.45]:37966 "EHLO
        mail-ed1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726366AbfCSJBp (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 19 Mar 2019 05:01:45 -0400
Received: by mail-ed1-f45.google.com with SMTP id q14so277531edr.5
        for <xdp-newbies@vger.kernel.org>; Tue, 19 Mar 2019 02:01:44 -0700 (PDT)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: XDP-tutorial: VM-image and setup instructions
In-Reply-To: <20190318152218.0b554e20@carbon>
References: <20190318152218.0b554e20@carbon>
Date: Tue, 19 Mar 2019 10:01:42 +0100
Message-ID: <87k1gvs0eh.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jesper Dangaard Brouer <brouer@redhat.com>, NetDevConf-people <people@netdevconf.org>
Cc: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>

Jesper Dangaard Brouer <brouer@redhat.com> writes:

> The XDP-tutorial early morning (8:30-10:30) Wednesday 20th March at
> NetDevConf0x13, requires some preparations from the participants.
>
> The requirement is a laptop with kernel v4.20 (minimum v4.19). Don't
> panic if your kernel is older as we provide a VM-image, with all the
> dependencies installed.  You should pre-download this (else it will be
> provide on a USB stick).
>
> There have been created a release tag, on github:
>  https://github.com/xdp-project/xdp-tutorial/releases/tag/2019-03-18-netdev0x13

This link now also contains an .ova image which should be usable with
VirtualBox :)

-Toke
