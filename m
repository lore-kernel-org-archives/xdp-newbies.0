Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46914 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726887AbfFXLlH (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 24 Jun 2019 07:41:07 -0400
From: "Eelco Chaudron" <echaudro@redhat.com>
Subject: Re: AF_XDP only releasing from FQ in batches
Date: Mon, 24 Jun 2019 13:41:04 +0200
Message-ID: <A24A4A83-FF34-4BAF-B8ED-814DB12A0625@redhat.com>
In-Reply-To: <CAJ8uoz0nQxXXBwKsVCgK=_oJRgUrnVNNQz_FYQFm93mFCLb29Q@mail.gmail.com>
References: <CAEaYocYhic1UC2p60gO6rzJYzHaHob=0-GUN1Z2e0XgMaPoMBg@mail.gmail.com>
 <28F29E84-6392-4794-A1AB-0566B8ADE5A1@redhat.com>
 <CAJ8uoz0nQxXXBwKsVCgK=_oJRgUrnVNNQz_FYQFm93mFCLb29Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Magnus Karlsson <magnus.karlsson@gmail.com>
Cc: Rafael Vargas <vargas@khomp.com>, xdp-newbies@vger.kernel.org



On 24 Jun 2019, at 13:17, Magnus Karlsson wrote:

> On Mon, Jun 24, 2019 at 12:24 PM Eelco Chaudron <echaudro@redhat.com> 
> wrote:
>>
>>
>>
>> On 21 Jun 2019, at 21:20, Rafael Vargas wrote:
>>
>>> Hi,
>>>
>>> I'm trying to use AF_XDP and I'm using the xdpsock sample
>>> implementation as a guide.
>>>
>>> I've noticed that the Fill Queue slots are released in batches of 16
>>> (kernel 5.1)
>>>
>>> The xdpsock (rx_drop) implementation will lock waiting for the space
>>> in the FQ.
>>> This seems it will work fine when receiving lots of packets, but 
>>> will
>>> loop indefinetely if traffic stops.
>>
>> Yes I was running into the same problem, and you should not wait wait
>> for the free slots, as that will put you in a loop waiting, and not
>> processing packets until 16 are received.
>>
>> This is how I solved it:
>>
>>
>> static void rx_pkts(struct xsk_socket_info *xsk)
>> {
>>         unsigned int rcvd, stock_frames, i;
>>         uint32_t idx_rx = 0, idx_fq = 0;
>>         int ret;
>>
>>         rcvd = xsk_ring_cons__peek(&xsk->rx, RX_BATCH_SIZE, &idx_rx);
>>         if (!rcvd)
>>                 return;
>>
>>         /* Stuff the ring with as much frames as possible */
>>         stock_frames = xsk_ring_prod__free(&xsk->umem->fq);
>>         stock_frames = MIN(stock_frames, xsk_umem_free_frames(xsk));
>>
>>         if (stock_frames > 0) {
>>
>>                 ret = xsk_ring_prod__reserve(&xsk->umem->fq, 
>> stock_frames,
>>                                              &idx_fq);
>>                 while (ret != stock_frames)
>>                         ret = xsk_ring_prod__reserve(&xsk->umem->fq, 
>> rcvd,
>>                                                      &idx_fq);
>>
>>                 for (i = 0; i < stock_frames; i++)
>>                         *xsk_ring_prod__fill_addr(&xsk->umem->fq, 
>> idx_fq++) =
>>                                 xsk_alloc_umem_frame(xsk);
>>
>>                 xsk_ring_prod__submit(&xsk->umem->fq, stock_frames);
>>         }
>>
>>         /* Process received packets */
>>         for (i = 0; i < rcvd; i++) {
>>                 uint64_t addr = xsk_ring_cons__rx_desc(&xsk->rx, 
>> idx_rx)->addr;
>>                 uint32_t len = xsk_ring_cons__rx_desc(&xsk->rx, 
>> idx_rx++)->len;
>>                 char *pkt = xsk_umem__get_data(xsk->umem->buffer, 
>> addr);
>>
>>                 // Handle packet
>>
>>                 xsk_free_umem_frame(xsk, addr);
>>         }
>>
>>         xsk_ring_cons__release(&xsk->rx, rcvd);
>>         xsk->stats.rx_packets += rcvd;
>>    }
>>
>>
>> Where  xsk_ring_prod__free() is as follows (sent patch upstream for
>> adding it as an API):
>
> Eelco,
>
> In the patch you sent, why not make it a patch set by adding these
> improvements (using your new function) to the xdpsock sample app?
> Please :-).

The code above will be part of the 
https://github.com/xdp-project/xdp-tutorial/tree/master/advanced03-AF_XDP 
example I’m working on. Once I finish this, I’ll also try to do a 
backport to the example.

Just need to find some time to finish it :)

>> static inline __u32 xsk_ring_prod__free(struct xsk_ring_prod *r)
>> {
>>         r->cached_cons = *r->consumer + r->size;
>>         return r->cached_cons - r->cached_prod;
>> }
>>
>> And the following is an API around my UMEM frame handling:
>>
>> xsk_umem_free_frames() -> How many buffers do I have available on my
>> stack
>>
>> xsk_free_umem_frame()  -> return a buffer to my buffer stack
>>
>> xsk_alloc_umem_frame() -> Get a buffer from my buffer stack
>>
>>> This is the expected behavior for the FQ?
>>> Should I keep the FQ always with free slots in order to avoid 
>>> blocking
>>> when waiting for more packets?
>>>
>>> Rafael Vargas
