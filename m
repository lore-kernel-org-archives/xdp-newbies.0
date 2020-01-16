Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-ed1-f47.google.com ([209.85.208.47]:33491 "EHLO
        mail-ed1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729195AbgAPBep (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 15 Jan 2020 20:34:45 -0500
Received: by mail-ed1-f47.google.com with SMTP id r21so17420141edq.0
        for <xdp-newbies@vger.kernel.org>; Wed, 15 Jan 2020 17:34:44 -0800 (PST)
MIME-Version: 1.0
References: <CAK86TEf+GY3F8resRW11DNvate5uqSsh=JAQuJHhBuL0sQpvjg@mail.gmail.com>
 <87ftggtl7t.fsf@toke.dk> <CAK86TEcyRqVrB-OOiCxtM6WLMp-Sr_+eO9G70+T=OMpF2KBrgQ@mail.gmail.com>
 <99fe90fe-cbb4-1ff1-156b-bd8053293aca@gmail.com>
In-Reply-To: <99fe90fe-cbb4-1ff1-156b-bd8053293aca@gmail.com>
From: Vincent Li <mchun.li@gmail.com>
Date: Wed, 15 Jan 2020 17:34:32 -0800
Message-ID: <CAK86TEcGAkmPLeYACWGtLT0CJPZqGYCqZDpZSO=0x4_ph0qcUA@mail.gmail.com>
Subject: Re: XDP invalid memory access
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: David Ahern <dsahern@gmail.com>
Cc: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>, xdp-newbies@vger.kernel.org

thank you! I will try that

On Wed, Jan 15, 2020 at 4:40 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 1/15/20 3:31 PM, Vincent Li wrote:
> > On Wed, Jan 15, 2020 at 2:21 PM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
> >
> >> You have to check that you're not reading out of bounds before
> >> dereferencing the bytes in the TCP header...
> >>
> >
> > I have below before the optlen
> >
> >    47 /* sanity check needed by the eBPF verifier */
> >
> >     48 if ((void *)(tcphdr + 1) > data_end)
> >
> >     49 return 0;
> >
> > this is not enough, how do I check the out of bounds properly?
> >
>
> options are optional and after 'struct tcphdr' you need to do something
> like:
>
>    if ((void *)(tcphdr + 1) + tcphdr->doff > data_end)
>        return XDP_....
