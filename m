Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-ot1-f68.google.com ([209.85.210.68]:36052 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726504AbgA2CvJ (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 28 Jan 2020 21:51:09 -0500
Received: by mail-ot1-f68.google.com with SMTP id g15so14216210otp.3
        for <xdp-newbies@vger.kernel.org>; Tue, 28 Jan 2020 18:51:09 -0800 (PST)
MIME-Version: 1.0
References: <CAMyc9bWnDuwDx_i=NjoAS1cDd5Fuy6T05ukSQZpjQv2Ji36jGg@mail.gmail.com>
 <CAJ8uoz1=Se+-hYWO6E11_LM9kS2Z1Eqeq17pB=oQC1tDR75WiA@mail.gmail.com>
In-Reply-To: <CAJ8uoz1=Se+-hYWO6E11_LM9kS2Z1Eqeq17pB=oQC1tDR75WiA@mail.gmail.com>
From: Cameron Elliott <cameron@cameronelliott.com>
Date: Tue, 28 Jan 2020 18:50:55 -0800
Message-ID: <CAMyc9bUr9FLLS7hqVeU=jOBfvDfn4Ch0kkErGMFYZgstMXRqPw@mail.gmail.com>
Subject: Re: Maximum xdpsock txpush rate with AF_XDP ??
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To: Xdp <xdp-newbies@vger.kernel.org>

Hi all,

I am still stuck at 'xdpsock -t -i enp1s0f0 -N -z'
Failing: samples/bpf/xdpsock_user.c:xsk_configure_socket:322: errno:
95/"Operation not supported"

But if I remove the -z, it works, at 2mpps

I believe I am running just i40e without the virtual function driver.
(installed i40e from source with modprobe)

I am running a 5.3 kernel, IS THIS TOO NEW?  (details below)

I am running the i40 2.10.19.30 driver, with firmware 7.10 (details below)

Do all those version numbers sound okay?

Should I try a different kernel or i40 driver, or firmware/NVM revision?

Thanks, Cameron



--- details on kernel and i40 driver and firmware version ---

~> uname -aLinux lumen 5.3.0-26-generic #28~18.04.1-Ubuntu SMP Wed Dec
18 16:40:14 UTC 2019 x86_64 x86_64 x86_64 GNU/Linux

~> ethtool -i enp1s0f0
driver: i40e
version: 2.10.19.30
firmware-version: 7.10 0x80006456 1.2527.0
expansion-rom-version:
bus-info: 0000:01:00.0
supports-statistics: yes
supports-test: yes
supports-eeprom-access: yes
supports-register-dump: yes
supports-priv-flags: yes
