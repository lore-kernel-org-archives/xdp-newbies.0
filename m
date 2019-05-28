Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:38192 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726279AbfE1J0l (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 28 May 2019 05:26:41 -0400
Subject: Re: [PATCH] libbpf: fix warning PTR_ERR_OR_ZERO can be used
References: <20190525090257.GA12104@hari-Inspiron-1545>
From: Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <a5b68a2e-b9a6-7ad4-62a0-007f815be780@iogearbox.net>
Date: Tue, 28 May 2019 11:26:33 +0200
MIME-Version: 1.0
In-Reply-To: <20190525090257.GA12104@hari-Inspiron-1545>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Hariprasad Kelam <hariprasad.kelam@gmail.com>, Alexei Starovoitov <ast@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, netdev@vger.kernel.org, bpf@vger.kernel.org, linux-kernel@vger.kernel.org, xdp-newbies@vger.kernel.org

On 05/25/2019 11:02 AM, Hariprasad Kelam wrote:
> fix below warning reported by coccicheck
> 
> /tools/lib/bpf/libbpf.c:3461:1-3: WARNING: PTR_ERR_OR_ZERO can be used
> 
> Signed-off-by: Hariprasad Kelam <hariprasad.kelam@gmail.com>

Applied, thanks!
