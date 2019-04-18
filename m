Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qt1-f194.google.com ([209.85.160.194]:36811 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388450AbfDRRlS (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 18 Apr 2019 13:41:18 -0400
Received: by mail-qt1-f194.google.com with SMTP id s15so3080387qtn.3
        for <xdp-newbies@vger.kernel.org>; Thu, 18 Apr 2019 10:41:18 -0700 (PDT)
Date: Thu, 18 Apr 2019 10:41:11 -0700
From: Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: Re: [RFC PATCH 3/3] net: ethernet: ti: cpsw: add XDP support
Message-ID: <20190418104111.559a0e74@cakuba.netronome.com>
In-Reply-To: <20190418094008.GB27879@khorivan>
References: <20190417174942.11811-1-ivan.khoronzhuk@linaro.org>
        <20190417174942.11811-4-ivan.khoronzhuk@linaro.org>
        <CAJpBn1y0odvL97-kP5yzKC+tN=fx178nxigfBfDwXhRhPRvDuQ@mail.gmail.com>
        <20190418094008.GB27879@khorivan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc: grygorii.strashko@ti.com, linux-omap@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Linux Netdev List <netdev@vger.kernel.org>, ilias.apalodimas@linaro.org, hawk@kernel.org, xdp-newbies@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>, aniel@iogearbox.net, John Fastabend <john.fastabend@gmail.com>

On Thu, 18 Apr 2019 12:40:10 +0300, Ivan Khoronzhuk wrote:
> >work?  The stack's TX ring has a lock, and can be used from any CPU,
> >while XDP TX rings are per-PCU, no?  
> Yes and no.
> am572 has more queues then CPU num, How I can choose tx queue not based on CPU
> num? It's always shared and has to have lock, and cpdma is done in this way.

Oh, I see, you already have another lock.

> Here another thing bothering me, I send it to queue 0 always, instead of
> taking cpu num. Not sure about this, but I expect to have some tx queue
> not bind to cpu and didn't find a way it can be changed dynamically in
> redirect.

Not sure I understand :)
