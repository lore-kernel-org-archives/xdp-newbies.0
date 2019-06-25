Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41242 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726661AbfFYHR6 (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 25 Jun 2019 03:17:58 -0400
From: "Eelco Chaudron" <echaudro@redhat.com>
Subject: Re: AF_XDP only releasing from FQ in batches
Date: Tue, 25 Jun 2019 09:17:55 +0200
Message-ID: <B5BA9E40-5217-422B-BE62-A344AE33354F@redhat.com>
In-Reply-To: <CAEaYocaJQ97dqJWT=ydH2Vnz6NY_3xv1oOi1GschHdFRQsrXzw@mail.gmail.com>
References: <CAEaYocYhic1UC2p60gO6rzJYzHaHob=0-GUN1Z2e0XgMaPoMBg@mail.gmail.com>
 <28F29E84-6392-4794-A1AB-0566B8ADE5A1@redhat.com>
 <CAEaYocaJQ97dqJWT=ydH2Vnz6NY_3xv1oOi1GschHdFRQsrXzw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Rafael Vargas <vargas@khomp.com>
Cc: xdp-newbies@vger.kernel.org



On 24 Jun 2019, at 16:30, Rafael Vargas wrote:

> Em seg, 24 de jun de 2019 às 07:21, Eelco Chaudron
> <echaudro@redhat.com> escreveu:
>
>>         /* Stuff the ring with as much frames as possible */
>>         stock_frames = xsk_ring_prod__free(&xsk->umem->fq);
>>         stock_frames = MIN(stock_frames, xsk_umem_free_frames(xsk));
>>
>>         if (stock_frames > 0) {
>>
>>                 ret = xsk_ring_prod__reserve(&xsk->umem->fq, stock_frames,
>>                                              &idx_fq);
>>                 while (ret != stock_frames)
>>                         ret = xsk_ring_prod__reserve(&xsk->umem->fq, rcvd,
>>                                                      &idx_fq);
> once you've checked before the number of free entries, this while is
> still needed?

In theory not, just a safeguard…

>> Where  xsk_ring_prod__free() is as follows (sent patch upstream for
>> adding it as an API):
>>
>> static inline __u32 xsk_ring_prod__free(struct xsk_ring_prod *r)
>> {
>>         r->cached_cons = *r->consumer + r->size;
>>         return r->cached_cons - r->cached_prod;
>> }
>
> this is basically  xsk_prod_nb_free, but always triggering the cache
> refresh, right?

Yes, probably a xsk_prod_nb_free(, xsk_umem_free_frames(xsk)) would work

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
>
> Is this API using another local ring or stack buffer or is it using
> some clever trick I'm not figuring out?

Just a simple array with all the UMEM addresses:


struct xsk_socket_info {
    …

	uint64_t umem_frame_addr[NUM_FRAMES];
	uint32_t umem_frame_free;
}

static uint64_t xsk_alloc_umem_frame(struct xsk_socket_info *xsk)
{
	uint64_t frame;
	if (xsk->umem_frame_free == 0)
		return INVALID_UMEM_FRAME;

	frame = xsk->umem_frame_addr[--xsk->umem_frame_free];
	xsk->umem_frame_addr[xsk->umem_frame_free] = INVALID_UMEM_FRAME;
	return frame;
}

static void xsk_free_umem_frame(struct xsk_socket_info *xsk, uint64_t frame)
{
	assert(xsk->umem_frame_free < NUM_FRAMES);

	xsk->umem_frame_addr[xsk->umem_frame_free++] = frame;
}

static uint64_t xsk_umem_free_frames(struct xsk_socket_info *xsk)
{
	return xsk->umem_frame_free;
}


> I'll try this approach, thanks!
