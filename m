Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-io1-f68.google.com ([209.85.166.68]:39817 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725875AbfJBMZx (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Wed, 2 Oct 2019 08:25:53 -0400
Received: by mail-io1-f68.google.com with SMTP id a1so56412963ioc.6
        for <xdp-newbies@vger.kernel.org>; Wed, 02 Oct 2019 05:25:51 -0700 (PDT)
MIME-Version: 1.0
References: <ccfd36d0372547099b96ea494e2c6369@pantheon.tech>
In-Reply-To: <ccfd36d0372547099b96ea494e2c6369@pantheon.tech>
From: Pavel Popa <pashinho1990@gmail.com>
Date: Wed, 2 Oct 2019 14:25:39 +0200
Message-ID: <CAHOxX0ykVVTPopnSwnzL75RLj4-dnFWttdw0zS7jYe6Z4HcF2g@mail.gmail.com>
Subject: Re: xdpsock problem testing multiple queues
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: =?UTF-8?Q?J=C3=BAlius_Milan?= <Julius.Milan@pantheon.tech>
Cc: Xdp <xdp-newbies@vger.kernel.org>, Magnus Karlsson <magnus.karlsson@gmail.com>, =?UTF-8?B?TWFyZWsgWsOhdm9kc2vDvQ==?= <marek.zavodsky@pantheon.tech>, Jesper Dangaard Brouer <brouer@redhat.com>, William Tu <u9012063@gmail.com>, Eelco Chaudron <echaudro@redhat.com>

I don't think vmxnet3 has XDP driver support atm, thus just generic
(i.e. skb) mode. Anyone confirming?


Il giorno mer 2 ott 2019 alle ore 14:11 J=C3=BAlius Milan
<Julius.Milan@pantheon.tech> ha scritto:
>
> Hi all
>
> We are trying to test multiple RX queues with sample program xdpsock from=
 kernel on vmware virtual machine with 2 queues.
> The driver on the NIC is:
> # ethtool -i ens192
> driver: vmxnet3
> version: 1.4.16.0-k-NAPI
>
> NIC has 2 queues, I can check it by ethtool -S.
>
> But when I try to use queue 1, I am getting following:
> # ./xdpsock -i ens192 -q 1
> /home/jmilan/ws/pt-xdp/linux/samples/bpf/xdpsock_user.c:xsk_configure_soc=
ket:315: errno: 1/"Operation not permitted"
>
> Any ideas what the problem could be? Maybe vmxnet3 driver does not suppor=
t some necessary operations related to queues?
>
> Best Regards
> J=C3=BAlius
