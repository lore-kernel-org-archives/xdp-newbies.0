Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qt1-f196.google.com ([209.85.160.196]:44292 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727491AbgA3EmA (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 29 Jan 2020 23:42:00 -0500
Received: by mail-qt1-f196.google.com with SMTP id w8so1424133qts.11
        for <xdp-newbies@vger.kernel.org>; Wed, 29 Jan 2020 20:42:00 -0800 (PST)
Subject: Re: xdpsock ... -N -z and AF_XDP XDP_ZEROCOPY not working: RESOLVED!
References: <CAMyc9bVpR9thvVsa-LWNg6BPwkqNcL-W-FuEXdfXgGxCUUn3jA@mail.gmail.com>
From: David Ahern <dsahern@gmail.com>
Message-ID: <c45f64a7-ffff-a123-818c-4dc127cd3ff4@gmail.com>
Date: Wed, 29 Jan 2020 21:41:57 -0700
MIME-Version: 1.0
In-Reply-To: <CAMyc9bVpR9thvVsa-LWNg6BPwkqNcL-W-FuEXdfXgGxCUUn3jA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Cameron Elliott <cameron@cameronelliott.com>, Xdp <xdp-newbies@vger.kernel.org>, Magnus Karlsson <magnus.karlsson@gmail.com>

On 1/29/20 6:02 PM, Cameron Elliott wrote:
> With this command:
> git clone git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git
> More info: https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/
> 
> I built the kernel using these directions:
> https://wiki.ubuntu.com/KernelTeam/GitKernelBuild
> 
> And after rebooting and running on the 5.5 bpf-next kernel, -z and
> XDP_ZEROCOPY were working fine!

since this is literally bleeding edge, is there a wiki/doc/other for
kernel versions and supported features? Something similar to what MLX
does for switchdev [1] would be really helpful.

[1] https://github.com/Mellanox/mlxsw/wiki
