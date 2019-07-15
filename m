Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34427 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728936AbfGOCeE (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Sun, 14 Jul 2019 22:34:04 -0400
Received: by mail-pg1-f196.google.com with SMTP id n9so736153pgc.1
        for <xdp-newbies@vger.kernel.org>; Sun, 14 Jul 2019 19:34:03 -0700 (PDT)
Subject: Re: [PATCH] mm/gup: Use put_user_page*() instead of put_page*()
References: <1563131456-11488-1-git-send-email-linux.bhar@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <018ee3d1-e2f0-ca12-9f63-945056c09985@kernel.dk>
Date: Sun, 14 Jul 2019 20:33:57 -0600
MIME-Version: 1.0
In-Reply-To: <1563131456-11488-1-git-send-email-linux.bhar@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Bharath Vedartham <linux.bhar@gmail.com>, akpm@linux-foundation.org, ira.weiny@intel.com, jhubbard@nvidia.com
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>, Dimitri Sivanich <sivanich@sgi.com>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alex Williamson <alex.williamson@redhat.com>, Cornelia Huck <cohuck@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>, Magnus Karlsson <magnus.karlsson@intel.com>, "David S. Miller" <davem@davemloft.net>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, Enrico Weigelt <info@metux.net>, Thomas Gleixner <tglx@linutronix.de>, Alexios Zavras <alexios.zavras@intel.com>, Dan Carpenter <dan.carpenter@oracle.com>, Max Filippov <jcmvbkbc@gmail.com>, Matt Sickler <Matt.Sickler@daktronics.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Keith Busch <keith.busch@intel.com>, YueHaibing <yuehaibing@huawei.com>, linux-media@vger.kernel.org, linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org, kvm@vger.kernel.org, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org, bpf@vger.kernel.org, xdp-newbies@vger.kernel.org

On 7/14/19 1:08 PM, Bharath Vedartham wrote:
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 4ef62a4..b4a4549 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -2694,10 +2694,9 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, void __user *arg,
>   			 * if we did partial map, or found file backed vmas,
>   			 * release any pages we did get
>   			 */
> -			if (pret > 0) {
> -				for (j = 0; j < pret; j++)
> -					put_page(pages[j]);
> -			}
> +			if (pret > 0)
> +				put_user_pages(pages, pret);
> +
>   			if (ctx->account_mem)
>   				io_unaccount_mem(ctx->user, nr_pages);
>   			kvfree(imu->bvec);

You handled just the failure case of the buffer registration, but not
the actual free in io_sqe_buffer_unregister().

-- 
Jens Axboe
