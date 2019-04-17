Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-ed1-f66.google.com ([209.85.208.66]:43017 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729453AbfDQN1f (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 17 Apr 2019 09:27:35 -0400
Received: by mail-ed1-f66.google.com with SMTP id j20so10765950edq.10
        for <xdp-newbies@vger.kernel.org>; Wed, 17 Apr 2019 06:27:34 -0700 (PDT)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: XDP chain using tail calls
In-Reply-To: <1ea61f36-7270-9f94-2485-ba7257464432@gmail.com>
References: <CAM-scZOqYquo2X94K0x9FQc4iGwWODuLXKxhAatn5g2H6+ZhQA@mail.gmail.com> <1ea61f36-7270-9f94-2485-ba7257464432@gmail.com>
Date: Wed, 17 Apr 2019 14:27:32 +0100
Message-ID: <87r2a0rccb.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Taeung Song <treeze.taeung@gmail.com>, Radu Stoenescu <radu.stoe@gmail.com>, xdp-newbies@vger.kernel.org

Taeung Song <treeze.taeung@gmail.com> writes:

> Hi Radu Stoenescu,
>
> You can run 'BPF tail call' examples at samples/bpf of kernel source
> That are sockex3_kern.c or tracex5_kern.c
> I think it'd be better to understand it if running tracex5
> that just uses bpf_tail_call() helper function for a BPF prog
> depending on syscall number.

Oh, there are actually some of the samples that include tail calls.
Guess my grepping foo failed me... Cool :)

-Toke
