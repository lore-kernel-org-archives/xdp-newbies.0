Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from smtp.emailarray.com ([69.28.212.198]:64697 "EHLO
        smtp2.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729204AbfHOTkd (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 15 Aug 2019 15:40:33 -0400
From: "Jonathan Lemon" <jlemon@flugsvamp.com>
Subject: Re: [PATCH bpf-next v2 2/3] xdp: xdp_umem: replace kmap on vmap for
 umem map
Date: Thu, 15 Aug 2019 12:33:44 -0700
Message-ID: <2D5AB510-F3F1-4215-B9D6-CE576CC474B0@flugsvamp.com>
In-Reply-To: <20190815121356.8848-3-ivan.khoronzhuk@linaro.org>
References: <20190815121356.8848-1-ivan.khoronzhuk@linaro.org>
 <20190815121356.8848-3-ivan.khoronzhuk@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc: magnus.karlsson@intel.com, bjorn.topel@intel.com, davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com, jakub.kicinski@netronome.com, daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org, xdp-newbies@vger.kernel.org, linux-kernel@vger.kernel.org, yhs@fb.com, andrii.nakryiko@gmail.com



On 15 Aug 2019, at 5:13, Ivan Khoronzhuk wrote:

> For 64-bit there is no reason to use vmap/vunmap, so use page_address
> as it was initially. For 32 bits, in some apps, like in samples
> xdpsock_user.c when number of pgs in use is quite big, the kmap
> memory can be not enough, despite on this, kmap looks like is
> deprecated in such cases as it can block and should be used rather
> for dynamic mm.
>
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>

Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
