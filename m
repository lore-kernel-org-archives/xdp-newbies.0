Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56101 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726507AbgD0Kqp (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 27 Apr 2020 06:46:45 -0400
Received: by mail-lf1-f69.google.com with SMTP id t11so7306693lfc.17
        for <xdp-newbies@vger.kernel.org>; Mon, 27 Apr 2020 03:46:40 -0700 (PDT)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: building eBPF
In-Reply-To: <20200425163458.GB455@gmail.com>
References: <20200425122225.GA455@gmail.com> <20200425145619.4405a50d@carbon> <20200425163458.GB455@gmail.com>
Date: Mon, 27 Apr 2020 12:46:37 +0200
Message-ID: <87o8rdyzn6.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Sowmini Varadhan <sowmini05@gmail.com>, Jesper Dangaard Brouer <brouer@redhat.com>
Cc: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>

Sowmini Varadhan <sowmini05@gmail.com> writes:

> On (04/25/20 14:56), Jesper Dangaard Brouer wrote:
>> 
>> The kernel's samples/bpf/ should still builds with LLVM-9 (and lower).
>> Follow instructions in the README.rst file[1].
>> 
>> There are pre-build Debian and Ubuntu packages for LLVM-10 here:
>>  https://apt.llvm.org/
>
> thanks that helped me install llvm-10
>
> However, after all my adventures, I  end up with
> # ls /usr/bin/llc*
> /usr/bin/llc  /usr/bin/llc-10  /usr/bin/llc-5.0  /usr/bin/llc-6.0  /usr/bin/llc-7
> and the default points at 6.0 so I had to go and tweak Makefile
> to use clang-10 and llc-10

Note that you can just override them on the command line. E.g.,

make CLANG=clang-10 LLC=llc-10

-Toke
