Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:38385 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750711AbdHaEOy (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 31 Aug 2017 00:14:54 -0400
Received: by mail-wm0-f41.google.com with SMTP id 187so12362314wmn.1
        for <xdp-newbies@vger.kernel.org>; Wed, 30 Aug 2017 21:14:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170830210619.6a97c0d0@cakuba.netronome.com>
References: <20170830210619.6a97c0d0@cakuba.netronome.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Wed, 30 Aug 2017 21:14:33 -0700
Message-ID: <CAADnVQ+O=a7Q5cxOxkkrVi09VyF+4u+ScV7F8TtZ2qAEL1a2aA@mail.gmail.com>
Subject: Re: BPF assembler?
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jakub Kicinski <kubakici@wp.pl>
Cc: xdp-newbies@vger.kernel.org

On Wed, Aug 30, 2017 at 9:06 PM, Jakub Kicinski <kubakici@wp.pl> wrote:
> Hi!
>
> Is there any way to write eBPF programs in some form of an assembly
> language?

was Dave's gnu asm upstreamed? I lost the track while away...
llvm assembler is almost there too, but it needs some work.
