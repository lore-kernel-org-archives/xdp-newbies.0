Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qt1-f171.google.com ([209.85.160.171]:43668 "EHLO
        mail-qt1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbfHBKfe (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Fri, 2 Aug 2019 06:35:34 -0400
Received: by mail-qt1-f171.google.com with SMTP id w17so29032300qto.10
        for <xdp-newbies@vger.kernel.org>; Fri, 02 Aug 2019 03:35:33 -0700 (PDT)
MIME-Version: 1.0
References: <CAEaYocbC=x=fzXVJoKpHRXmK74-buEoqpSAvyuODRm3CH4k+Sw@mail.gmail.com>
In-Reply-To: <CAEaYocbC=x=fzXVJoKpHRXmK74-buEoqpSAvyuODRm3CH4k+Sw@mail.gmail.com>
From: =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date: Fri, 2 Aug 2019 12:35:22 +0200
Message-ID: <CAJ+HfNgF-ncUeAc_004DB73aSaxS3X0cwqzYhwEFtPTYwQxPTw@mail.gmail.com>
Subject: Re: Ajusting XSKMAP max_entries value
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Rafael Vargas <vargas@khomp.com>
Cc: Xdp <xdp-newbies@vger.kernel.org>

On Wed, 31 Jul 2019 at 01:43, Rafael Vargas <vargas@khomp.com> wrote:
>
> Hi,
>

Hi Rafael,

> I'm using AF_XDP sockets to bulk read from the network device and it
> seems to work fine.
>
> Now I'm fine tuning my code in order to compatible in a broader range
> of scenarios.
>
> How should I set the size of my XSKMAP? As I'm creating one AF_XDP
> socket for each RX queue, and using this as the map size, is this
> correct?
>

There's really no right or wrong here, since the XDP program decides
which slot of XSKMAP to redirect to. The "builtin" libbpf XDP program
uses an XSKMAP with as many entries as there are enabled queues
(ethtool -l) on the device.


> As I'm using programs compiled using clang-bpf, is there a way to
> change this value without having to recompile the program?
>

You mean changing the size of the map? You can't do that, but you can
create a *new* map and swap that in. But that would require that your
XDP program would be a bit more complex (handling the XSKMAP
swapping).

> What would be the recommended way to setting this value correctly for
> each interface?
>

Again, hard to say in general. For one socket per queue, scenario,
then # entries would be the same as # queues.


Bj=C3=B6rn

> Thanks!
>
> Rafael Vargas
