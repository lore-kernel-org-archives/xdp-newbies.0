Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qt1-f194.google.com ([209.85.160.194]:36156 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729939AbfDQNb2 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 17 Apr 2019 09:31:28 -0400
Received: by mail-qt1-f194.google.com with SMTP id s15so27328071qtn.3
        for <xdp-newbies@vger.kernel.org>; Wed, 17 Apr 2019 06:31:27 -0700 (PDT)
MIME-Version: 1.0
References: <CAM-scZOqYquo2X94K0x9FQc4iGwWODuLXKxhAatn5g2H6+ZhQA@mail.gmail.com>
 <1ea61f36-7270-9f94-2485-ba7257464432@gmail.com> <87r2a0rccb.fsf@toke.dk>
In-Reply-To: <87r2a0rccb.fsf@toke.dk>
From: Radu Stoenescu <radu.stoe@gmail.com>
Date: Wed, 17 Apr 2019 16:31:16 +0300
Message-ID: <CAM-scZNQw-VZzQbLr9eaDuicgdNQisZy9dhT=otNgXb3j_+cfw@mail.gmail.com>
Subject: Re: XDP chain using tail calls
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc: Taeung Song <treeze.taeung@gmail.com>, xdp-newbies@vger.kernel.org

Thank you!

If you think this might be useful, I could bring it to the xdp-tutorial rep=
o.

It's a bit tricky to find those, I did managed to find the in the
meantime via the kernel commit that introduced them:
https://lwn.net/Articles/645169/

Best,
Radu

On Wed, Apr 17, 2019 at 4:27 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Taeung Song <treeze.taeung@gmail.com> writes:
>
> > Hi Radu Stoenescu,
> >
> > You can run 'BPF tail call' examples at samples/bpf of kernel source
> > That are sockex3_kern.c or tracex5_kern.c
> > I think it'd be better to understand it if running tracex5
> > that just uses bpf_tail_call() helper function for a BPF prog
> > depending on syscall number.
>
> Oh, there are actually some of the samples that include tail calls.
> Guess my grepping foo failed me... Cool :)
>
> -Toke



--=20
Radu Stoenescu
