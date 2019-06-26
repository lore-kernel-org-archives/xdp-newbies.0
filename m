Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:45082 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbfFZOdl (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 26 Jun 2019 10:33:41 -0400
Subject: Re: [PATCH net-next] xdp: Make __mem_id_disconnect static
References: <20190625023137.29272-1-yuehaibing@huawei.com>
From: Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <bbd0b831-8ffa-1993-0a2a-06c1102f3292@iogearbox.net>
Date: Wed, 26 Jun 2019 16:33:30 +0200
MIME-Version: 1.0
In-Reply-To: <20190625023137.29272-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: YueHaibing <yuehaibing@huawei.com>, davem@davemloft.net, ast@kernel.org, jakub.kicinski@netronome.com, hawk@kernel.org, john.fastabend@gmail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, xdp-newbies@vger.kernel.org, bpf@vger.kernel.org

On 06/25/2019 04:31 AM, YueHaibing wrote:
> Fix sparse warning:
> 
> net/core/xdp.c:88:6: warning:
>  symbol '__mem_id_disconnect' was not declared. Should it be static?
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied, thanks!
