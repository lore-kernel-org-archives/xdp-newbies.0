Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-wr0-f172.google.com ([209.85.128.172]:37934 "EHLO
        mail-wr0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751981AbdIHA5i (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Thu, 7 Sep 2017 20:57:38 -0400
Received: by mail-wr0-f172.google.com with SMTP id 108so1997324wra.5
        for <xdp-newbies@vger.kernel.org>; Thu, 07 Sep 2017 17:57:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABUc5FHPNjdauR-0OuK=P=Uvx81puBZ+cjnX6sMXDZQguCaAiw@mail.gmail.com>
References: <CABUc5FF3Lx=7ECCT_bzxcbKHkXX1Vs66KJHabJExqTJ8Bz0VgA@mail.gmail.com>
 <CAC1LvL0kQqKJtqo-ea1qonvKVbKaUkhk=QUSBZCVhmoC+tbCZQ@mail.gmail.com> <CABUc5FHPNjdauR-0OuK=P=Uvx81puBZ+cjnX6sMXDZQguCaAiw@mail.gmail.com>
From: Zvi Effron <zeffron@riotgames.com>
Date: Thu, 7 Sep 2017 17:57:36 -0700
Message-ID: <CAC1LvL3EfNhPL2jmQtuWk+L+WLVrjXEVmckVgQrv8OOrgH_jBg@mail.gmail.com>
Subject: Re: Accessing userspace created persistent eBPF maps from kernel bpf
 restricted C
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Kiran T <kiran.lkml@gmail.com>
Cc: xdp-newbies@vger.kernel.org

> What I am really trying to do is to be able to access an eBPF hashmap or array
> created and pinned by a userspace program *after* the bpf program has
> been loaded, from
> the bpf code.

Can you elaborate on your use case a little bit?

Thanks!
--Zvi
