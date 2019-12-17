Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qk1-f194.google.com ([209.85.222.194]:36920 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725940AbfLQWz7 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 17 Dec 2019 17:55:59 -0500
Received: by mail-qk1-f194.google.com with SMTP id 21so7052771qky.4
        for <xdp-newbies@vger.kernel.org>; Tue, 17 Dec 2019 14:55:59 -0800 (PST)
MIME-Version: 1.0
References: <b36728e9-4cb8-4127-2127-2cbdcd9a0068@nic.cz>
In-Reply-To: <b36728e9-4cb8-4127-2127-2cbdcd9a0068@nic.cz>
From: William Tu <u9012063@gmail.com>
Date: Tue, 17 Dec 2019 14:55:22 -0800
Message-ID: <CALDO+Sb00zQKuGKP43q-WEVXntMhmL+y8RN-_NTB879HxYbfTA@mail.gmail.com>
Subject: Re: AF_XDP headroom
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: =?UTF-8?B?VmxhZGltw61yIMSMdW7DoXQ=?= <vladimir.cunat@nic.cz>
Cc: Xdp <xdp-newbies@vger.kernel.org>

On Tue, Dec 17, 2019 at 7:05 AM Vladim=C3=ADr =C4=8Cun=C3=A1t <vladimir.cun=
at@nic.cz> wrote:
>
> Hello.
>
> I configured .frame_headroom =3D 0 (default) but I receive packets with
> larger one (256).  Am I doing something wrong?  Kernel [docs] says:
>
This is correct.
The 256 headroom is for XDP frame's headroom, reserved in driver.
So you shouldn't use it.
if you configure .frame_headroom =3D 256, then your frame will start
with 256 + 256.

> > There is also an option to set the headroom of each single buffer in
> the UMEM. If you set this to N bytes, it means that the packet will
> start N bytes into the buffer leaving the first N bytes for the
> application to use.

Yes
William

>
> which doesn't sound to leave an option for kernel-space to
> change/increase it, but apparently it does so for me.  In my case it
> wouldn't really be an issue, except it makes me unsure e.g. whether 2k
> frames are guaranteed to handle standard 1.5k payloads.
>
> [docs]
> https://www.kernel.org/doc/html/latest/networking/af_xdp.html?highlight=
=3Dheadroom
>
> Thanks
> --Vladimir
>
