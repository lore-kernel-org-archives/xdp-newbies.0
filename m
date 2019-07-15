Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pg1-f196.google.com ([209.85.215.196]:36672 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726748AbfGOG7i (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 15 Jul 2019 02:59:38 -0400
Date: Mon, 15 Jul 2019 12:29:17 +0530
From: Bharath Vedartham <linux.bhar@gmail.com>
Subject: Re: [PATCH] mm/gup: Use put_user_page*() instead of put_page*()
Message-ID: <20190715065917.GB3716@bharath12345-Inspiron-5559>
References: <1563131456-11488-1-git-send-email-linux.bhar@gmail.com>
 <018ee3d1-e2f0-ca12-9f63-945056c09985@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <018ee3d1-e2f0-ca12-9f63-945056c09985@kernel.dk>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: akpm@linux-foundation.org, ira.weiny@intel.com, jhubbard@nvidia.com, Mauro Carvalho Chehab <mchehab@kernel.org>, Dimitri Sivanich <sivanich@sgi.com>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alex Williamson <alex.williamson@redhat.com>, Cornelia Huck <cohuck@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>, Magnus Karlsson <magnus.karlsson@intel.com>, "David S. Miller" <davem@davemloft.net>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, Enrico Weigelt <info@metux.net>, Thomas Gleixner <tglx@linutronix.de>, Alexios Zavras <alexios.zavras@intel.com>, Dan Carpenter <dan.carpenter@oracle.com>, Max Filippov <jcmvbkbc@gmail.com>, Matt Sickler <Matt.Sickler@daktronics.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Keith Busch <keith.busch@intel.com>, YueHaibing <yuehaibing@huawei.com>, linux-media@vger.kernel.org, linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org, kvm@vger.kernel.org, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org, bpf@vger.kernel.org, xdp-newbies@vger.kernel.org

On Sun, Jul 14, 2019 at 08:33:57PM -0600, Jens Axboe wrote:
> On 7/14/19 1:08 PM, Bharath Vedartham wrote:
> > diff --git a/fs/io_uring.c b/fs/io_uring.c
> > index 4ef62a4..b4a4549 100644
> > --- a/fs/io_uring.c
> > +++ b/fs/io_uring.c
> > @@ -2694,10 +2694,9 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, void __user *arg,
> >   			 * if we did partial map, or found file backed vmas,
> >   			 * release any pages we did get
> >   			 */
> > -			if (pret > 0) {
> > -				for (j = 0; j < pret; j++)
> > -					put_page(pages[j]);
> > -			}
> > +			if (pret > 0)
> > +				put_user_pages(pages, pret);
> > +
> >   			if (ctx->account_mem)
> >   				io_unaccount_mem(ctx->user, nr_pages);
> >   			kvfree(imu->bvec);
> 
> You handled just the failure case of the buffer registration, but not
> the actual free in io_sqe_buffer_unregister().
> 
> -- 
> Jens Axboe
Yup got it! Thanks! I won't be sending a patch again as fs/io_uring.c
may have larger local changes for put_user_pages.

Thanks
