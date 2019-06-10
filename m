Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from smtp3.emailarray.com ([65.39.216.17]:39970 "EHLO
        smtp3.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388311AbfFJVDf (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 10 Jun 2019 17:03:35 -0400
From: "Jonathan Lemon" <jlemon@flugsvamp.com>
Subject: Re: [PATCH bpf] xdp: check device pointer before clearing
Date: Mon, 10 Jun 2019 13:56:49 -0700
Message-ID: <76A4186A-5495-4003-A494-7DE0B15EFB1A@flugsvamp.com>
In-Reply-To: <20190607172732.4710-1-i.maximets@samsung.com>
References: <CGME20190607172737eucas1p28508d5e198907695bc77f9fd18ce233e@eucas1p2.samsung.com>
 <20190607172732.4710-1-i.maximets@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Ilya Maximets <i.maximets@samsung.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, xdp-newbies@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, =?utf-8?b?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>, Magnus Karlsson <magnus.karlsson@intel.com>

On 7 Jun 2019, at 10:27, Ilya Maximets wrote:

> We should not call 'ndo_bpf()' or 'dev_put()' with NULL argument.
>
> Fixes: c9b47cc1fabc ("xsk: fix bug when trying to use both copy and 
> zero-copy on one queue id")
> Signed-off-by: Ilya Maximets <i.maximets@samsung.com>
Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
