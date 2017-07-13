Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:35553 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751350AbdGMVHi (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 13 Jul 2017 17:07:38 -0400
Received: from mfilter10-d.gandi.net (mfilter10-d.gandi.net [217.70.178.139])
        by relay4-d.mail.gandi.net (Postfix) with ESMTP id AAA79172095
        for <xdp-newbies@vger.kernel.org>; Thu, 13 Jul 2017 23:07:31 +0200 (CEST)
Received: from relay4-d.mail.gandi.net ([IPv6:::ffff:217.70.183.196])
        by mfilter10-d.gandi.net (mfilter10-d.gandi.net [::ffff:10.0.15.180]) (amavisd-new, port 10024)
        with ESMTP id DDmWsCmH7DVH for <xdp-newbies@vger.kernel.org>;
        Thu, 13 Jul 2017 23:07:30 +0200 (CEST)
Received: from mail-oi0-f54.google.com (mail-oi0-f54.google.com [209.85.218.54])
        (Authenticated sender: joe@ovn.org)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id D300017209B
        for <xdp-newbies@vger.kernel.org>; Thu, 13 Jul 2017 23:07:29 +0200 (CEST)
Received: by mail-oi0-f54.google.com with SMTP id 191so56692428oii.2
        for <xdp-newbies@vger.kernel.org>; Thu, 13 Jul 2017 14:07:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5967DBC3.5060509@iogearbox.net>
References: <1667638588.29757437.1499974457843.JavaMail.zimbra@ulg.ac.be> <5967DBC3.5060509@iogearbox.net>
From: Joe Stringer <joe@ovn.org>
Date: Thu, 13 Jul 2017 14:07:07 -0700
Message-ID: <CAPWQB7Gb12L6FuP5LbVUXQLodzdv3j_T2FO57gCz17ZE1ktidQ@mail.gmail.com>
Subject: Re: XDP for Kernel by-pass?
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Daniel Borkmann <daniel@iogearbox.net>
Cc: tom.barbette@ulg.ac.be, xdp-newbies@vger.kernel.org

On 13 July 2017 at 13:44, Daniel Borkmann <daniel@iogearbox.net> wrote:
> On 07/13/2017 09:34 PM, tom.barbette@ulg.ac.be wrote:
>>
>> Hi all,
>>
>> Can XDP be used for "skbuff bypass"? Like a rx_handler but closer to the
>> driver? I'm not very familiar with eBPF, could it be used to pass the kernel
>> to any kernel module or userspace application?
>>
>> It looks to me that bpf_func in struct bpf_prog could be any function that
>> we could use to deviate XDP and use it for that purpose. Correct?
>>
>> Kernel app like Click or OVS could benefit from that as they don't use
>> most skbuff facilities.
>
>
> You can do a lot of things with eBPF already e.g. take a look at the kernel
> BPF sample code or BPF selftests e.g. test_l4lb.c, test_xdp.c, etc, or
> projects like cilium that get compiled from C to BPF bytecode. BPF and XDP
> is heavily tied together and part of the core kernel, so modular code/hooks
> like third party kernel modules are not possible. Also f.e. wrt to user
> space
> one of the use cases is that you don't need to cross boundaries in the first
> place when you preprocess in XDP and e.g. apply policy to drop unrelated
> packets early while remaining ones are forwarded to containers, etc. There's
> wip to have an OVS data path in BPF/XDP. I currently don't find the slides,
> but Quentin did a good coverage on it from the last workshop [1], so worth
> to read up a bit on the topic.
>
>   [1]
> https://qmonnet.github.io/whirl-offload/2017/03/03/iovisor-summit-summary/

Right, from OVS perspective this is a pretty good summary of the
current state: it's still an uphill battle with regards to verifier
complexity, and there's reasonably large unsolved problems such as
connection tracking; megaflows isn't there; and we haven't got to a
point where we can observe performance parity with existing in-kernel
solutions yet. That's just things we're aware of right now. In some
perfect would it would be simple as dragging and dropping existing
kernel code into the eBPF environment, but I'm sure that one of the
first things you'll learn on this xdp-newbies list is that everything
you want to put in eBPF/XDP needs to be rewritten from scratch with
the verifier in mind.
