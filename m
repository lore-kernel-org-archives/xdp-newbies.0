Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17475 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727730AbfGRNEl (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 18 Jul 2019 09:04:41 -0400
Date: Thu, 18 Jul 2019 09:04:34 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH] virtio-net: parameterize min ring num_free for virtio
 receive
Message-ID: <20190718085836-mutt-send-email-mst@kernel.org>
References: <BYAPR14MB32056583C4963342F5D817C4A6C80@BYAPR14MB3205.namprd14.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR14MB32056583C4963342F5D817C4A6C80@BYAPR14MB3205.namprd14.prod.outlook.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: ? jiang <jiangkidd@hotmail.com>
Cc: "jasowang@redhat.com" <jasowang@redhat.com>, "davem@davemloft.net" <davem@davemloft.net>, "ast@kernel.org" <ast@kernel.org>, "daniel@iogearbox.net" <daniel@iogearbox.net>, "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>, "hawk@kernel.org" <hawk@kernel.org>, "john.fastabend@gmail.com" <john.fastabend@gmail.com>, "kafai@fb.com" <kafai@fb.com>, "songliubraving@fb.com" <songliubraving@fb.com>, "yhs@fb.com" <yhs@fb.com>, "virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>, "jiangran.jr@alibaba-inc.com" <jiangran.jr@alibaba-inc.com>

On Thu, Jul 18, 2019 at 12:55:50PM +0000, ? jiang wrote:
> This change makes ring buffer reclaim threshold num_free configurable
> for better performance, while it's hard coded as 1/2 * queue now.
> According to our test with qemu + dpdk, packet dropping happens when
> the guest is not able to provide free buffer in avail ring timely.
> Smaller value of num_free does decrease the number of packet dropping
> during our test as it makes virtio_net reclaim buffer earlier.
> 
> At least, we should leave the value changeable to user while the
> default value as 1/2 * queue is kept.
> 
> Signed-off-by: jiangkidd <jiangkidd@hotmail.com>

That would be one reason, but I suspect it's not the
true one. If you need more buffer due to jitter
then just increase the queue size. Would be cleaner.


However are you sure this is the reason for
packet drops? Do you see them dropped by dpdk
due to lack of space in the ring? As opposed to
by guest?


> ---
>  drivers/net/virtio_net.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 0d4115c9e20b..bc190dec6084 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -26,6 +26,9 @@
>  static int napi_weight = NAPI_POLL_WEIGHT;
>  module_param(napi_weight, int, 0444);
>  
> +static int min_numfree;
> +module_param(min_numfree, int, 0444);
> +
>  static bool csum = true, gso = true, napi_tx;
>  module_param(csum, bool, 0444);
>  module_param(gso, bool, 0444);
> @@ -1315,6 +1318,9 @@ static int virtnet_receive(struct receive_queue *rq, int budget,
>  	void *buf;
>  	int i;
>  
> +	if (!min_numfree)
> +		min_numfree = virtqueue_get_vring_size(rq->vq) / 2;
> +
>  	if (!vi->big_packets || vi->mergeable_rx_bufs) {
>  		void *ctx;
>  
> @@ -1331,7 +1337,7 @@ static int virtnet_receive(struct receive_queue *rq, int budget,
>  		}
>  	}
>  
> -	if (rq->vq->num_free > virtqueue_get_vring_size(rq->vq) / 2) {
> +	if (rq->vq->num_free > min_numfree) {
>  		if (!try_fill_recv(vi, rq, GFP_ATOMIC))
>  			schedule_delayed_work(&vi->refill, 0);
>  	}
> -- 
> 2.11.0
