Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qt1-f195.google.com ([209.85.160.195]:46377 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbfETUjE (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 20 May 2019 16:39:04 -0400
Received: by mail-qt1-f195.google.com with SMTP id z19so17835196qtz.13
        for <xdp-newbies@vger.kernel.org>; Mon, 20 May 2019 13:39:03 -0700 (PDT)
Date: Mon, 20 May 2019 13:38:30 -0700
From: Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: Re: [PATCH 1/5] samples/bpf: fix test_lru_dist build
Message-ID: <20190520133830.1ac11fc8@cakuba.netronome.com>
In-Reply-To: <CAGnkfhxt=nq-JV+D5Rrquvn8BVOjHswEJmuVVZE78p9HvAg9qQ@mail.gmail.com>
References: <20190518004639.20648-1-mcroce@redhat.com>
        <CAGnkfhxt=nq-JV+D5Rrquvn8BVOjHswEJmuVVZE78p9HvAg9qQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Matteo Croce <mcroce@redhat.com>
Cc: xdp-newbies@vger.kernel.org, bpf@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>

On Mon, 20 May 2019 19:46:27 +0200, Matteo Croce wrote:
> On Sat, May 18, 2019 at 2:46 AM Matteo Croce <mcroce@redhat.com> wrote:
> >
> > Fix the following error by removing a duplicate struct definition:
> >  
> 
> Hi all,
> 
> I forget to send a cover letter for this series, but basically what I
> wanted to say is that while patches 1-3 are very straightforward,
> patches 4-5 are a bit rough and I accept suggstions to make a cleaner
> work.

samples depend on headers being locally installed:

make headers_install

Are you intending to change that?
