Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:42086 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726134AbgFJViC (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 10 Jun 2020 17:38:02 -0400
Received: by mail-ej1-f72.google.com with SMTP id i17so1703924ejb.9
        for <xdp-newbies@vger.kernel.org>; Wed, 10 Jun 2020 14:37:59 -0700 (PDT)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: Error loading xdp program that worked with bpf_load
In-Reply-To: <CAMDScmm5nCzeffaeEuSFHATunsH36XW2VzbsFCuWhU5OYr_naA@mail.gmail.com>
References: <CAMDScmnpbPgs+mB_aMY16aXLMMWBgfu0sqna06MH8RPoGpw7_Q@mail.gmail.com> <87imfy7hrx.fsf@toke.dk> <CAMDScmm5nCzeffaeEuSFHATunsH36XW2VzbsFCuWhU5OYr_naA@mail.gmail.com>
Date: Wed, 10 Jun 2020 23:37:57 +0200
Message-ID: <87a71a7gay.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Elerion <elerion1000@gmail.com>
Cc: xdp-newbies@vger.kernel.org

Elerion <elerion1000@gmail.com> writes:

> [69] FUNC xdp_program type_id=68 vlen != 0

'vlen != 0' is the error. Not sure why you hit that; what's the output
of 'bpftool btf dump file yourprog.o' ?

-Toke
