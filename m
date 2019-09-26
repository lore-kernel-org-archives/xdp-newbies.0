Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-ua1-f65.google.com ([209.85.222.65]:44981 "EHLO
        mail-ua1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbfIZMla (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 26 Sep 2019 08:41:30 -0400
Received: by mail-ua1-f65.google.com with SMTP id n2so699943ual.11
        for <xdp-newbies@vger.kernel.org>; Thu, 26 Sep 2019 05:41:29 -0700 (PDT)
MIME-Version: 1.0
References: <0cbbc2e2-9eba-ad40-d819-d092b2015707@univ-lille.fr>
 <CAGn_ityTBjJ+erYRrvoFCCVYM9qwztg3tkmRuShs60xACQhvbQ@mail.gmail.com> <20190926123450.GA39817@C02YVCJELVCG>
In-Reply-To: <20190926123450.GA39817@C02YVCJELVCG>
From: Anton Protopopov <aspsk2@gmail.com>
Date: Thu, 26 Sep 2019 08:41:18 -0400
Message-ID: <CAGn_ityL9anR3BHKr_fZhV=Z-9KDtkrbH+TDAHKEtsM9w7Q48Q@mail.gmail.com>
Subject: Re: [xdp-tutorial] : permission denied when I try to execute a program
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Andy Gospodarek <andy@greyhouse.net>
Cc: =?UTF-8?Q?Th=C3=A9o_Mainguet?= <theo.mainguet.etu@univ-lille.fr>, xdp-newbies@vger.kernel.org

=D1=87=D1=82, 26 =D1=81=D0=B5=D0=BD=D1=82. 2019 =D0=B3. =D0=B2 08:34, Andy =
Gospodarek <andy@greyhouse.net>:
>
> On Thu, Sep 26, 2019 at 08:17:48AM -0400, Anton Protopopov wrote:
> > =D1=87=D1=82, 26 =D1=81=D0=B5=D0=BD=D1=82. 2019 =D0=B3. =D0=B2 05:22, T=
h=C3=A9o Mainguet <theo.mainguet.etu@univ-lille.fr>:
> > >
> > > Hi,
> > >
> > >
> > > Thank you very much for your xdp tutorial. Currently, I try to write =
a
> > > simple xdp program to count the number of TCP and UDP packets I recei=
ve.
> > > For that, I created a BPF_MAP_TYPE_ARRAY map in my kern.c file. I can
> > > read into this map with the bpf_map_lookup_elem function but when I t=
ry
> > > to update a value, I have an error message "libbpf: load bpf program
> > > failed: Permission denied". To solve this issue, I've try to run it i=
n
> > > sudo, I've verify my kernel configuration (everything needed seems
> > > enable) ....
> >
> > What's the error message when you are trying to load your program with =
sudo?
>
> That information would be helpful as some distros will not run some of
> the sample BPF programs without some ulimit changes.  For example the
> command:
>
> # ulimit -l 1024
>
> or even
>
> # ulimit -l $VERY_LARGE_VALUE
>
> may be needed on Fedora or Ubuntu, but not on other distros.
>

Or even

# ulimit -l unlimited

:-)

Also this can be done from the loader itself, as, e.g., here:
https://github.com/xdp-project/xdp-tutorial/blob/master/advanced03-AF_XDP/a=
f_xdp_user.c#L557
