Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pl1-f193.google.com ([209.85.214.193]:36101 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbgAVWLK (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 22 Jan 2020 17:11:10 -0500
Received: by mail-pl1-f193.google.com with SMTP id a6so413257plm.3
        for <xdp-newbies@vger.kernel.org>; Wed, 22 Jan 2020 14:11:10 -0800 (PST)
From: Vincent Li <mchun.li@gmail.com>
Date: Wed, 22 Jan 2020 14:11:07 -0800 (PST)
Subject: Re: Measuring/Debugging XDP Performance
In-Reply-To: <6c3dc8ff-e2bd-a06e-d9f0-c5be0103d266@gflclan.com>
Message-ID: <alpine.OSX.2.21.2001221405250.1261@jiadeimac.local>
References: <6c3dc8ff-e2bd-a06e-d9f0-c5be0103d266@gflclan.com>
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
To: Christian Deacon <gamemann@gflclan.com>
Cc: xdp-newbies@vger.kernel.org



On Wed, 22 Jan 2020, Christian Deacon wrote:

> Hey everyone,
>=20
> I am new to XDP + AF_XDP (along with C programming in general), but I am =
very
> interested in it and I've been learning a lot recently. I own an Anycast
> network and our POP servers are running custom software our developer cre=
ated
> that processes packets using XDP. This software basically forwards specif=
ic
> traffic to another machine via an IPIP tunnel. One issue I've been notici=
ng is
> the packets our software is processing and forwarding to another machine =
keep
> dropping at higher traffic loads. I can't tell if this is dropping at the=
 POP
> level or if the machine the software is forwarding this specific traffic =
to
> is. I've even tried upgrading the POP server from a two-core VPS (2.5 GHz
> CPUs) to a dedicated server (Intel E3-1230v6 @ 3.5 GHz, 4 cores, and 8
> threads). If this is being dropped at the POP level, I'm wondering if the
> software is being limited to one core on this specific POP (other POPs ar=
e
> able to use more than one core specifically). However, I have no way to
> confirm that. To my understanding XDP programs should be able to use more=
 than
> one core.
>=20
> My questions are the following:
>=20
> 1. Is there a way to see how much CPU the XDP program is using or the loa=
d of
> the NIC? To my understanding, you cannot tell the XDP program's CPU usage
> based off of something like `top` or `htop` due to that being in the user
> space (XDP happens at the NIC driver level in the kernel IIRC).

I am newbie in XDP too, maybe Linux=20
Perf http://www.brendangregg.com/perf.html tool could help you figuring=20
out which part of the code in your XDP app consuming CPU cycles (debug=20
symbol needed)
