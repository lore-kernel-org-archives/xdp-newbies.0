Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54550 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726608AbfGROBY (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 18 Jul 2019 10:01:24 -0400
Subject: Re: [PATCH] virtio-net: parameterize min ring num_free for virtio
 receive
References: <BYAPR14MB32056583C4963342F5D817C4A6C80@BYAPR14MB3205.namprd14.prod.outlook.com>
 <20190718085836-mutt-send-email-mst@kernel.org>
From: Jason Wang <jasowang@redhat.com>
Message-ID: <bdd30ef5-4f69-8218-eed0-38c6daac42db@redhat.com>
Date: Thu, 18 Jul 2019 22:01:05 +0800
MIME-Version: 1.0
In-Reply-To: <20190718085836-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: "Michael S. Tsirkin" <mst@redhat.com>, ? jiang <jiangkidd@hotmail.com>
Cc: "davem@davemloft.net" <davem@davemloft.net>, "ast@kernel.org" <ast@kernel.org>, "daniel@iogearbox.net" <daniel@iogearbox.net>, "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>, "hawk@kernel.org" <hawk@kernel.org>, "john.fastabend@gmail.com" <john.fastabend@gmail.com>, "kafai@fb.com" <kafai@fb.com>, "songliubraving@fb.com" <songliubraving@fb.com>, "yhs@fb.com" <yhs@fb.com>, "virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>, "jiangran.jr@alibaba-inc.com" <jiangran.jr@alibaba-inc.com>


On 2019/7/18 下午9:04, Michael S. Tsirkin wrote:
> On Thu, Jul 18, 2019 at 12:55:50PM +0000, ? jiang wrote:
>> This change makes ring buffer reclaim threshold num_free configurable
>> for better performance, while it's hard coded as 1/2 * queue now.
>> According to our test with qemu + dpdk, packet dropping happens when
>> the guest is not able to provide free buffer in avail ring timely.
>> Smaller value of num_free does decrease the number of packet dropping
>> during our test as it makes virtio_net reclaim buffer earlier.
>>
>> At least, we should leave the value changeable to user while the
>> default value as 1/2 * queue is kept.
>>
>> Signed-off-by: jiangkidd<jiangkidd@hotmail.com>
> That would be one reason, but I suspect it's not the
> true one. If you need more buffer due to jitter
> then just increase the queue size. Would be cleaner.
>
>
> However are you sure this is the reason for
> packet drops? Do you see them dropped by dpdk
> due to lack of space in the ring? As opposed to
> by guest?
>
>

Besides those, this patch depends on the user to choose a suitable 
threshold which is not good. You need either a good value with 
demonstrated numbers or something smarter.

Thanks
