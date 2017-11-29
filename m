Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pg0-f51.google.com ([74.125.83.51]:46607 "EHLO
        mail-pg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751363AbdK2IC4 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 29 Nov 2017 03:02:56 -0500
Received: by mail-pg0-f51.google.com with SMTP id b11so1156037pgu.13
        for <xdp-newbies@vger.kernel.org>; Wed, 29 Nov 2017 00:02:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOtvUMet3z4qFubyO7iDunGeD1fi_mRdOKeih0qM0bzKqcTpGA@mail.gmail.com>
References: <CAM7NYTgW1AnJ0C4H2YiXOegp0p3BHCtU5bB7WfbcDTvaYzHJmw@mail.gmail.com>
 <20171128120229.16c0009c@redhat.com> <CAM7NYTiMU9JL0WxnAuaYhWsy4JebC06mLvC=NFVCB2r=ZFekLw@mail.gmail.com>
 <20171128213849.380ac926@redhat.com> <CAOtvUMet3z4qFubyO7iDunGeD1fi_mRdOKeih0qM0bzKqcTpGA@mail.gmail.com>
From: "MD I. Islam" <tamim@csebuet.org>
Date: Wed, 29 Nov 2017 03:02:34 -0500
Message-ID: <CAM7NYTiZWwve8s7PNLDNH24LFb2jXSarLXqkfUb_tN5MtmLEUQ@mail.gmail.com>
Subject: Re: XDP on many-core NPU
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Gilad Ben-Yossef <gilad@benyossef.com>, Andy Gospodarek <andy@greyhouse.net>, Edwin Peer <edwin.peer@netronome.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>, xdp-newbies@vger.kernel.org, Gilad Ben Yossef <giladby@mellanox.com>

Yeah, I actually need a network processor (NPU) where I can run Linux.
Something like NPS-400, Ericsson  SNP 4000 or Freescale T4240. A
Ericsson research paper [1] also designed a hypothetical a 256 core
ARM Cortex-m3 based NPU. Do you know of any many-core NPU based
development board where I can install linux?

1. http://conferences.sigcomm.org/sigcomm/2013/papers/hotsdn/p103.pdf

Many thanks for the help!!

On Wed, Nov 29, 2017 at 12:37 AM, Gilad Ben-Yossef <gilad@benyossef.com> wrote:
> Hi,
>
> On Tue, Nov 28, 2017 at 10:38 PM, Jesper Dangaard Brouer <brouer@redhat.com>
> wrote:
>>
>>
>> On Tue, 28 Nov 2017 15:00:04 -0500 "MD I. Islam" <tamim@csebuet.org>
>> wrote:
>>
>> > On Tue, Nov 28, 2017 at 6:02 AM, Jesper Dangaard Brouer
>> > <brouer@redhat.com> wrote:
>> > >
>> > > On Mon, 27 Nov 2017 18:33:10 -0500 "MD I. Islam" <tamim@csebuet.org>
>> > > wrote:
>> > >
>> > >> I was wondering if XDP can scale to many-core NPU (such as NPS-400
>> > >> which has 256 cores)? I need to develop a XCP/RCP like application
>> > >> that can achieve bare-metal performance on each core. The application
>> > >> will run in a run-to-completion model. I see, DPDK can run userspace
>> > >> application on each core. I'm wondering if XDP has anything like
>> > >> that?
>> > >> Please let me know any suggestion.
>> > >
>> > > Hi Tamim,
>> > >
>> > > I think you are mixing up things a bit here...
>> > >
>> > > You mention a specific NIC (NPS-400) which have many cores inside the
>> > > NIC.  You need to understand XDP is a software solution, where the
>> > > programming language is eBPF.  XDP does NOT run inside the NIC,
>> > > instead
>> > > XDP runs as the earliest possible step in the Linux kernel network
>> > > stack.
>> > >
>> > > The only NIC that does hardware offloading of XDP is Netronome[1], see
>> > > their white papers[2].
>> >
>> > Hi Jesper
>> >
>> > I was looking at
>> >
>> > http://events.linuxfoundation.org/sites/events/files/slides/Massively_Multi-Core_LPC_2013.pdf.
>> > It looks like the NPS-400 NIC also runs an embedded Linux itself. The
>> > packets are processed by the embedded ARC processor. Packets
>> > processing however is done at userspace. They also use DPDK-like
>> > framework OpenNPU/NPS SDK to bypass the kernel. Is it possible to
>> > achieve something similar to using XDP? Please let me know if I'm
>> > getting anything wrong. I'm not sure if it is possible for me (a
>> > third party developer/PhD student) to load a customized Linux on the
>> > their NIC.
>>
>> You should ask Gilad Ben-Yossef (Cc'ed), if he can help you getting XDP
>> working on this NIC? ;-)
>>
>>
> The NPS-400 wasn't a NIC but a network processor designed for a router and
> anyway AFAIK, Mellanox (who purchased EZchip) killed this product line.
> You might find their BlueField based NIC more suitable for what you want.
>
> I no longer work for Mellanox :-)
>
> Gilad
>
>
> --
> Gilad Ben-Yossef
> Chief Coffee Drinker
>
> "If you take a class in large-scale robotics, can you end up in a situation
> where the homework eats your dog?"
>  -- Jean-Baptiste Queru
