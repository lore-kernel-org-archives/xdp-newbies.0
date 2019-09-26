Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-vs1-f42.google.com ([209.85.217.42]:33569 "EHLO
        mail-vs1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbfIZMSB (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 26 Sep 2019 08:18:01 -0400
Received: by mail-vs1-f42.google.com with SMTP id p13so1459615vso.0
        for <xdp-newbies@vger.kernel.org>; Thu, 26 Sep 2019 05:18:00 -0700 (PDT)
MIME-Version: 1.0
References: <0cbbc2e2-9eba-ad40-d819-d092b2015707@univ-lille.fr>
In-Reply-To: <0cbbc2e2-9eba-ad40-d819-d092b2015707@univ-lille.fr>
From: Anton Protopopov <aspsk2@gmail.com>
Date: Thu, 26 Sep 2019 08:17:48 -0400
Message-ID: <CAGn_ityTBjJ+erYRrvoFCCVYM9qwztg3tkmRuShs60xACQhvbQ@mail.gmail.com>
Subject: Re: [xdp-tutorial] : permission denied when I try to execute a program
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: =?UTF-8?Q?Th=C3=A9o_Mainguet?= <theo.mainguet.etu@univ-lille.fr>
Cc: xdp-newbies@vger.kernel.org

=D1=87=D1=82, 26 =D1=81=D0=B5=D0=BD=D1=82. 2019 =D0=B3. =D0=B2 05:22, Th=C3=
=A9o Mainguet <theo.mainguet.etu@univ-lille.fr>:
>
> Hi,
>
>
> Thank you very much for your xdp tutorial. Currently, I try to write a
> simple xdp program to count the number of TCP and UDP packets I receive.
> For that, I created a BPF_MAP_TYPE_ARRAY map in my kern.c file. I can
> read into this map with the bpf_map_lookup_elem function but when I try
> to update a value, I have an error message "libbpf: load bpf program
> failed: Permission denied". To solve this issue, I've try to run it in
> sudo, I've verify my kernel configuration (everything needed seems
> enable) ....

What's the error message when you are trying to load your program with sudo=
?
