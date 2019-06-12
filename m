Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42017 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437144AbfFLO3Q (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 12 Jun 2019 10:29:16 -0400
From: "Jonathan Lemon" <jonathan.lemon@gmail.com>
Subject: Re: [PATCH bpf-next] bpf: Fix build error without CONFIG_INET
Date: Wed, 12 Jun 2019 07:29:13 -0700
Message-ID: <CFE96009-1D3A-4D99-8A96-86C281772396@gmail.com>
In-Reply-To: <20190612091847.23708-1-yuehaibing@huawei.com>
References: <20190612091847.23708-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: YueHaibing <yuehaibing@huawei.com>
Cc: ast@kernel.org, daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com, yhs@fb.com, davem@davemloft.net, jakub.kicinski@netronome.com, linux-kernel@vger.kernel.org, xdp-newbies@vger.kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org

On 12 Jun 2019, at 2:18, YueHaibing wrote:

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
Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
