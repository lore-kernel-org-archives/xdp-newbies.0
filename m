Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:40366 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726219AbfHLM5I (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 12 Aug 2019 08:57:08 -0400
Subject: Re: [PATCH v2 bpf-next] mm: mmap: increase sockets maximum memory
 size pgoff for 32bits
References: <20190812113429.2488-1-ivan.khoronzhuk@linaro.org>
 <20190812124326.32146-1-ivan.khoronzhuk@linaro.org>
From: Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <389f9d64-cfcd-6cc3-bf72-83c35d3e9512@iogearbox.net>
Date: Mon, 12 Aug 2019 14:57:00 +0200
MIME-Version: 1.0
In-Reply-To: <20190812124326.32146-1-ivan.khoronzhuk@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>, bjorn.topel@intel.com, linux-mm@kvack.org
Cc: xdp-newbies@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, ast@kernel.org, magnus.karlsson@intel.com

On 8/12/19 2:43 PM, Ivan Khoronzhuk wrote:
> The AF_XDP sockets umem mapping interface uses XDP_UMEM_PGOFF_FILL_RING
> and XDP_UMEM_PGOFF_COMPLETION_RING offsets. The offsets seems like are
> established already and are part of configuration interface.
> 
> But for 32-bit systems, while AF_XDP socket configuration, the values
> are to large to pass maximum allowed file size verification.
> The offsets can be tuned ofc, but instead of changing existent
> interface - extend max allowed file size for sockets.
> 
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
> ---
> 
> Based on bpf-next/master

This is mainly for Andrew to pick rather than bpf-next, but I presume it would
apply cleanly to his tree as well.

> v2..v1:
> 	removed not necessarily #ifdev as ULL and UL for 64 has same size
> 
>   mm/mmap.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 7e8c3e8ae75f..578f52812361 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1358,6 +1358,9 @@ static inline u64 file_mmap_size_max(struct file *file, struct inode *inode)
>   	if (S_ISBLK(inode->i_mode))
>   		return MAX_LFS_FILESIZE;
>   
> +	if (S_ISSOCK(inode->i_mode))
> +		return MAX_LFS_FILESIZE;
> +
>   	/* Special "we do even unsigned file positions" case */
>   	if (file->f_mode & FMODE_UNSIGNED_OFFSET)
>   		return 0;
> 
