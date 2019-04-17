Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-ed1-f51.google.com ([209.85.208.51]:36781 "EHLO
        mail-ed1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729939AbfDQN0O (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 17 Apr 2019 09:26:14 -0400
Received: by mail-ed1-f51.google.com with SMTP id u57so20341757edm.3
        for <xdp-newbies@vger.kernel.org>; Wed, 17 Apr 2019 06:26:13 -0700 (PDT)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: XDP chain using tail calls
In-Reply-To: <CAM-scZOqYquo2X94K0x9FQc4iGwWODuLXKxhAatn5g2H6+ZhQA@mail.gmail.com>
References: <CAM-scZOqYquo2X94K0x9FQc4iGwWODuLXKxhAatn5g2H6+ZhQA@mail.gmail.com>
Date: Wed, 17 Apr 2019 14:26:10 +0100
Message-ID: <87tvewrcel.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Radu Stoenescu <radu.stoe@gmail.com>, xdp-newbies@vger.kernel.org

Radu Stoenescu <radu.stoe@gmail.com> writes:

> Hello
>
> I was recently reading through the XDP documentation from Cilium[1]
> and I couldn't really wrap my head around the tail cal section.
>
> Is there any tutorial/code example of using this feature with XDP?

Hmm, I'm not sure there are any current examples. But you make a good
point, we should probably have one. We're building an interactive
tutorial here: https://github.com/xdp-project/xdp-tutorial - please feel
free to open an issue here requesting it to be added! :)

-Toke
