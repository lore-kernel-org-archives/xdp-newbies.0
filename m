Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46267 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbfIZMe6 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 26 Sep 2019 08:34:58 -0400
Received: by mail-pf1-f195.google.com with SMTP id q5so1736426pfg.13
        for <xdp-newbies@vger.kernel.org>; Thu, 26 Sep 2019 05:34:56 -0700 (PDT)
Date: Thu, 26 Sep 2019 08:34:50 -0400
From: Andy Gospodarek <andy@greyhouse.net>
Subject: Re: [xdp-tutorial] : permission denied when I try to execute a
 program
Message-ID: <20190926123450.GA39817@C02YVCJELVCG>
References: <0cbbc2e2-9eba-ad40-d819-d092b2015707@univ-lille.fr>
 <CAGn_ityTBjJ+erYRrvoFCCVYM9qwztg3tkmRuShs60xACQhvbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGn_ityTBjJ+erYRrvoFCCVYM9qwztg3tkmRuShs60xACQhvbQ@mail.gmail.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Anton Protopopov <aspsk2@gmail.com>
Cc: =?iso-8859-1?Q?Th=E9o?= Mainguet <theo.mainguet.etu@univ-lille.fr>, xdp-newbies@vger.kernel.org

On Thu, Sep 26, 2019 at 08:17:48AM -0400, Anton Protopopov wrote:
> чт, 26 сент. 2019 г. в 05:22, Théo Mainguet <theo.mainguet.etu@univ-lille.fr>:
> >
> > Hi,
> >
> >
> > Thank you very much for your xdp tutorial. Currently, I try to write a
> > simple xdp program to count the number of TCP and UDP packets I receive.
> > For that, I created a BPF_MAP_TYPE_ARRAY map in my kern.c file. I can
> > read into this map with the bpf_map_lookup_elem function but when I try
> > to update a value, I have an error message "libbpf: load bpf program
> > failed: Permission denied". To solve this issue, I've try to run it in
> > sudo, I've verify my kernel configuration (everything needed seems
> > enable) ....
> 
> What's the error message when you are trying to load your program with sudo?

That information would be helpful as some distros will not run some of
the sample BPF programs without some ulimit changes.  For example the
command:

# ulimit -l 1024

or even

# ulimit -l $VERY_LARGE_VALUE

may be needed on Fedora or Ubuntu, but not on other distros.
