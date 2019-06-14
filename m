Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:41504 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725825AbfFNXY3 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 14 Jun 2019 19:24:29 -0400
Subject: Re: [PATCH bpf-next] bpf: Fix build error without CONFIG_INET
References: <20190612091847.23708-1-yuehaibing@huawei.com>
From: Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <d4b83351-91ef-d53f-5c78-e03cd8284fb0@iogearbox.net>
Date: Sat, 15 Jun 2019 01:24:12 +0200
MIME-Version: 1.0
In-Reply-To: <20190612091847.23708-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: YueHaibing <yuehaibing@huawei.com>, ast@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com, davem@davemloft.net, jakub.kicinski@netronome.com, jonathan.lemon@gmail.com
Cc: linux-kernel@vger.kernel.org, xdp-newbies@vger.kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org

On 06/12/2019 11:18 AM, YueHaibing wrote:
> If CONFIG_INET is not set, building fails:
> 
> kernel/bpf/verifier.o: In function `check_mem_access':
> verifier.c: undefined reference to `bpf_xdp_sock_is_valid_access'
> kernel/bpf/verifier.o: In function `convert_ctx_accesses':
> verifier.c: undefined reference to `bpf_xdp_sock_convert_ctx_access'
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Fixes: fada7fdc83c0 ("bpf: Allow bpf_map_lookup_elem() on an xskmap")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied, thanks!
