Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42222 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728014AbfHODBL (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 14 Aug 2019 23:01:11 -0400
Subject: Re: [PATCH] virtio-net: lower min ring num_free for efficiency
References: <BYAPR14MB3205E4E194942B0A1A91A222A6AD0@BYAPR14MB3205.namprd14.prod.outlook.com>
From: Jason Wang <jasowang@redhat.com>
Message-ID: <f61d9621-cc33-44a2-f297-43f8af8d759b@redhat.com>
Date: Thu, 15 Aug 2019 11:01:00 +0800
MIME-Version: 1.0
In-Reply-To: <BYAPR14MB3205E4E194942B0A1A91A222A6AD0@BYAPR14MB3205.namprd14.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: ? jiang <jiangkidd@hotmail.com>, "mst@redhat.com" <mst@redhat.com>
Cc: "davem@davemloft.net" <davem@davemloft.net>, "ast@kernel.org" <ast@kernel.org>, "daniel@iogearbox.net" <daniel@iogearbox.net>, "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>, "hawk@kernel.org" <hawk@kernel.org>, "john.fastabend@gmail.com" <john.fastabend@gmail.com>, "kafai@fb.com" <kafai@fb.com>, "songliubraving@fb.com" <songliubraving@fb.com>, "yhs@fb.com" <yhs@fb.com>, "virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>, "jiangran.jr@alibaba-inc.com" <jiangran.jr@alibaba-inc.com>


On 2019/8/14 上午10:06, ? jiang wrote:
> This change lowers ring buffer reclaim threshold from 1/2*queue to budget
> for better performance. According to our test with qemu + dpdk, packet
> dropping happens when the guest is not able to provide free buffer in
> avail ring timely with default 1/2*queue. The value in the patch has been
> tested and does show better performance.


Please add your tests setup and result here.

Thanks


>
> Signed-off-by: jiangkidd <jiangkidd@hotmail.com>
> ---
>   drivers/net/virtio_net.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 0d4115c9e20b..bc08be7925eb 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1331,7 +1331,7 @@ static int virtnet_receive(struct receive_queue *rq, int budget,
>   		}
>   	}
>   
> -	if (rq->vq->num_free > virtqueue_get_vring_size(rq->vq) / 2) {
> +	if (rq->vq->num_free > min((unsigned int)budget, virtqueue_get_vring_size(rq->vq)) / 2) {
>   		if (!try_fill_recv(vi, rq, GFP_ATOMIC))
>   			schedule_delayed_work(&vi->refill, 0);
>   	}
