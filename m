Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qk1-f171.google.com ([209.85.222.171]:36601 "EHLO
        mail-qk1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726894AbfHWNQS (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 23 Aug 2019 09:16:18 -0400
Received: by mail-qk1-f171.google.com with SMTP id d23so8146398qko.3
        for <xdp-newbies@vger.kernel.org>; Fri, 23 Aug 2019 06:16:18 -0700 (PDT)
MIME-Version: 1.0
References: <889477ed79c44e6a9395cf961f782209@pantheon.tech>
 <CA+_TK733RPSU=sEqSFpk-La6RNuJJM4m7xsDgOZ-EnaRAwKwKA@mail.gmail.com> <20190823102224.16141c87@carbon>
In-Reply-To: <20190823102224.16141c87@carbon>
From: William Tu <u9012063@gmail.com>
Date: Fri, 23 Aug 2019 06:15:39 -0700
Message-ID: <CALDO+SZeLFXyLct2NNME_FmtgsUmuOAjB9q1n3jZ6dDHvAiWCw@mail.gmail.com>
Subject: Re: AF_XDP integration with FDio VPP? (Was: Questions about XDP)
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: =?UTF-8?B?TWFyZWsgWsOhdm9kc2vDvQ==?= <marek.zavodsky@pantheon.tech>
Cc: =?UTF-8?Q?J=C3=BAlius_Milan?= <Julius.Milan@pantheon.tech>, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, "Karlsson, Magnus" <magnus.karlsson@intel.com>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>, Eelco Chaudron <echaudro@redhat.com>, Thomas F Herbert <therbert@redhat.com>, Jesper Dangaard Brouer <brouer@redhat.com>

On Fri, Aug 23, 2019 at 1:22 AM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
>
> Bringing these questions to the xdp-newbies list, where they belong.
> Answers inlined below.
>
> On Tue, 20 Aug 2019 21:17:57 +0200 J=C3=BAlius Milan <Julius.Milan@panthe=
on.tech>
> >
> > I am writing AF_XDP driver for FDio VPP. I have 2 questions.
> >
>
> That sounds excellent.  I was hoping someone would do this for FDio VPP.
> Do notice that DPDK now also got AF_XDP support.  IHMO it makes a lot
> of sense to implement AF_XDP for FDio, and avoid the DPDK dependency.
> (AFAIK FDio already got other back-ends than DPDK).
>
Hi Marek,

But isn't most of the VPP deployment use DPDK as back-ends?
If that's the case, why not use DPDK's AF_XDP implementation?

Regards,
William
