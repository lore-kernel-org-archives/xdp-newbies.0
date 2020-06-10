Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbgFJVuk (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 10 Jun 2020 17:50:40 -0400
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62066C03E96B
        for <xdp-newbies@vger.kernel.org>; Wed, 10 Jun 2020 14:50:39 -0700 (PDT)
Received: by mail-vs1-xe2d.google.com with SMTP id r11so2226319vsj.5
        for <xdp-newbies@vger.kernel.org>; Wed, 10 Jun 2020 14:50:39 -0700 (PDT)
MIME-Version: 1.0
References: <CAMDScmnpbPgs+mB_aMY16aXLMMWBgfu0sqna06MH8RPoGpw7_Q@mail.gmail.com>
 <87imfy7hrx.fsf@toke.dk> <CAMDScmm5nCzeffaeEuSFHATunsH36XW2VzbsFCuWhU5OYr_naA@mail.gmail.com>
 <87a71a7gay.fsf@toke.dk>
In-Reply-To: <87a71a7gay.fsf@toke.dk>
From: Elerion <elerion1000@gmail.com>
Date: Wed, 10 Jun 2020 14:50:27 -0700
Message-ID: <CAMDScmnTYKfjMjiqLGduY4Pk3X0D7RQhjtY7DuPmh65VMNeCRw@mail.gmail.com>
Subject: Re: Error loading xdp program that worked with bpf_load
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc: xdp-newbies@vger.kernel.org

Never mind, I fixed it by downgrading to Clang 9.

It appears to be an issue with Clang/LLVM 10+

https://github.com/cilium/ebpf/issues/43

On Wed, Jun 10, 2020 at 2:38 PM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>
> Elerion <elerion1000@gmail.com> writes:
>
> > [69] FUNC xdp_program type_id=68 vlen != 0
>
> 'vlen != 0' is the error. Not sure why you hit that; what's the output
> of 'bpftool btf dump file yourprog.o' ?
>
> -Toke
>
