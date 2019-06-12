Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:45262 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727121AbfFLOs7 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 12 Jun 2019 10:48:59 -0400
Subject: Re: [PATCH bpf] xdp: check device pointer before clearing
References: <CGME20190607172737eucas1p28508d5e198907695bc77f9fd18ce233e@eucas1p2.samsung.com>
 <20190607172732.4710-1-i.maximets@samsung.com>
From: Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <d7957438-2f69-44de-c999-1e1568ef6d74@iogearbox.net>
Date: Wed, 12 Jun 2019 16:48:48 +0200
MIME-Version: 1.0
In-Reply-To: <20190607172732.4710-1-i.maximets@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Ilya Maximets <i.maximets@samsung.com>, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, bpf@vger.kernel.org, xdp-newbies@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>, Magnus Karlsson <magnus.karlsson@intel.com>

On 06/07/2019 07:27 PM, Ilya Maximets wrote:
> We should not call 'ndo_bpf()' or 'dev_put()' with NULL argument.
> 
> Fixes: c9b47cc1fabc ("xsk: fix bug when trying to use both copy and zero-copy on one queue id")
> Signed-off-by: Ilya Maximets <i.maximets@samsung.com>

Applied, thanks!
