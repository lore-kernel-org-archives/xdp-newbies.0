Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pg1-f194.google.com ([209.85.215.194]:33428 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394115AbgAPRoQ (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 16 Jan 2020 12:44:16 -0500
Received: by mail-pg1-f194.google.com with SMTP id 6so10260809pgk.0
        for <xdp-newbies@vger.kernel.org>; Thu, 16 Jan 2020 09:44:15 -0800 (PST)
From: Vincent Li <mchun.li@gmail.com>
Date: Thu, 16 Jan 2020 09:44:13 -0800 (PST)
Subject: Re: XDP invalid memory access
In-Reply-To: <20200116022459.GA2853@ranger.igk.intel.com>
Message-ID: <alpine.OSX.2.21.2001160937570.5059@jiadeimac.local>
References: <CAK86TEf+GY3F8resRW11DNvate5uqSsh=JAQuJHhBuL0sQpvjg@mail.gmail.com> <20200116022459.GA2853@ranger.igk.intel.com>
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
To: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc: xdp-newbies@vger.kernel.org, daniel@iogearbox.net, andriin@fb.com, dsahern@gmail.com



On Thu, 16 Jan 2020, Maciej Fijalkowski wrote:

>=20
> I see that optlen is a global variable. This line might be valid but
> you're using iproute2's loader for your XDP program, right? AFAIK it
> doesn't have support for BPF global variables, only libbpf does (Daniel,
> Andrii? is that true?).
>=20
> So you have to either make the optlen a local variable or go with writing
> the loader part that is based on libbpf usage (see samples/bpf directory
> in kernel tree, for example xdp1_user.c).

ok I will try use optlen as local variable or use libbpf

>=20
> Could you next time try a little better with the format of data you're
> providing? I'm pretty sure other folks would have spotted earlier that
> optlen is global if the code was properly formatted :)

I am using gmail from chrome browser in plain text mode, seems still not=20
good with the text format. I switched to alpine now, not sure I have the=20
proper alpine setting, let me know next time if you still see not properly=
=20
format :)
