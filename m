Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qt1-f194.google.com ([209.85.160.194]:33008 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726488AbfJBNwQ (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Wed, 2 Oct 2019 09:52:16 -0400
Received: by mail-qt1-f194.google.com with SMTP id r5so26454690qtd.0
        for <xdp-newbies@vger.kernel.org>; Wed, 02 Oct 2019 06:52:16 -0700 (PDT)
MIME-Version: 1.0
References: <ccfd36d0372547099b96ea494e2c6369@pantheon.tech>
In-Reply-To: <ccfd36d0372547099b96ea494e2c6369@pantheon.tech>
From: =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date: Wed, 2 Oct 2019 15:52:04 +0200
Message-ID: <CAJ+HfNh58fN=BU5ADzTs=vbCD1j5fs0i1EKhAQQdByjiVHz4BQ@mail.gmail.com>
Subject: Re: xdpsock problem testing multiple queues
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: =?UTF-8?Q?J=C3=BAlius_Milan?= <Julius.Milan@pantheon.tech>
Cc: Xdp <xdp-newbies@vger.kernel.org>, Magnus Karlsson <magnus.karlsson@gmail.com>, =?UTF-8?B?TWFyZWsgWsOhdm9kc2vDvQ==?= <marek.zavodsky@pantheon.tech>, Jesper Dangaard Brouer <brouer@redhat.com>, William Tu <u9012063@gmail.com>, Eelco Chaudron <echaudro@redhat.com>

On Wed, 2 Oct 2019 at 14:11, J=C3=BAlius Milan <Julius.Milan@pantheon.tech>=
 wrote:
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

XDP support is missing for that driver, but the XDP_SKB/generic mode
is available, and should work.

Can you run the xdp1 application in the samples directory, to rule out
that you can run XDP.


Bj=C3=B6rn

> Best Regards
> J=C3=BAlius
