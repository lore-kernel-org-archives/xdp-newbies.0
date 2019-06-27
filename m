Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44111 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726559AbfF0WEi (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 27 Jun 2019 18:04:38 -0400
From: "Jonathan Lemon" <jonathan.lemon@gmail.com>
Subject: Re: [PATCH bpf v5 1/2] xdp: hold device for umem regardless of
 zero-copy mode
Date: Thu, 27 Jun 2019 15:04:35 -0700
Message-ID: <A2E9F080-AFBE-4DA8-BAA5-73E6442DB54B@gmail.com>
In-Reply-To: <20190627101529.11234-2-i.maximets@samsung.com>
References: <20190627101529.11234-1-i.maximets@samsung.com>
 <CGME20190627101538eucas1p23924bd4173eb4b7b59c624b588ecb787@eucas1p2.samsung.com>
 <20190627101529.11234-2-i.maximets@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Ilya Maximets <i.maximets@samsung.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, xdp-newbies@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, =?utf-8?b?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>, Magnus Karlsson <magnus.karlsson@intel.com>, Jakub Kicinski <jakub.kicinski@netronome.com>, Daniel Borkmann <daniel@iogearbox.net>

On 27 Jun 2019, at 3:15, Ilya Maximets wrote:

> Device pointer stored in umem regardless of zero-copy mode,
> so we heed to hold the device in all cases.
>
> Fixes: c9b47cc1fabc ("xsk: fix bug when trying to use both copy and 
> zero-copy on one queue id")
> Signed-off-by: Ilya Maximets <i.maximets@samsung.com>

Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
