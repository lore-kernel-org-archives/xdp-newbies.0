Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-lj1-f195.google.com ([209.85.208.195]:43640 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbfETRrF (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 20 May 2019 13:47:05 -0400
Received: by mail-lj1-f195.google.com with SMTP id z5so13284308lji.10
        for <xdp-newbies@vger.kernel.org>; Mon, 20 May 2019 10:47:04 -0700 (PDT)
MIME-Version: 1.0
References: <20190518004639.20648-1-mcroce@redhat.com>
In-Reply-To: <20190518004639.20648-1-mcroce@redhat.com>
From: Matteo Croce <mcroce@redhat.com>
Date: Mon, 20 May 2019 19:46:27 +0200
Message-ID: <CAGnkfhxt=nq-JV+D5Rrquvn8BVOjHswEJmuVVZE78p9HvAg9qQ@mail.gmail.com>
Subject: Re: [PATCH 1/5] samples/bpf: fix test_lru_dist build
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org, bpf@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>

On Sat, May 18, 2019 at 2:46 AM Matteo Croce <mcroce@redhat.com> wrote:
>
> Fix the following error by removing a duplicate struct definition:
>

Hi all,

I forget to send a cover letter for this series, but basically what I
wanted to say is that while patches 1-3 are very straightforward,
patches 4-5 are a bit rough and I accept suggstions to make a cleaner
work.

Regards,
-- 
Matteo Croce
per aspera ad upstream
