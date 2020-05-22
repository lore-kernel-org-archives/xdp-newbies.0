Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:47576 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729929AbgEVPMM (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 22 May 2020 11:12:12 -0400
Received: by mail-ed1-f71.google.com with SMTP id bs5so3812355edb.18
        for <xdp-newbies@vger.kernel.org>; Fri, 22 May 2020 08:12:09 -0700 (PDT)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: XDP Software Issue - Payload Matching
In-Reply-To: <a8acdb19-2d7d-43d6-67a7-3ad926ae27c4@gflclan.com>
References: <9f91026d-e3da-ff7c-b2dd-a4a795e6975b@gflclan.com> <878shyg3e9.fsf@toke.dk> <bbf21c58-09b3-b80f-11ab-548b229b9bdb@gflclan.com> <87ftc5ut0q.fsf@toke.dk> <edbf300d-a687-7652-d702-d58be09fd541@gflclan.com> <874ksjuca6.fsf@toke.dk> <a8acdb19-2d7d-43d6-67a7-3ad926ae27c4@gflclan.com>
Date: Fri, 22 May 2020 17:12:06 +0200
Message-ID: <87tv08j96h.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Christian Deacon <gamemann@gflclan.com>, xdp-newbies@vger.kernel.org
Cc: Jesper Dangaard Brouer <brouer@redhat.com>

Christian Deacon <gamemann@gflclan.com> writes:

> Hey Toke,
>
> I apologize for the delay on this. I've been working on a couple other 
> XDP/BPF projects recently.
>
> Thank you for the information you provided!
>
> Do you know of any open-source projects/examples that uses the method 
> you're suggesting to compare packet data without using for/while loops? 
> I haven't tried implementing the code yet, but I'm not entirely sure how 
> I am going to do so.

Well, having a map that uses IP addresses as lookup key is kinda the
same, I suppose, it's just a very limited part of the payload that's
being used as the key. But other than that, no, please consider this a
completely off-the-top-of-my-head idea with no warranties, implied or
otherwise :)

-Toke
