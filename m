Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from turquesa.dcc.ufmg.br ([150.164.0.150]:33303 "EHLO
        turquesa.dcc.ufmg.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726333AbgA2BTT (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 28 Jan 2020 20:19:19 -0500
Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
        by turquesa.dcc.ufmg.br (Postfix) with ESMTPSA id 564C67F839
        for <xdp-newbies@vger.kernel.org>; Fri, 31 Jan 2020 17:53:34 -0300 (-03)
Received: by mail-oi1-f175.google.com with SMTP id a22so3257907oid.13
        for <xdp-newbies@vger.kernel.org>; Tue, 28 Jan 2020 17:19:17 -0800 (PST)
MIME-Version: 1.0
References: <6c3dc8ff-e2bd-a06e-d9f0-c5be0103d266@gflclan.com>
 <20200123141122.3783e298@carbon> <23ec64c0-e0d7-a60b-ecc4-6ca401dc4896@gflclan.com>
 <20200123213808.7a1f200b@carbon> <fdd597bf-7da9-f9bd-d97f-f1bd90f14281@gflclan.com>
 <f5242b7e-6c26-8682-9bc6-61f39497ca8e@gflclan.com>
In-Reply-To: <f5242b7e-6c26-8682-9bc6-61f39497ca8e@gflclan.com>
From: Matheus Salgueiro Castanho <matheus.castanho@dcc.ufmg.br>
Date: Tue, 28 Jan 2020 22:19:04 -0300
Message-ID: <CAPyJoHmbX4Cp0h1L+f+bm0piV_TQpu3xuEPanm2VA_Ef4qC6Cw@mail.gmail.com>
Subject: Re: Measuring/Debugging XDP Performance
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To: Christian Deacon <gamemann@gflclan.com>
Cc: xdp-newbies@vger.kernel.org

Hi Christian,

On Tue, Jan 28, 2020 at 4:01 PM Christian Deacon <gamemann@gflclan.com> wro=
te:
>
> Hey everyone,

[...]

>
> My question is, how would you know if you're using XDP-native or not?

I believe the 'ip link' command is able to tell you that. If you have
an XDP program attached to interface eth0, you can do something like:

$ ip link show dev eth0
6: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 xdp qdisc
mq state UP mode DEFAULT group default qlen 1000
link/ether xx:xx:xx:xx:xx:xx brd ff:ff:ff:ff:ff:ff
prog/xdp id 27 tag f95672269956c10d jited

Note the 'xdp' after the MTU size. IIRC, that indicates XDP Native.
XDP generic would show `xdpgeneric` instead. `xdpoffload` is also a
possible output if your program is offloaded to a SmartNIC.

>
>
>
> Here's a link to the outputs of the 'perf' command discussed above for
> anyone interested:
>
>
> https://g.gflclan.com/6sHmHPlo3W.zip
>
>
> Any help is highly appreciated and thank you for your time!
>

--
Matheus Castanho
