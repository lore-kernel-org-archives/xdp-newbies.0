Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-oi1-f196.google.com ([209.85.167.196]:42328 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732716AbgBUILm (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 21 Feb 2020 03:11:42 -0500
Received: by mail-oi1-f196.google.com with SMTP id j132so775641oih.9
        for <xdp-newbies@vger.kernel.org>; Fri, 21 Feb 2020 00:11:42 -0800 (PST)
MIME-Version: 1.0
References: <CALDO+SZmCxtWCeqh93HO6vm1KHh_UGxMby+td2ba_o66ZT+MVQ@mail.gmail.com>
In-Reply-To: <CALDO+SZmCxtWCeqh93HO6vm1KHh_UGxMby+td2ba_o66ZT+MVQ@mail.gmail.com>
From: Magnus Karlsson <magnus.karlsson@gmail.com>
Date: Fri, 21 Feb 2020 09:11:30 +0100
Message-ID: <CAJ8uoz1UiYDFNPpv7iq0QDGCBGZ-GZwY8jtxO6StWwr5Ht6WTQ@mail.gmail.com>
Subject: Re: xdpsock poll syscall CPU 100%
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
To: William Tu <u9012063@gmail.com>
Cc: Xdp <xdp-newbies@vger.kernel.org>, "Karlsson, Magnus" <magnus.karlsson@intel.com>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>

On Thu, Feb 20, 2020 at 11:50 PM William Tu <u9012063@gmail.com> wrote:
>
> Hi,
>
> I'm trying to save some CPU cycles when there is no packet arrives.
> I enable the poll syscall option of xdpsock, by doing
>
> $ ./xdpsock -r -p -S -i ens16
>  sock0@ens160:0 rxdrop xdp-skb poll()
>                 pps         pkts        1.00
> rx              0           0
> tx              0           0
>
> Since there is no packet coming, I though by calling poll()
> system call, the xdpsock process will be blocked and CPU utilization
> should be way under 100%. However, I'm still seeing 100%
> CPU utilization. Am I understanding this correctly?

Yes, something seems to be wrong here. Calling poll() should put you
in sleep for the timeout period, here 1000 ms. Let me take a look at
it. What version of the kernel are you running?

/Magnus

> Thanks,
> William
