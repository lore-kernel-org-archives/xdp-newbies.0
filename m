Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726158AbgD2B5a (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 28 Apr 2020 21:57:30 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F4C3C03C1AC
        for <xdp-newbies@vger.kernel.org>; Tue, 28 Apr 2020 18:57:29 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id w2so267978edx.4
        for <xdp-newbies@vger.kernel.org>; Tue, 28 Apr 2020 18:57:29 -0700 (PDT)
MIME-Version: 1.0
References: <CAHQoOTZGdLYZ=qjF8+Rwi+E5y_st1u1CwMPiP65UHWpvRXvhZA@mail.gmail.com>
 <60973878-18e8-aca3-5b4b-26947dc5ded8@gmail.com>
In-Reply-To: <60973878-18e8-aca3-5b4b-26947dc5ded8@gmail.com>
From: Zvi Effron <zeffron@riotgames.com>
Date: Tue, 28 Apr 2020 20:57:16 -0500
Message-ID: <CAC1LvL2sVd428n3PwhDbwVoDGk5wh4s34kNj=GVkRM5X44A2+A@mail.gmail.com>
Subject: Re: XDP Native mode with public cloud (GCP)
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
To: David Ahern <dsahern@gmail.com>
Cc: John McDowall <jmcdowall@paloaltonetworks.com>, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>

On Tue, Apr 28, 2020 at 12:19 PM David Ahern <dsahern@gmail.com> wrote:
> last I looked AWS does not support XDP either. Never tried Azure.

XDP just recently started supporting XDP. You will need their
out-of-tree driver from https://github.com/amzn/amzn-drivers/. It does
not support XDP_REDIRECT, and I don't think it supports AF_XDP, but it
does support XDP_PASS, XDP_DROP, and XDP_TX.

I have verified this today on a Fedora 31 based image, though it does
require a few modifications to get the RPM to build.

--Zvi
