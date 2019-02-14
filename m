Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-lj1-f193.google.com ([209.85.208.193]:38750 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387671AbfBNVht (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 14 Feb 2019 16:37:49 -0500
Received: by mail-lj1-f193.google.com with SMTP id j19so5795932ljg.5
        for <xdp-newbies@vger.kernel.org>; Thu, 14 Feb 2019 13:37:48 -0800 (PST)
MIME-Version: 1.0
References: <96e834867100a5ae9a941c639ef93456a2600021.camel@regit.org> <509b74cb74f13b02122707d2505e5c690866b159.camel@regit.org>
In-Reply-To: <509b74cb74f13b02122707d2505e5c690866b159.camel@regit.org>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Thu, 14 Feb 2019 13:37:35 -0800
Message-ID: <CAADnVQ+5KbWJqwOWVGGBwfX7h+1r7287452_Scrud8N8iR3Gow@mail.gmail.com>
Subject: Re: Interruption in eBPF program after kernel update
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Eric Leblond <eric@regit.org>, Daniel Borkmann <daniel@iogearbox.net>
Cc: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>

On Thu, Feb 14, 2019 at 10:33 AM Eric Leblond <eric@regit.org> wrote:
>
> Hello,
>
> On Wed, 2019-02-13 at 20:46 +0100, Eric Leblond wrote:
> > Hello,
> >
> > I've got a simple socket filter program that seems to interrupt when
> > calling the load_word construct. I'm seeing the first message but
> > never
> > the second one.
> >
> > The code is the following
> >
> > int SEC("filter") hashfilter(struct __sk_buff *skb) {
> >     __u32 nhoff = BPF_LL_OFF + ETH_HLEN;
>
> So it seems the problem was coming from this line. Removing BPF_LL_OFF
> fixes the problem for kernel starting 4.18.
>
> Is this a known issue ?
>
> Is there something that would allow a BPF file to work independently of
> the kernel version ?

Daniel,
can this be related to removal of ld_abs legacy ?
