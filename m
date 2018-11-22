Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43004 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731618AbeKVMwO (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 22 Nov 2018 07:52:14 -0500
Subject: Re: qemu-kvm XDP forwarding with virtio_net
References: <CAHOxX0xFn2RARhnQeJ3m-+8UWrtD-bN2dn8x_FygCfDKdD3oQQ@mail.gmail.com>
 <d69fbde9-c28a-d5be-a667-c54e3c4f52f3@gmail.com>
 <CAHOxX0zjkCczaav6NfPYLu=ivJYoLCJe_L+3krn3-vr+paNdDA@mail.gmail.com>
 <20181120191412.088c68fb@redhat.com>
From: Jason Wang <jasowang@redhat.com>
Message-ID: <b9da9c67-e31c-f469-6515-c7913a89dd26@redhat.com>
Date: Thu, 22 Nov 2018 10:14:58 +0800
MIME-Version: 1.0
In-Reply-To: <20181120191412.088c68fb@redhat.com>
Content-Type: multipart/mixed;
 boundary="------------2682CCDE7BED723EAC51CAF1"
Content-Language: en-US
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jesper Dangaard Brouer <brouer@redhat.com>, Pavel Popa <pashinho1990@gmail.com>
Cc: dsahern@gmail.com, xdp-newbies@vger.kernel.org

This is a multi-part message in MIME format.
--------------2682CCDE7BED723EAC51CAF1
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit


On 2018/11/21 上午2:14, Jesper Dangaard Brouer wrote:
> On Tue, 20 Nov 2018 16:47:19 +0100
> Pavel Popa <pashinho1990@gmail.com> wrote:
>
>> Well, here's the output from the `ip link` cmd:
>>      3: eth3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 xdp qdisc mq state UP
>>          link/ether 52:54:fc:47:e2:d3 brd ff:ff:ff:ff:ff:ff
>>          prog/xdp id 1 tag 1cd982ef22273bda jited
>>      4: eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 xdp qdisc mq state UP
>>          link/ether 52:54:55:d3:50:ee brd ff:ff:ff:ff:ff:ff
>>          prog/xdp id 1 tag 1cd982ef22273bda jited
>>
>> As you can see, there's the XDP program ID 1 executing on them.
>> However, there's definitely something interesting happening when
>> bpf_fib_lookup() returns BPF_FIB_LKUP_RET_NO_NEIGH, for which my XDP
>> program just returns XDP_PASS while the following line gets printed in
>> kern.log:
>>      eth3: bad gso: type: 164, size: 256


Looks like a bug in virtio-net driver since all gso should be disabled 
on host.

Could you please try the attached patch to see if it fixes the issue?


>>
>> No idea what's wrong here.
>> Also, when bpf_fib_lookup() returns BPF_FIB_LKUP_RET_SUCCESS, for
>> which my XDP program executes bpf_redirect_map(&dev_map,
>> fib_params.ifindex, 0), the following gets printed in
>>
>> /sys/kernel/debug/tracing/trace_pipe:
>>      xdp_redirect_map_err: prog_id=1 action=REDIRECT ifindex=3
>> to_ifindex=0 err=-14 map_id=0 map_index=4
> The err=-14 is -EFAULT.
>
> Notice "ifindex=3" but "to_ifindex=0", which is the problem.  The
> "map_index=4" is correct, but "to_ifindex" does a lookup in the map for
> the net_device->ifindex stored in this map.  It is fairly unlikely that
> you added device with ifindex=0 to map index 4, I presume?
>
> Then I was thinking, maybe the "map_index=4" doesn't contain anything,
> but reading the code, that will return err=-22 (#define EINVAL 22),
> which it not the case.
>
> Assuming that map_index=4 does contain a valid net_device. Following
> the code via __bpf_tx_xdp_map -> dev_map_enqueue, I simply cannot find
> an -EFAULT err return value.
>
> --Jesper
>
>
>> I feel this last one to be somewhat related to the comment here
>> https://elixir.bootlin.com/linux/v4.18.10/source/samples/bpf/xdp_fwd_kern.c#L107.
>> Is it correct? If so, what does this precisely mean? Is there any way
>> to get around with this? Because what I'm doing is simply using the
>> BPF_MAP_TYPE_DEVMAP with the bpf_redirect_map() helper to forward
>> packets between "XDP ports".
>>
>> Il giorno mar 20 nov 2018 alle ore 15:39 David Ahern
>> <dsahern@gmail.com> ha scritto:
>>> On 11/20/18 7:18 AM, Pavel Popa wrote:
>>>> Hi all,
>>>>
>>>> I've implemented a XDP forwarding program using the bpf_fib_lookup()
>>>> helper, and loaded it in the kernel as XDP driver mode (i.e. executed
>>>> at the virtio_net driver level). The only problem is that the
>>>> receiving virtio network interface seems to drop the XDP packet after
>>>> successfully executing my XDP program.
>>>> Kernel: 4.18.10
>>>>
>>>> my_xdp_fwd_kern.c:
>>>> /* made sure this returns 0 (i.e. BPF_FIB_LKUP_RET_SUCCESS) */
>>>> rc = bpf_fib_lookup(ctx, &fib_params, sizeof(fib_params),
>>>> BPF_FIB_LOOKUP_DIRECT);
>>>> /* made sure this returns 4 (i.e. XDP_REDIRECT) */
>>>> rc = bpf_redirect_map(&dev_map, fib_params.ifindex, 0);
>>>> return rc;
>>>>
>>>> I checked that rc is indeed XDP_REDIRECT and that fib_params.ifindex
>>>> is the correct dev index from FIB lookup.
>>>> dev_map is setup by the userspace my_xdp_fwd_user.c component as follows:
>>>> for (i = 1; i < 64; i++)
>>>>      bpf_map_update_elem(devmap_fd, &i, &i, BPF_ANY);
>>>>
>>>> I'm passing the following to the qemu cmd line for the 2 devices I
>>>> want to run XDP on (as stated here
>>>> https://marc.info/?l=xdp-newbies&m=149486931113651&w=2):
>>>> -device virtio-net-pci,mq=on,vectors=18,rx_queue_size=1024,tx_queue_size=512,
>>>> ... ,gso=off,guest_tso4=off,guest_tso6=off,guest_ecn=off,guest_ufo=off
>>>> \
>>>> -device virtio-net-pci,mq=on,vectors=18,rx_queue_size=1024,tx_queue_size=512,
>>>> ... ,gso=off,guest_tso4=off,guest_tso6=off,guest_ecn=off,guest_ufo=off
>>>> \
>>>>
>>>> In the guest enabling also the MultiQueue feature, as stated here
>>>> https://www.linux-kvm.org/page/Multiqueue#Enable_MQ_feature.
>>>> What I'm left with is debugging the virtio_net kernel module by adding
>>>> a bunch of printk() and see what happens, especially here
>>>> https://elixir.bootlin.com/linux/v4.18.10/source/drivers/net/virtio_net.c#L667.
>>>>
>>>> Am I doing something wrong here? What I'm missing?
>>>>   
>>> I believe at this point you can drop the gso,tso,ufo and ecn args. I use
>>> virtio for development and these days start my VMs with only:
>>>
>>> ...,mq=on,guest_csum=off,...


This looks like another bug that guest_cusm was not disabled 
automatically. Let me post a fix for this.

Thanks.


>>>
>>> After that are you installing the xdp program on all interfaces that can
>>> be used for forwarding? ie., if it transmits a packet in XDP mode it
>>> needs the xdp program loaded. For example I use:
>>>
>>> xdp_fwd eth1 eth2 eth3 eth4
>>>
>>>
>>>  From there:
>>>
>>> echo 1 > /sys/kernel/debug/tracing/events/xdp/enable
>>> cat /sys/kernel/debug/tracing/trace_pipe
>>>   
>
>

--------------2682CCDE7BED723EAC51CAF1
Content-Type: text/x-patch;
 name="0001-virtio-net-keep-vnet-header-zeroed-after-processing-.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-virtio-net-keep-vnet-header-zeroed-after-processing-.pa";
 filename*1="tch"

From 7cc197b6f932fe74953ffa1ca1af9d2d5c15dd56 Mon Sep 17 00:00:00 2001
From: Jason Wang <jasowang@redhat.com>
Date: Thu, 22 Nov 2018 10:14:38 +0800
Subject: [PATCH] virtio-net: keep vnet header zeroed after processing XDP

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/net/virtio_net.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 3e2c041d76ac..7f9ccd436b83 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -364,7 +364,8 @@ static unsigned int mergeable_ctx_to_truesize(void *mrg_ctx)
 static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 				   struct receive_queue *rq,
 				   struct page *page, unsigned int offset,
-				   unsigned int len, unsigned int truesize)
+				   unsigned int len, unsigned int truesize,
+				   bool hdr_valid)
 {
 	struct sk_buff *skb;
 	struct virtio_net_hdr_mrg_rxbuf *hdr;
@@ -386,7 +387,8 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 	else
 		hdr_padded_len = sizeof(struct padded_vnet_hdr);
 
-	memcpy(hdr, p, hdr_len);
+	if (hdr_valid)
+		memcpy(hdr, p, hdr_len);
 
 	len -= hdr_len;
 	offset += hdr_padded_len;
@@ -738,7 +740,8 @@ static struct sk_buff *receive_big(struct net_device *dev,
 				   struct virtnet_rq_stats *stats)
 {
 	struct page *page = buf;
-	struct sk_buff *skb = page_to_skb(vi, rq, page, 0, len, PAGE_SIZE);
+	struct sk_buff *skb = page_to_skb(vi, rq, page, 0, len,
+					  PAGE_SIZE, true);
 
 	stats->bytes += len - vi->hdr_len;
 	if (unlikely(!skb))
@@ -841,7 +844,8 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 				rcu_read_unlock();
 				put_page(page);
 				head_skb = page_to_skb(vi, rq, xdp_page,
-						       offset, len, PAGE_SIZE);
+						       offset, len,
+						       PAGE_SIZE, false);
 				return head_skb;
 			}
 			break;
@@ -897,7 +901,8 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 		goto err_skb;
 	}
 
-	head_skb = page_to_skb(vi, rq, page, offset, len, truesize);
+	head_skb = page_to_skb(vi, rq, page, offset, len, truesize,
+			       xdp_prog != NULL);
 	curr_skb = head_skb;
 
 	if (unlikely(!curr_skb))
-- 
2.17.1


--------------2682CCDE7BED723EAC51CAF1--
