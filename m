Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-ot1-f68.google.com ([209.85.210.68]:44706 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726671AbgA3BDL (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 29 Jan 2020 20:03:11 -0500
Received: by mail-ot1-f68.google.com with SMTP id h9so1510381otj.11
        for <xdp-newbies@vger.kernel.org>; Wed, 29 Jan 2020 17:03:11 -0800 (PST)
MIME-Version: 1.0
From: Cameron Elliott <cameron@cameronelliott.com>
Date: Wed, 29 Jan 2020 17:02:59 -0800
Message-ID: <CAMyc9bVpR9thvVsa-LWNg6BPwkqNcL-W-FuEXdfXgGxCUUn3jA@mail.gmail.com>
Subject: xdpsock ... -N -z and AF_XDP XDP_ZEROCOPY not working: RESOLVED!
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To: Xdp <xdp-newbies@vger.kernel.org>, Magnus Karlsson <magnus.karlsson@gmail.com>

My benchmarking with xdpsock was failing whenever I added '-z' to the
'-N' option.
Which is basically the XDP_ZEROCOPY flag to the AF_XDP setup call.


I had the latest x710 firmware, and latest i40e driver on my ubuntu 18.04 b=
ox.
I also had th 5.3.0 kernel as installed by:
"sudo apt-get install --install-recommends linux-generic-hwe-18.04"

To my surprise, xdpsock ... -N -z was failing with errno 95


Turns out the 5.3.0 kernel was the culprit that prevented '-z' working with=
 '-N'
(prevented XDP_ZEROCOPY working)

I installed the bpf-next kernel found here:

With this command:
git clone git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git
More info: https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git=
/

I built the kernel using these directions:
https://wiki.ubuntu.com/KernelTeam/GitKernelBuild

And after rebooting and running on the 5.5 bpf-next kernel, -z and
XDP_ZEROCOPY were working fine!


Many many thanks to Magnus for his help tracking this down.


I re-posted this under a better title (IMHO) to help others suffering
the same fate to find it.



Cameron Elliott
