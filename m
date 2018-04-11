Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:52748 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751991AbeDKBuq (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 10 Apr 2018 21:50:46 -0400
Subject: Re: XDP_TX for virtio_net not working in recent kernel?
References: <47428621-2f24-3c8e-5d34-1d788a86a455@nii.ac.jp>
 <1d5849ae-a9ec-93af-e1b5-e7a368193c7a@iogearbox.net>
From: Jason Wang <jasowang@redhat.com>
Message-ID: <ce812367-596a-0354-f008-725225f65af4@redhat.com>
Date: Wed, 11 Apr 2018 09:50:40 +0800
MIME-Version: 1.0
In-Reply-To: <1d5849ae-a9ec-93af-e1b5-e7a368193c7a@iogearbox.net>
Content-Type: multipart/mixed;
 boundary="------------CE91B38A226B0C2B2B44D1DF"
Content-Language: en-US
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Daniel Borkmann <daniel@iogearbox.net>, Kimitoshi Takahashi <ktaka@nii.ac.jp>
Cc: xdp-newbies@vger.kernel.org, netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------CE91B38A226B0C2B2B44D1DF
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2018年04月10日 18:17, Daniel Borkmann wrote:
> [ +jason +netdev ]
>
> On 04/10/2018 12:49 AM, Kimitoshi Takahashi wrote:
>> Hello,
>>
>> I'm totally newbie.
>>
>> I want to try some examples under the samples/bpf of the kernel tree using the virtio_net driver in kvm, in order to get familiar with the XDP. However, it seems to me that for kernels newer than linux-4.15, the xdp2 and xdp_tx_tunnel are not working in the case of virtio_net.
>>
>> Can somebody help me out to make them working?
>>
>>
>> 1) For linux-4.11.12, linux-4.12.14, and linux-4.14.31, xdp2 and xdp_tx_tunnel are working.
>>
>> [xdp2]
>> 10.0.0.27# ./xdp2 2 (or ./xdp -N 2)
>>
>> 10.0.0.254# hping3 10.0.0.27 -p 5000 -2
>>
>> 10.0.0.254# tcpdump -nei kbr0 udp port 5000
>> 06:18:37.677070 2e:c9:83:fb:5b:f3 > 52:54:00:11:00:1b, ethertype IPv4 (0x0800), length 42: 10.0.0.254.2982 > 10.0.0.27.5000: UDP, length 0
>> 06:18:37.677265 52:54:00:11:00:1b > 2e:c9:83:fb:5b:f3, ethertype IPv4 (0x0800), length 42: 10.0.0.254.2982 > 10.0.0.27.5000: UDP, length 0
>>
>> I can see the UDP packets with MAC addresses swapped.
>>
>> [xdp_tx_tunnel]
>>
>> 10.0.0.254# telnet 10.1.2.1 80
>>
>> 10.0.0.27# ./xdp_tx_iptunnel -i 2 -a 10.1.2.1 -p 80 -s 10.0.0.27 -d 10.0.0.24 -m 52:54:00:11:00:18
>>
>> 10.0.0.24# tcpdump -nei any proto 4
>> 22:08:20.510354  In 52:54:00:11:00:1b ethertype IPv4 (0x0800), length 96: 10.0.0.27 > 10.0.0.24: 10.0.0.254.60826 > 10.1.2.1.80: Flags [S], seq 3224377720, win 29200, options [mss 1460,sackOK,TS val 217801953 ecr 0,nop,wscale 7], length 0 (ipip-proto-4)
>>
>> I can see the encapsulated SYN packet that is forwarded by the 10.0.0.27.
>>
>> 2) For linux-4.15, linux-4.15.5, linux-4.15.13 and linux-4.16.1, xdp2 and xdp_tx_tunnel are NOT working.
>>
>> [xdp2]
>> 10.0.0.27# ./xdp2 -N 2
>>
>> 10.0.0.254# hping3 10.0.0.27 -p 5000 -2
>>
>> 10.0.0.254# tcpdump -nei br0 udp port 5000
>> 06:45:34.810046 2e:c9:83:fb:5b:f3 > 52:54:00:11:00:1b, ethertype IPv4 (0x0800), length 42: 10.0.0.254.2346 > 10.0.0.27.5000: UDP, length 0
>> 06:45:35.810176 2e:c9:83:fb:5b:f3 > 52:54:00:11:00:1b, ethertype IPv4 (0x0800), length 42: 10.0.0.254.2347 > 10.0.0.27.5000: UDP, length 0
>>
>> Only the outgoing packets can be seen.
>>
>> [xdp_tx_tunnel]
>>
>> 10.0.0.254# telnet 10.1.2.1 80
>>
>> 10.0.0.27# ./xdp_tx_iptunnel -i 2 -a 10.1.2.1 -p 80 -s 10.0.0.27 -d 10.0.0.24 -m 52:54:00:11:00:18
>>
>> 10.0.0.24# tcpdump -nei any proto 4
>>
>> I can NOT see the encapsulated SYN packet that is forwarded by the 10.0.0.27.
>>
>>
>> -- 
>> Sincerely,
>> Takahashi Kimitoshi

I suspect a kick is missed in the XDP_TX case.

Could you please try the attached patch to see if it fixes the issue?

Thanks

--------------CE91B38A226B0C2B2B44D1DF
Content-Type: text/x-patch;
 name="0001-virtio-net-add-missing-virtqueue-kick-when-flushing-.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-virtio-net-add-missing-virtqueue-kick-when-flushing-.pa";
 filename*1="tch"

From f37d74d65671e1a1f1a0c4dd59bf1df69b47f30a Mon Sep 17 00:00:00 2001
From: Jason Wang <jasowang@redhat.com>
Date: Mon, 22 Jan 2018 17:07:03 +0800
Subject: [PATCH] virtio-net: add missing virtqueue kick when flushing packets

We tends to batch submitting packets during XDP_TX. This requires to
kick virtqueue after a batch, we tried to do it through
xdp_do_flush_map() which only makes sense for devmap not XDP_TX. So
explicitly kick the virtqueue in this case.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/net/virtio_net.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 2337460..d8e1aea 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1269,7 +1269,9 @@ static int virtnet_poll(struct napi_struct *napi, int budget)
 {
 	struct receive_queue *rq =
 		container_of(napi, struct receive_queue, napi);
-	unsigned int received;
+	struct virtnet_info *vi = rq->vq->vdev->priv;
+	struct send_queue *sq;
+	unsigned int received, qp;
 	bool xdp_xmit = false;
 
 	virtnet_poll_cleantx(rq);
@@ -1280,8 +1282,13 @@ static int virtnet_poll(struct napi_struct *napi, int budget)
 	if (received < budget)
 		virtqueue_napi_complete(napi, rq->vq, received);
 
-	if (xdp_xmit)
+	if (xdp_xmit) {
+		qp = vi->curr_queue_pairs - vi->xdp_queue_pairs +
+		     smp_processor_id();
+		sq = &vi->sq[qp];
+		virtqueue_kick(sq->vq);
 		xdp_do_flush_map();
+	}
 
 	return received;
 }
-- 
2.7.4


--------------CE91B38A226B0C2B2B44D1DF--
