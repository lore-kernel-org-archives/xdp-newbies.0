Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726076AbgDYQfG (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Sat, 25 Apr 2020 12:35:06 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 593D9C09B04D
        for <xdp-newbies@vger.kernel.org>; Sat, 25 Apr 2020 09:35:06 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id g74so13535097qke.13
        for <xdp-newbies@vger.kernel.org>; Sat, 25 Apr 2020 09:35:06 -0700 (PDT)
Date: Sat, 25 Apr 2020 12:34:58 -0400
From: Sowmini Varadhan <sowmini05@gmail.com>
Subject: Re: building eBPF
Message-ID: <20200425163458.GB455@gmail.com>
References: <20200425122225.GA455@gmail.com>
 <20200425145619.4405a50d@carbon>
MIME-Version: 1.0
In-Reply-To: <20200425145619.4405a50d@carbon>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
To: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>

On (04/25/20 14:56), Jesper Dangaard Brouer wrote:
> 
> The kernel's samples/bpf/ should still builds with LLVM-9 (and lower).
> Follow instructions in the README.rst file[1].
> 
> There are pre-build Debian and Ubuntu packages for LLVM-10 here:
>  https://apt.llvm.org/

thanks that helped me install llvm-10

However, after all my adventures, I  end up with
# ls /usr/bin/llc*
/usr/bin/llc  /usr/bin/llc-10  /usr/bin/llc-5.0  /usr/bin/llc-6.0  /usr/bin/llc-7
and the default points at 6.0 so I had to go and tweak Makefile
to use clang-10 and llc-10

After that, samples builds and runs (thanks for that hint!).
But not selftests.  However, samples is good enough for my experiments,
for now.

> I suggest you start with the XDP-tutorial[2], it (still) works with older
> LLVM versions: [2] https://github.com/xdp-project/xdp-tutorial

will do.  

--Sowmini
