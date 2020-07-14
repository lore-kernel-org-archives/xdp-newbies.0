Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:50442 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726768AbgGNUsK (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 14 Jul 2020 16:48:10 -0400
Received: by mail-qk1-f197.google.com with SMTP id q6so13876443qke.21
        for <xdp-newbies@vger.kernel.org>; Tue, 14 Jul 2020 13:48:05 -0700 (PDT)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: XDP Software Issue - Payload Matching
In-Reply-To: <4581875c-d5af-3da5-bf01-ce3e404c94dc@gflclan.com>
References: <9f91026d-e3da-ff7c-b2dd-a4a795e6975b@gflclan.com> <878shyg3e9.fsf@toke.dk> <bbf21c58-09b3-b80f-11ab-548b229b9bdb@gflclan.com> <87ftc5ut0q.fsf@toke.dk> <edbf300d-a687-7652-d702-d58be09fd541@gflclan.com> <874ksjuca6.fsf@toke.dk> <a8acdb19-2d7d-43d6-67a7-3ad926ae27c4@gflclan.com> <87tv08j96h.fsf@toke.dk> <4581875c-d5af-3da5-bf01-ce3e404c94dc@gflclan.com>
Date: Tue, 14 Jul 2020 22:48:00 +0200
Message-ID: <87o8ohg6wv.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Christian Deacon <gamemann@gflclan.com>, xdp-newbies@vger.kernel.org

Christian Deacon <gamemann@gflclan.com> writes:

> Hey Toke,
>
>
> I apologize for the long delay on this. A lot has been going on recently!
>
>
> I attempted to match payload data using the packet's payload as the BPF 
> map key. Unfortunately, I didn't have any success with this. I stored my 
> findings here from last month:
>
>
> https://github.com/gamemann/XDP-Dynamic-Payload-Matching#section-methodfour-fail
>
>
> I'd assume I may be missing something here, though.
>
>
> I saw another XDP mailing list thread pop up recently regarding matching 
> TCP payload data. I believe this may be what they're trying to achieve 
> (being able to match dynamic payload data with XDP).
>
>
> I was wondering if you had any other ideas on how we can match packet 
> payload data against a BPF map.

That error ("invalid stack type R2 off=-16 access_size=150") comes from
this check in the verifier:

	if (off >= 0 || off < -MAX_BPF_STACK || off + access_size > 0 ||
	    access_size < 0 || (access_size == 0 && !zero_size_allowed)) {
		if (tnum_is_const(reg->var_off)) {
			verbose(env, "invalid stack type R%d off=%d access_size=%d\n",
				regno, off, access_size);
		} else {
                ..
                }
                return -EACCESS;
        }

which I think means that you're trying to use a 10-byte value as a
lookup key for a map that has a 150-byte key, which would make the
map key read through the end of the stack.

So basically, if you change

uint8_t hashkey[10];

to

uint8_t hashkey[150];

I think it ought to work?

-Toke
