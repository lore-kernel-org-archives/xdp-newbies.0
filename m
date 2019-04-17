Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pl1-f194.google.com ([209.85.214.194]:34209 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729939AbfDQNVs (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 17 Apr 2019 09:21:48 -0400
Received: by mail-pl1-f194.google.com with SMTP id y6so12068611plt.1
        for <xdp-newbies@vger.kernel.org>; Wed, 17 Apr 2019 06:21:48 -0700 (PDT)
Subject: Re: XDP chain using tail calls
References: <CAM-scZOqYquo2X94K0x9FQc4iGwWODuLXKxhAatn5g2H6+ZhQA@mail.gmail.com>
From: Taeung Song <treeze.taeung@gmail.com>
Message-ID: <1ea61f36-7270-9f94-2485-ba7257464432@gmail.com>
Date: Wed, 17 Apr 2019 22:21:44 +0900
MIME-Version: 1.0
In-Reply-To: <CAM-scZOqYquo2X94K0x9FQc4iGwWODuLXKxhAatn5g2H6+ZhQA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Radu Stoenescu <radu.stoe@gmail.com>, xdp-newbies@vger.kernel.org

Hi Radu Stoenescu,

You can run 'BPF tail call' examples at samples/bpf of kernel source
That are sockex3_kern.c or tracex5_kern.c
I think it'd be better to understand it if running tracex5
that just uses bpf_tail_call() helper function for a BPF prog
depending on syscall number.

Thanks,
Taeung

On 4/17/19 10:11 PM, Radu Stoenescu wrote:
> Hello
> 
> I was recently reading through the XDP documentation from Cilium[1]
> and I couldn't really wrap my head around the tail cal section.
> 
> Is there any tutorial/code example of using this feature with XDP?
> 
> Regards
> 
