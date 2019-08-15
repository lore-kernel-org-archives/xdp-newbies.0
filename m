Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44180 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726098AbfHOJz3 (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 15 Aug 2019 05:55:29 -0400
Subject: Re: [PATCH v2] virtio-net: lower min ring num_free for efficiency
References: <BYAPR14MB32058F4B2AD162F5421BB9B4A6AC0@BYAPR14MB3205.namprd14.prod.outlook.com>
From: Jason Wang <jasowang@redhat.com>
Message-ID: <f26c808a-180a-6c85-637c-17629f2906e4@redhat.com>
Date: Thu, 15 Aug 2019 17:55:17 +0800
MIME-Version: 1.0
In-Reply-To: <BYAPR14MB32058F4B2AD162F5421BB9B4A6AC0@BYAPR14MB3205.namprd14.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: ? jiang <jiangkidd@hotmail.com>, "mst@redhat.com" <mst@redhat.com>
Cc: "davem@davemloft.net" <davem@davemloft.net>, "ast@kernel.org" <ast@kernel.org>, "daniel@iogearbox.net" <daniel@iogearbox.net>, "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>, "hawk@kernel.org" <hawk@kernel.org>, "john.fastabend@gmail.com" <john.fastabend@gmail.com>, "kafai@fb.com" <kafai@fb.com>, "songliubraving@fb.com" <songliubraving@fb.com>, "yhs@fb.com" <yhs@fb.com>, "virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>, "jiangran.jr@alibaba-inc.com" <jiangran.jr@alibaba-inc.com>


On 2019/8/15 下午5:42, ? jiang wrote:
> This change lowers ring buffer reclaim threshold from 1/2*queue to budget
> for better performance. According to our test with qemu + dpdk, packet
> dropping happens when the guest is not able to provide free buffer in
> avail ring timely with default 1/2*queue. The value in the patch has been
> tested and does show better performance.
>
> Test setup: iperf3 to generate packets to guest (total 30mins, pps 400k, UDP)
> avg packets drop before: 2842
> avg packets drop after: 360(-87.3%)
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


Acked-by: Jason Wang <jasowang@redhat.com>
