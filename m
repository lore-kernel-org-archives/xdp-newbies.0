Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pg1-f194.google.com ([209.85.215.194]:40938 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389523AbgAPS6W (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 16 Jan 2020 13:58:22 -0500
Received: by mail-pg1-f194.google.com with SMTP id k25so10357604pgt.7
        for <xdp-newbies@vger.kernel.org>; Thu, 16 Jan 2020 10:58:21 -0800 (PST)
From: Vincent Li <mchun.li@gmail.com>
Date: Thu, 16 Jan 2020 10:58:19 -0800 (PST)
Subject: Re: XDP invalid memory access
In-Reply-To: <20200116022459.GA2853@ranger.igk.intel.com>
Message-ID: <alpine.OSX.2.21.2001161044590.5400@jiadeimac.local>
References: <CAK86TEf+GY3F8resRW11DNvate5uqSsh=JAQuJHhBuL0sQpvjg@mail.gmail.com> <20200116022459.GA2853@ranger.igk.intel.com>
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
To: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc: Vincent Li <mchun.li@gmail.com>, xdp-newbies@vger.kernel.org, daniel@iogearbox.net, andriin@fb.com, dsahern@gmail.com



On Thu, 16 Jan 2020, Maciej Fijalkowski wrote:

>=20
> I see that optlen is a global variable. This line might be valid but
> you're using iproute2's loader for your XDP program, right? AFAIK it
> doesn't have support for BPF global variables, only libbpf does (Daniel,
> Andrii? is that true?).
>=20

move optlen to local variable resolves the iproute2 loading problem. I=20
tried libbpf way (xdp-loader load enp3s0 tcp_option.o) from=20
https://github.com/xdp-project/xdp-tools to load the program, but it=20
failed with "Couldn't load BPF program: Relocation failed". I will have=20
more detail in email respond to Toke. =20
