Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qk1-f194.google.com ([209.85.222.194]:46039 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727406AbfFCRVr (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Mon, 3 Jun 2019 13:21:47 -0400
Received: by mail-qk1-f194.google.com with SMTP id s22so909463qkj.12
        for <xdp-newbies@vger.kernel.org>; Mon, 03 Jun 2019 10:21:46 -0700 (PDT)
Date: Mon, 3 Jun 2019 10:21:40 -0700
From: Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: Re: [PATCH][next] bpf: remove redundant assignment to err
Message-ID: <20190603102140.70fee157@cakuba.netronome.com>
In-Reply-To: <20190603170247.9951-1-colin.king@canonical.com>
References: <20190603170247.9951-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Colin King <colin.king@canonical.com>
Cc: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, "David S . Miller" <davem@davemloft.net>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>, Magnus Karlsson <magnus.karlsson@intel.com>, netdev@vger.kernel.org, xdp-newbies@vger.kernel.org, bpf@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon,  3 Jun 2019 18:02:47 +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The variable err is assigned with the value -EINVAL that is never
> read and it is re-assigned a new value later on.  The assignment is
> redundant and can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  kernel/bpf/devmap.c | 2 +-
>  kernel/bpf/xskmap.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> index 5ae7cce5ef16..a76cc6412fc4 100644
> --- a/kernel/bpf/devmap.c
> +++ b/kernel/bpf/devmap.c
> @@ -88,7 +88,7 @@ static u64 dev_map_bitmap_size(const union bpf_attr *attr)
>  static struct bpf_map *dev_map_alloc(union bpf_attr *attr)
>  {
>  	struct bpf_dtab *dtab;
> -	int err = -EINVAL;
> +	int err;
>  	u64 cost;

Perhaps keep the variables ordered longest to shortest?

>  	if (!capable(CAP_NET_ADMIN))
> diff --git a/kernel/bpf/xskmap.c b/kernel/bpf/xskmap.c
> index 22066c28ba61..26859c6c9491 100644
> --- a/kernel/bpf/xskmap.c
> +++ b/kernel/bpf/xskmap.c
> @@ -17,7 +17,7 @@ struct xsk_map {
>  
>  static struct bpf_map *xsk_map_alloc(union bpf_attr *attr)
>  {
> -	int cpu, err = -EINVAL;
> +	int cpu, err;
>  	struct xsk_map *m;
>  	u64 cost;

And here.
