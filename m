Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:40046 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726366AbfEYTe3 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Sat, 25 May 2019 15:34:29 -0400
From: Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH] libbpf: fix warning PTR_ERR_OR_ZERO can be used
Date: Sat, 25 May 2019 19:33:44 +0000
Message-ID: <2d147a2f-ac12-4e97-d281-c0d3463a5405@fb.com>
References: <20190525090257.GA12104@hari-Inspiron-1545>
In-Reply-To: <20190525090257.GA12104@hari-Inspiron-1545>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <39D77CFF63DBDE42824E52F6659BE541@namprd15.prod.outlook.com>
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: Hariprasad Kelam <hariprasad.kelam@gmail.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>



On 5/25/19 2:02 AM, Hariprasad Kelam wrote:
> fix below warning reported by coccicheck
> 
> /tools/lib/bpf/libbpf.c:3461:1-3: WARNING: PTR_ERR_OR_ZERO can be used
> 
> Signed-off-by: Hariprasad Kelam <hariprasad.kelam@gmail.com>
Acked-by: Yonghong Song <yhs@fb.com>

> ---
>   tools/lib/bpf/libbpf.c | 4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 197b574..33c25b6 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -3458,9 +3458,7 @@ bpf_object__find_map_by_offset(struct bpf_object *obj, size_t offset)
>   
>   long libbpf_get_error(const void *ptr)
>   {
> -	if (IS_ERR(ptr))
> -		return PTR_ERR(ptr);
> -	return 0;
> +	return PTR_ERR_OR_ZERO(ptr);
>   }
>   
>   int bpf_prog_load(const char *file, enum bpf_prog_type type,
> 
