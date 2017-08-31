Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:41806 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750973AbdHaE6X (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 31 Aug 2017 00:58:23 -0400
Date: Wed, 30 Aug 2017 21:58:22 -0700 (PDT)
Message-Id: <20170830.215822.864489286642298311.davem@davemloft.net>
Subject: Re: BPF assembler?
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAADnVQ+O=a7Q5cxOxkkrVi09VyF+4u+ScV7F8TtZ2qAEL1a2aA@mail.gmail.com>
References: <20170830210619.6a97c0d0@cakuba.netronome.com>
        <CAADnVQ+O=a7Q5cxOxkkrVi09VyF+4u+ScV7F8TtZ2qAEL1a2aA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: alexei.starovoitov@gmail.com
Cc: kubakici@wp.pl, xdp-newbies@vger.kernel.org

From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Wed, 30 Aug 2017 21:14:33 -0700

> On Wed, Aug 30, 2017 at 9:06 PM, Jakub Kicinski <kubakici@wp.pl> wrote:
>> Hi!
>>
>> Is there any way to write eBPF programs in some form of an assembly
>> language?
> 
> was Dave's gnu asm upstreamed? I lost the track while away...
> llvm assembler is almost there too, but it needs some work.

No, I never was able to move forward on that unfortunately.
