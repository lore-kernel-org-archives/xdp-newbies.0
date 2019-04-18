Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-lf1-f68.google.com ([209.85.167.68]:45171 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390536AbfDRSau (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 18 Apr 2019 14:30:50 -0400
Received: by mail-lf1-f68.google.com with SMTP id t11so2331986lfl.12
        for <xdp-newbies@vger.kernel.org>; Thu, 18 Apr 2019 11:30:48 -0700 (PDT)
Date: Thu, 18 Apr 2019 21:30:44 +0300
From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: Re: [RFC PATCH 3/3] net: ethernet: ti: cpsw: add XDP support
Message-ID: <20190418183043.GD27879@khorivan>
References: <20190417174942.11811-1-ivan.khoronzhuk@linaro.org>
 <20190417174942.11811-4-ivan.khoronzhuk@linaro.org>
 <CAJpBn1y0odvL97-kP5yzKC+tN=fx178nxigfBfDwXhRhPRvDuQ@mail.gmail.com>
 <20190418094008.GB27879@khorivan>
 <20190418104111.559a0e74@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190418104111.559a0e74@cakuba.netronome.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jakub Kicinski <jakub.kicinski@netronome.com>
Cc: grygorii.strashko@ti.com, linux-omap@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Linux Netdev List <netdev@vger.kernel.org>, ilias.apalodimas@linaro.org, hawk@kernel.org, xdp-newbies@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>, aniel@iogearbox.net, John Fastabend <john.fastabend@gmail.com>

On Thu, Apr 18, 2019 at 10:41:11AM -0700, Jakub Kicinski wrote:
>On Thu, 18 Apr 2019 12:40:10 +0300, Ivan Khoronzhuk wrote:
>> >work?  The stack's TX ring has a lock, and can be used from any CPU,
>> >while XDP TX rings are per-PCU, no?
>> Yes and no.
>> am572 has more queues then CPU num, How I can choose tx queue not based on CPU
>> num? It's always shared and has to have lock, and cpdma is done in this way.
>
>Oh, I see, you already have another lock.
>
>> Here another thing bothering me, I send it to queue 0 always, instead of
>> taking cpu num. Not sure about this, but I expect to have some tx queue
>> not bind to cpu and didn't find a way it can be changed dynamically in
>> redirect.
>
>Not sure I understand :)

I mean, is there a capability to choose tx queue while XDP_REDIRECT or XDP_TX.

From what I've seen it's taken by:
qidx = smp_processor_id();

What if I need to send classified traffic to hw queue 4 for instance...

-- 
Regards,
Ivan Khoronzhuk
