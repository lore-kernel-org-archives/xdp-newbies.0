Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:39872 "EHLO
        mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750783AbdK2Fi2 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 29 Nov 2017 00:38:28 -0500
Received: by mail-oi0-f53.google.com with SMTP id r63so1636147oia.6
        for <xdp-newbies@vger.kernel.org>; Tue, 28 Nov 2017 21:38:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171128213849.380ac926@redhat.com>
References: <CAM7NYTgW1AnJ0C4H2YiXOegp0p3BHCtU5bB7WfbcDTvaYzHJmw@mail.gmail.com>
 <20171128120229.16c0009c@redhat.com> <CAM7NYTiMU9JL0WxnAuaYhWsy4JebC06mLvC=NFVCB2r=ZFekLw@mail.gmail.com>
 <20171128213849.380ac926@redhat.com>
From: Gilad Ben-Yossef <gilad@benyossef.com>
Date: Wed, 29 Nov 2017 07:38:27 +0200
Message-ID: <CAOtvUMeJPzcqo2H37bhJZ1Fsr+ucG9L+-fG1CiLigXL946QKbA@mail.gmail.com>
Subject: Re: XDP on many-core NPU
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: "MD I. Islam" <tamim@csebuet.org>, xdp-newbies@vger.kernel.org, Gilad Ben Yossef <giladby@mellanox.com>

Hi,

On Tue, Nov 28, 2017 at 10:38 PM, Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
> On Tue, 28 Nov 2017 15:00:04 -0500 "MD I. Islam" <tamim@csebuet.org> wrote:
>
>> On Tue, Nov 28, 2017 at 6:02 AM, Jesper Dangaard Brouer
>> <brouer@redhat.com> wrote:
>> >
>> > On Mon, 27 Nov 2017 18:33:10 -0500 "MD I. Islam" <tamim@csebuet.org> wrote:
>> >
>> >> I was wondering if XDP can scale to many-core NPU (such as NPS-400
>> >> which has 256 cores)? I need to develop a XCP/RCP like application
>> >> that can achieve bare-metal performance on each core. The application
>> >> will run in a run-to-completion model. I see, DPDK can run userspace
>> >> application on each core. I'm wondering if XDP has anything like that?
>> >> Please let me know any suggestion.
>> >
>> > Hi Tamim,
>> >
>> > I think you are mixing up things a bit here...
>> >
>> > You mention a specific NIC (NPS-400) which have many cores inside the
>> > NIC.  You need to understand XDP is a software solution, where the
>> > programming language is eBPF.  XDP does NOT run inside the NIC, instead
>> > XDP runs as the earliest possible step in the Linux kernel network stack.
>> >
>> > The only NIC that does hardware offloading of XDP is Netronome[1], see
>> > their white papers[2].
>>
>> Hi Jesper
>>
>> I was looking at
>> http://events.linuxfoundation.org/sites/events/files/slides/Massively_Multi-Core_LPC_2013.pdf.
>> It looks like the NPS-400 NIC also runs an embedded Linux itself. The
>> packets are processed by the embedded ARC processor. Packets
>> processing however is done at userspace. They also use DPDK-like
>> framework OpenNPU/NPS SDK to bypass the kernel. Is it possible to
>> achieve something similar to using XDP? Please let me know if I'm
>> getting anything wrong. I'm not sure if it is possible for me (a
>> third party developer/PhD student) to load a customized Linux on the
>> their NIC.
>
> You should ask Gilad Ben-Yossef (Cc'ed), if he can help you getting XDP
> working on this NIC? ;-)

The NPS-400 wasn't a NIC but a network processor designed for a router
and anyway AFAIK, Mellanox (who purchased EZchip) killed this product
line.
You might find their BlueField based NIC more suitable for what you want.

I no longer work for Mellanox :-)

Gilad

-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
