Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-ot1-f65.google.com ([209.85.210.65]:39067 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbfHMIDG (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 13 Aug 2019 04:03:06 -0400
MIME-Version: 1.0
References: <20190812113429.2488-1-ivan.khoronzhuk@linaro.org> <20190812124326.32146-1-ivan.khoronzhuk@linaro.org>
In-Reply-To: <20190812124326.32146-1-ivan.khoronzhuk@linaro.org>
From: Magnus Karlsson <magnus.karlsson@gmail.com>
Date: Tue, 13 Aug 2019 10:02:54 +0200
Message-ID: <CAJ8uoz0bBhdQSocQz8Y9tvrGCsCE9TDf3m1u6=sL4Eo5tZ17YQ@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next] mm: mmap: increase sockets maximum memory
 size pgoff for 32bits
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc: =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>, linux-mm@kvack.org, Xdp <xdp-newbies@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, Alexei Starovoitov <ast@kernel.org>, "Karlsson, Magnus" <magnus.karlsson@intel.com>

On Mon, Aug 12, 2019 at 2:45 PM Ivan Khoronzhuk
<ivan.khoronzhuk@linaro.org> wrote:
>
> The AF_XDP sockets umem mapping interface uses XDP_UMEM_PGOFF_FILL_RING
> and XDP_UMEM_PGOFF_COMPLETION_RING offsets. The offsets seems like are
> established already and are part of configuration interface.
>
> But for 32-bit systems, while AF_XDP socket configuration, the values
> are to large to pass maximum allowed file size verification.
> The offsets can be tuned ofc, but instead of changing existent
> interface - extend max allowed file size for sockets.

Can you use mmap2() instead that takes a larger offset (2^44) even on
32-bit systems?

/Magnus

> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
> ---
>
> Based on bpf-next/master
>
> v2..v1:
>         removed not necessarily #ifdev as ULL and UL for 64 has same size
>
>  mm/mmap.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 7e8c3e8ae75f..578f52812361 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1358,6 +1358,9 @@ static inline u64 file_mmap_size_max(struct file *file, struct inode *inode)
>         if (S_ISBLK(inode->i_mode))
>                 return MAX_LFS_FILESIZE;
>
> +       if (S_ISSOCK(inode->i_mode))
> +               return MAX_LFS_FILESIZE;
> +
>         /* Special "we do even unsigned file positions" case */
>         if (file->f_mode & FMODE_UNSIGNED_OFFSET)
>                 return 0;
> --
> 2.17.1
>
