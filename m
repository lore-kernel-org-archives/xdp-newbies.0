Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from fanzine.igalia.com ([91.117.99.155]:43075 "EHLO
        fanzine.igalia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbeK0C7e (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 26 Nov 2018 21:59:34 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon, 26 Nov 2018 17:04:55 +0100
From: Konrad Djimeli <kdjimeli@igalia.com>
Subject: Re: AF_XDP socket (sock2) unable to read, after writing with another
 AF_XDP socket (sock1)
In-Reply-To: <CAJ+HfNhdtpqQHPq8=DTtwduL-g6SQT01JZsEWmCQQeLUhXRh8w@mail.gmail.com>
References: <ad85176a72e82878a4073a4215aa5e3a@igalia.com>
 <CAJ+HfNjfCNt+M+=bJe60JOPmTJ9q=cvf6DCC=FK0aNdY-6po5g@mail.gmail.com>
 <a0c74144c8f15c10991f9cc15e8f7343@igalia.com>
 <CAJ+HfNhdtpqQHPq8=DTtwduL-g6SQT01JZsEWmCQQeLUhXRh8w@mail.gmail.com>
Message-ID: <9048f6bb806c304588e89aba8456fc22@igalia.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: =?UTF-8?Q?Bj=C3=B6rn_T=C3=B6pel?= <bjorn.topel@gmail.com>
Cc: xdp-newbies@vger.kernel.org

Hello Björn,

On 2018-11-10 15:31, Björn Töpel wrote:
> Den tors 8 nov. 2018 kl 16:15 skrev Konrad Djimeli <kdjimeli@igalia.com>:
>>
> [...]
>> > In terms of correctness:
>> >
>> > In 3. you pass the same UMEM indicies to the Tx ring (ids={0,
>> > FRAME_SIZE, 2*FRAME_SIZE, ...}), as you have passed to the fill
>> > ring. This is not correct. Userspace to track what ids are owned by
>> > the user and by the kernel. Now, both the fill ring and Tx ring
>> > contain the same id.
>> Please I have been looking into this for some days now, but I have not
>> been able to understand what you where referring to and how to fix it.
>>
> 
> Ok, let's talk about the basics, and hopefully it will clear up. The
> indicies/ids into the UMEM are used to point out packet buffers.
> 
> The Rx/Tx/Completion/Fill rings are used to pass ownership between the
> kernel and the user application. E.g. if fill id X with data and pass
> that to the kernel for transmission, the application has passed
> ownership of buffer X to the kernel. The application cannot (well,
> shouldn't) touch the buffer pointed out by X until the kernel is done
> with the buffer -- in other words, when the buffer is passed back to
> the application via the completion ring. Analogous, when you pass id Y
> to the fill ring, Y is owned by the kernel. The application cannot
> (again, shouldn't) touch the data pointed out by Y until ownership is
> passed back to the application via the Rx ring.
> 
> What you did in your old code (I haven't looked at your updates!) is
> that you passed X, Y and Z to the fill ring. And then, prior obtaining
> ownership of the buffers, you passed X, Y and Z to the Tx ring.
> 

Sorry for the delayed response, I took some time off from the work I was
doing. Thanks a lot for the detailed explanation and I think I have been

able to identify the issue you were pointing out.

What I have done to address the problem is, since the location passed to

the fill ring are  {0, 2*FRAME_SIZE, 3*FRAME_SIZE, … , 
(NUM_DESCS-1)*FRAME_SIZE}, I updated the ids passed to the tx ring to 
{NUM_DESCS*FRAME_SIZE,  (NUM_DESCS+1)*FRAME_SIZE,
(NUM_DESCS+2)*FRAME_SIZE, … , 
(NUM_FRAMES-1)*FRAME_SIZE} [0].

The link below points to the commit addressing the issue. I hope I have
not
still gotten things mixedup. 

[0]
https://github.com/djkonro/afxdp/commit/c199b496ac6949771fc02260165f4822ccd2f51a#diff-e1b95b7ab6213d7c19f2eacc1290f955

Thanks,
Konrad

>> I also updated the xdp program bpf_redirect_map index to write to the
>> second socket (sock2) but I can not observe the reading working when I
>> use any other networking interface except for the 'lo' interface. I
>> would like to inquire if it may have something to do with the code.
>> - https://github.com/djkonro/afxdp/blob/master/xdpsock/xdpsock_kern.c
>> - https://github.com/djkonro/afxdp/blob/master/xdpsock/xdpsock_user.c
>>
> 
> If you rely on that all sent packets out to a certain interface should
> be hairpinned back to same interface, you need to set that up in your
> switching plane. Or continue to use the loopback interface as you
> do(?).
> 
> 
> Björn
> 
> 
>> Thanks
>> Konrad
>>
>> >
>> > I'm not sure what the expected output of your program should be? Have
>> > you verified that packets are being sent? Is the inferface/queue 0
>> > receiving packets?
>> >
>> > I think it would help if you explained what you are trying to do
>> > first!
>> >
>> > What XDP program are you running?
>> >
>> >
>> > Cheers,
>> > Björn
>> >
>> >
>> >
>> > *
>> >
>> >> Thanks,
>> >> Konrad
>> >> www.djimeli.me
