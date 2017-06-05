Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-ua0-f176.google.com ([209.85.217.176]:35733 "EHLO
        mail-ua0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751290AbdFEMOE (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Mon, 5 Jun 2017 08:14:04 -0400
Received: by mail-ua0-f176.google.com with SMTP id y4so74426992uay.2
        for <xdp-newbies@vger.kernel.org>; Mon, 05 Jun 2017 05:14:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170601211109.47b64216@redhat.com>
References: <CAErYV9HG9H=62DL49qY1iewshx3NcMqAq6u3O=RsYEWdZp3Hjw@mail.gmail.com>
 <20170601185934.73ab06a4@redhat.com> <20170601211109.47b64216@redhat.com>
From: Adel Fuchs <adelfuchs@gmail.com>
Date: Mon, 5 Jun 2017 15:14:03 +0300
Message-ID: <CAErYV9Exi8DyF2uba-ojLieydXt8Dj0CMmjrDtg9S9EkW8E4Aw@mail.gmail.com>
Subject: Re: Running Prototype-kernel package
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jesper Dangaard Brouer <brouer@redhat.com>, xdp-newbies@vger.kernel.org, iovisor-dev@lists.iovisor.org

Hi Jesper,

First of all, thanks for updating the prototype-kernel packet. It works!

I tried to switch to white list and it worked. Though, as a result,
there is no way to ping the machine and get a response. I assume that
this occurs because the white list blocks protocols from lower levels,
such as ARP.
Do you know how to solve this problem? (enabling ARP and other
protocols from lower levels somehow...?)

Thanks,
Adel

On Thu, Jun 1, 2017 at 10:11 PM, Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
> On Thu, 1 Jun 2017 18:59:34 +0200
> Jesper Dangaard Brouer <brouer@redhat.com> wrote:
>
>> I guess, I'll update the documentation a bit after your feedback,
>
> Done, updated the documentation in the prototype-kernel github repo.
>
> See three top commits in this link:
>  https://github.com/netoptimizer/prototype-kernel/commits/7db5539438fa7
>
> The prototype-kernel doc is rendered here:
>  https://prototype-kernel.readthedocs.io/en/latest/index.html
>  https://prototype-kernel.readthedocs.io/en/latest/prototype-kernel/index.html
>
> --
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
