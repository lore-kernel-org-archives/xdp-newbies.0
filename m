Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pf0-f176.google.com ([209.85.192.176]:38835 "EHLO
        mail-pf0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752431AbeAaBjz (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 30 Jan 2018 20:39:55 -0500
Received: by mail-pf0-f176.google.com with SMTP id k19so10949738pfj.5
        for <xdp-newbies@vger.kernel.org>; Tue, 30 Jan 2018 17:39:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180131012125.ill56fxyhllb37bc@ast-mbp>
References: <1517003922.24241.10.camel@regit.org> <CAC1LvL1Ap80X=S5WWcFXqjCAgWocxMrW95cZiYy-8_qk45dGWQ@mail.gmail.com>
 <CAH3MdRWtFMbagXwZWYyFTP_pEb3k6bLX3ZZt_TfWBFHx2Z5mOg@mail.gmail.com>
 <CAC1LvL0UYWbmSbNKww_aO-QyrJ9MhZg_kTu-9GgzUU=87irQtQ@mail.gmail.com> <20180131012125.ill56fxyhllb37bc@ast-mbp>
From: Zvi Effron <zeffron@riotgames.com>
Date: Tue, 30 Jan 2018 17:39:54 -0800
Message-ID: <CAC1LvL0Ewwht75KAg9M9kqCW+KzABHYP-pRFDADmYjUXiZLkNQ@mail.gmail.com>
Subject: Re: Limit on max_entries of CPU_ARRAY_MAP
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Y Song <ys114321@gmail.com>, Eric Leblond <eric@regit.org>, Xdp <xdp-newbies@vger.kernel.org>, Jesper Dangaard Brouer <brouer@redhat.com>

We'll have to see how it plays out performance wise, but we're doing
some tracking on a per IP per port basis across a /24. We'd originally
tried to use one map with a key that's a combination of IP and port,
but had to switch to map in map with IP being outer key and port being
inner (or could go vice versa).

--Zvi

On Tue, Jan 30, 2018 at 5:21 PM, Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
> On Mon, Jan 29, 2018 at 11:00:27AM -0800, Zvi Effron wrote:
>> Would it make sense to increase that limit for 64-bit systems? All of
>> the comments on why that limit exists that I saw mentioned that
>> userspace wouldn't be able to access all of the elements if it were
>> bigger. But on a 64-bit system, shouldn't userspace be able to access
>> more than 4GB?
>
> What is the _real_ use case for more than 4Gbyte maps?
>
> So far I've seen only one such case that had use to map-in-map
> as a workaround to grow the total map size to ~20Gbyte,
> but it eventually it was scaled down because at such sizes
> performance was bad.
>
