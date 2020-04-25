Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726076AbgDYQQk (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Sat, 25 Apr 2020 12:16:40 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87A8BC09B04D
        for <xdp-newbies@vger.kernel.org>; Sat, 25 Apr 2020 09:16:40 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id e9so13971496iok.9
        for <xdp-newbies@vger.kernel.org>; Sat, 25 Apr 2020 09:16:40 -0700 (PDT)
Subject: Re: building eBPF
References: <20200425122225.GA455@gmail.com> <20200425145619.4405a50d@carbon>
From: David Ahern <dsahern@gmail.com>
Message-ID: <aedacef2-25ee-7a46-cd5c-4aba448db68b@gmail.com>
Date: Sat, 25 Apr 2020 10:16:37 -0600
MIME-Version: 1.0
In-Reply-To: <20200425145619.4405a50d@carbon>
Content-Language: en-US
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Jesper Dangaard Brouer <brouer@redhat.com>, Sowmini Varadhan <sowmini05@gmail.com>
Cc: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>

On 4/25/20 6:56 AM, Jesper Dangaard Brouer wrote:
>> I am trying to get some basic eBPF examples up and running and I ran
>> into the problem you describe at https://lkml.org/lkml/2020/2/19/433
> 
> Yes, building kernel bpf selftests requires latest LLVM, currently
> works with LLVM-10.
> 

ubuntu 20.04 was just released, and it has llvm-10. I have been using it
to build and run the bpf selftests.
