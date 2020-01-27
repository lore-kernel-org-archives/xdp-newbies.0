Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-oi1-f195.google.com ([209.85.167.195]:42406 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727046AbgA0M4C (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 27 Jan 2020 07:56:02 -0500
Received: by mail-oi1-f195.google.com with SMTP id j132so5425744oih.9
        for <xdp-newbies@vger.kernel.org>; Mon, 27 Jan 2020 04:56:02 -0800 (PST)
MIME-Version: 1.0
References: <CAMyc9bWnDuwDx_i=NjoAS1cDd5Fuy6T05ukSQZpjQv2Ji36jGg@mail.gmail.com>
In-Reply-To: <CAMyc9bWnDuwDx_i=NjoAS1cDd5Fuy6T05ukSQZpjQv2Ji36jGg@mail.gmail.com>
From: Magnus Karlsson <magnus.karlsson@gmail.com>
Date: Mon, 27 Jan 2020 13:55:50 +0100
Message-ID: <CAJ8uoz1=Se+-hYWO6E11_LM9kS2Z1Eqeq17pB=oQC1tDR75WiA@mail.gmail.com>
Subject: Re: Maximum xdpsock txpush rate with AF_XDP ??
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Cameron Elliott <cameron@cameronelliott.com>
Cc: Xdp <xdp-newbies@vger.kernel.org>

On Mon, Jan 27, 2020 at 1:37 PM Cameron Elliott
<cameron@cameronelliott.com> wrote:
>
> I am trying see what the highest rate I can push out of a single
> x710/QDA2 port is.
>
> I have seen numbers like 50+ mpps in a  Magnus and Bj=C3=B6rn youtube vid=
eo,
> but granted, I know very little as I am really new to the x710 and XDP/AF=
_XDP.
>
> But I am only able to get about 2.2 mpps,  nothing like Magnus and
> Bj=C3=B6rn have been able to achieve.

You are using the SKB mode, not the zero-copy mode that will give you
higher numbers. Somewhere around 20 Mpps if you run a new kernel.

> One big issue is this command "sudo ./xdpsock -t  -i enp1s0f0 -N -z"
> Fails with:
> samples/bpf/xdpsock_user.c:xsk_configure_socket:322: errno:
> 95/"Operation not supported"

What driver are you using? It seems it does not support zero copy. The
virtual function (vf) driver of x710/i40e does not but the physical
function driver does.

> Is there a guide or README I should read on how to try to achieve
> numbers like theirs?
>
> If there is not a guide, would it be helpful if I wrote one? (a small
> guide on maxing rxdrop/tspush/l2fwd)
> (it would seem like a good trade to get some help from others here,
> and write a simple guide from a newbies
> perspective like mine, if someone wants to give me some help)

A guide published on the net would always be helpful.

Thanks: Magnus

>
> --------------
> Kernel/os:     Linux lumen 5.3.0-26-generic #28~18.04.1-Ubuntu
> Intel NIC:      version: 2.10.19.30 / firmware-version: 7.10 0x80006456 1=
.2527.0
> Xeon 1225 V6 with 4 cores
>
>
> Thank you
