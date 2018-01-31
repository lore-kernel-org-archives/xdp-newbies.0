Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pg0-f43.google.com ([74.125.83.43]:43184 "EHLO
        mail-pg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751251AbeAaBV3 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 30 Jan 2018 20:21:29 -0500
Received: by mail-pg0-f43.google.com with SMTP id n17so8707740pgf.10
        for <xdp-newbies@vger.kernel.org>; Tue, 30 Jan 2018 17:21:29 -0800 (PST)
Date: Tue, 30 Jan 2018 17:21:26 -0800
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: Limit on max_entries of CPU_ARRAY_MAP
Message-ID: <20180131012125.ill56fxyhllb37bc@ast-mbp>
References: <1517003922.24241.10.camel@regit.org>
 <CAC1LvL1Ap80X=S5WWcFXqjCAgWocxMrW95cZiYy-8_qk45dGWQ@mail.gmail.com>
 <CAH3MdRWtFMbagXwZWYyFTP_pEb3k6bLX3ZZt_TfWBFHx2Z5mOg@mail.gmail.com>
 <CAC1LvL0UYWbmSbNKww_aO-QyrJ9MhZg_kTu-9GgzUU=87irQtQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAC1LvL0UYWbmSbNKww_aO-QyrJ9MhZg_kTu-9GgzUU=87irQtQ@mail.gmail.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Zvi Effron <zeffron@riotgames.com>
Cc: Y Song <ys114321@gmail.com>, Eric Leblond <eric@regit.org>, Xdp <xdp-newbies@vger.kernel.org>, Jesper Dangaard Brouer <brouer@redhat.com>

On Mon, Jan 29, 2018 at 11:00:27AM -0800, Zvi Effron wrote:
> Would it make sense to increase that limit for 64-bit systems? All of
> the comments on why that limit exists that I saw mentioned that
> userspace wouldn't be able to access all of the elements if it were
> bigger. But on a 64-bit system, shouldn't userspace be able to access
> more than 4GB?

What is the _real_ use case for more than 4Gbyte maps?

So far I've seen only one such case that had use to map-in-map
as a workaround to grow the total map size to ~20Gbyte,
but it eventually it was scaled down because at such sizes
performance was bad.
