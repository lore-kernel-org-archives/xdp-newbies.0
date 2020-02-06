Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-db8eur05on2043.outbound.protection.outlook.com ([40.107.20.43]:16448
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727398AbgBFO4c (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 6 Feb 2020 09:56:32 -0500
Subject: Re: zero-copy between interfaces
References: <CAJ8uoz1FcfDYa1PaQuY-Yk+keEX5FT6+q2H2eLTce6DxcQjuiA@mail.gmail.com>
 <20200114205250.GA85903@smtp.ads.isi.edu>
 <20200115014137.GA105434@smtp.ads.isi.edu>
 <CAJ8uoz2VTXAT9ryF9Ls2JjacEw0Bc23t9w2jDEoMdA0dRc6Aaw@mail.gmail.com>
 <CAJ8uoz1Nf+Fsg40tfdnMenFiCjRBJN9maY9rVo--trt+Uwkqwg@mail.gmail.com>
 <20200116020414.GA46831@smtp.ads.isi.edu>
 <CAJ8uoz0yqYTq+OOK8p0XRcWyMkfnJ1ZT7hUew9w3FuHr=4K-QQ@mail.gmail.com>
 <4c03813d-5edf-7e9e-8905-31902b5acb71@mellanox.com>
 <20200122214352.GA13201@smtp.ads.isi.edu>
 <b1b9342b-b9e5-f576-c06c-3a43dcf2b189@mellanox.com>
 <CAJ8uoz1wuCmPehXNX2_OddF2YC=2mNaFZC4f+6j9VkmSTSPaQQ@mail.gmail.com>
 <HE1PR0501MB2570108E0E186FEE0A09D668D1040@HE1PR0501MB2570.eurprd05.prod.outlook.com>
 <CAJ8uoz1kkj8Fb+dg4RFDO+CpXhDs=70fb1DrTubgO+tKg0zTpg@mail.gmail.com>
 <CAJ8uoz2FsPY=Q2ab6wqHhpaaEFmsi3F8gga2OfLUUSQuRZvuHw@mail.gmail.com>
 <CAJ8uoz0Ucw82B1Cq9KCTVu_=O5p6ETxqwL=awmkcG1A=XF=irw@mail.gmail.com>
 <CAJ8uoz2PDcTNghzcWOcst0yDpuOEEW5P21LH1=+wF2xDo7TpWQ@mail.gmail.com>
From: Maxim Mikityanskiy <maximmi@mellanox.com>
Message-ID: <9600c57c-fe7a-0520-9b67-af521947cc79@mellanox.com>
Date: Thu, 6 Feb 2020 16:56:16 +0200
In-Reply-To: <CAJ8uoz2PDcTNghzcWOcst0yDpuOEEW5P21LH1=+wF2xDo7TpWQ@mail.gmail.com>
Content-Language: en-US
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
To: Magnus Karlsson <magnus.karlsson@gmail.com>
Cc: Ryan Goodfellow <rgoodfel@isi.edu>, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, Tariq Toukan <tariqt@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, Moshe Shemesh <moshe@mellanox.com>

On 2020-02-05 15:31, Magnus Karlsson wrote:
> On Tue, Feb 4, 2020 at 5:10 PM Magnus Karlsson
> <magnus.karlsson@gmail.com> wrote:
>>
>> On Thu, Jan 30, 2020 at 12:40 PM Magnus Karlsson
>> <magnus.karlsson@gmail.com> wrote:
>>>
>>> On Thu, Jan 30, 2020 at 10:59 AM Magnus Karlsson
>>> <magnus.karlsson@gmail.com> wrote:
>>>>
>>>> On Thu, Jan 30, 2020 at 10:37 AM Maxim Mikityanskiy
>>>> <maximmi@mellanox.com> wrote:
>>>>>
>>>>>> -----Original Message-----
>>>>>> From: Magnus Karlsson <magnus.karlsson@gmail.com>
>>>>>> Sent: 27 January, 2020 17:55
>>>>>> To: Maxim Mikityanskiy <maximmi@mellanox.com>
>>>>>> Cc: Ryan Goodfellow <rgoodfel@isi.edu>; xdp-newbies@vger.kernel.org;=
 Tariq
>>>>>> Toukan <tariqt@mellanox.com>; Saeed Mahameed <saeedm@mellanox.com>; =
Moshe
>>>>>> Shemesh <moshe@mellanox.com>
>>>>>> Subject: Re: zero-copy between interfaces
>>>>>>
>>>>>> On Mon, Jan 27, 2020 at 3:01 PM Maxim Mikityanskiy <maximmi@mellanox=
.com>
>>>>>> wrote:
>>>>>>>
>>>>>>> On 2020-01-22 23:43, Ryan Goodfellow wrote:
>>>>>>>> On Tue, Jan 21, 2020 at 01:40:50PM +0000, Maxim Mikityanskiy wrote=
:
>>>>>>>>>>> I've posted output from the program in debugging mode here
>>>>>>>>>>>
>>>>>>>>>>> - https://gitlab.com/mergetb/tech/network-
>>>>>> emulation/kernel/snippets/1930375
>>>>>>>>>>>
>>>>>>>>>>> Yes, you are correct in that forwarding works for a brief perio=
d and
>>>>>> then stops.
>>>>>>>>>>> I've noticed that the number of packets that are forwarded is e=
qual
>>>>>> to the size
>>>>>>>>>>> of the producer/consumer descriptor rings. I've posted two ping
>>>>>> traces from a
>>>>>>>>>>> client ping that shows this.
>>>>>>>>>>>
>>>>>>>>>>> - https://gitlab.com/mergetb/tech/network-
>>>>>> emulation/kernel/snippets/1930376
>>>>>>>>>>> - https://gitlab.com/mergetb/tech/network-
>>>>>> emulation/kernel/snippets/1930377
>>>>>>>>>
>>>>>>>>> These snippets are not available.
>>>>>>>>
>>>>>>>> Apologies, I had the wrong permissions set. They should be availab=
le
>>>>>> now.
>>>>>>>>
>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>> I've also noticed that when the forwarding stops, the CPU usage=
 for
>>>>>> the proc
>>>>>>>>>>> running the program is pegged, which is not the norm for this p=
rogram
>>>>>> as it uses
>>>>>>>>>>> a poll call with a timeout on the xsk fd.
>>>>>>>>>
>>>>>>>>> This information led me to a guess what may be happening. On the =
RX
>>>>>>>>> side, mlx5e allocates pages in bulks for performance reasons and =
to
>>>>>>>>> leverage hardware features targeted to performance. In AF_XDP mod=
e,
>>>>>>>>> bulking of frames is also used (on x86, the bulk size is 64 with
>>>>>>>>> striding RQ enabled, and 8 otherwise, however, it's implementatio=
n
>>>>>>>>> details that might change later). If you don't put enough frames =
to XSK
>>>>>>>>> Fill Ring, the driver will be demanding more frames and return fr=
om
>>>>>>>>> poll() immediately. Basically, in the application, you should put=
 as
>>>>>>>>> many frames to the Fill Ring as you can. Please check if that cou=
ld be
>>>>>>>>> the root cause of your issue.
>>>>>>>>
>>>>>>>> The code in this application makes an effort to relenish the fill =
ring
>>>>>> as fast
>>>>>>>> as possible. The basic loop of the application is to first check i=
f
>>>>>> there are
>>>>>>>> any descriptors to be consumed from the completion queue or any
>>>>>> descriptors that
>>>>>>>> can be added to the fill queue, and only then to move on to moving
>>>>>> packets
>>>>>>>> through the rx and tx rings.
>>>>>>>>
>>>>>>>> https://gitlab.com/mergetb/tech/network-emulation/kernel/blob/v5.5=
-
>>>>>> moa/samples/bpf/xdpsock_multidev.c#L452-474
>>>>>>>
>>>>>>> I reproduced your issue and did my investigation, and here is what =
I
>>>>>> found:
>>>>>>>
>>>>>>> 1. Commit df0ae6f78a45 (that you found during bisect) introduces an
>>>>>>> important behavioral change (which I thought was not that important=
).
>>>>>>> xskq_nb_avail used to return min(entries, dcnt), but after the chan=
ge it
>>>>>>> just returns entries, which may be as big as the ring size.
>>>>>>>
>>>>>>> 2. xskq_peek_addr updates q->ring->consumer only when q->cons_tail
>>>>>>> catches up with q->cons_head. So, before that patch and one previou=
s
>>>>>>> patch, cons_head - cons_tail was not more than 16, so the consumer =
index
>>>>>>> was updated periodically. Now consumer is updated only when the who=
le
>>>>>>> ring is exhausted.
>>>>>>>
>>>>>>> 3. The application can't replenish the fill ring if the consumer in=
dex
>>>>>>> doesn't move. As a consequence, refilling the descriptors by the
>>>>>>> application can't happen in parallel with using them by the driver.=
 It
>>>>>>> should have some performance penalty and possibly even lead to pack=
et
>>>>>>> drops, because the driver uses all the descriptors and only then
>>>>>>> advances the consumer index, and then it has to wait until the
>>>>>>> application refills the ring, busy-looping and losing packets.
>>>>>>
>>>>>> This will happen if user space always fills up the whole ring, which
>>>>>> might or might not happen all depending on the app.
>>>>>
>>>>> Yes, that's right, and as far as I know, it's common to fill as many
>>>>> frames as the application can (there was no reason to do it other way
>>>>> till now).
>>>>>
>>>>>> With that said, it
>>>>>> might provide better performance to update it once in a while. It
>>>>>> might also be the case that we will get better performance with the
>>>>>> new scheme if we only fill half the fill ring.
>>>>>
>>>>> Yes, it may improve performance. However, I don't think it's correct =
to
>>>>> set such a limitation on the app.
>>>
>>> Actually, a much worse limitation to put on an application is to say
>>> that you have to have a certain amount of buffers on some ring for the
>>> zero-copy feature to work. For example that we need at least 64
>>> buffers on the fill ring for all the NIC cards to work in zero-copy
>>> mode. That would be a bad thing to have to put in the documentation.
>>> An OS is supposed to abstract away HW differences, and with this
>>> current limitation in your driver, it shines through for sure. What we
>>> would like to put in the documentation is a statement along the lines
>>> of: "for best performance, make sure you have plenty of buffers on the
>>> fill ring so that the NIC can work as efficiently as possible". Not a
>>> statement that it does not work on Mellanox unless you put enough
>>> buffers on the fill ring. So my advice (and wish) is that you fix this
>>> in your driver. With that said, I will still look into what is the
>>> best way to get at least the sample to work for you. But there is no
>>> way to make sure every single app works for you in zero-copy mode,
>>> unless you support arbitrary amount of buffers on the fill ring. I
>>> guess that sooner or later, a customer of yours will get into this
>>> situation one way or the other, so why not fix it now.

Hi Magnus,

We made an internal discussion about batching and AF_XDP in mlx5e.

There are two types of RX queues supported by mlx5e: striding RQ and=20
legacy RQ. Which type of RQ is used, depends on the configuration,=20
hardware support and defaults for different NICs, but basically in cases=20
when striding RQ is enabled by default, it's faster than legacy RQ, and=20
this is the case for modern NICs. All RX queues created in the driver=20
are of the same type. Striding RQ has a requirement of allocating in=20
batches, and the batch size is specified on queue creation, so there is=20
no fallback possible for this case. Legacy RQ, on the other hand, does=20
not require batching in XDP use cases, but now we do it anyway for=20
performance reasons and for code unification with non-XDP queues.

I understand your concern that the current API doesn't provide a=20
completely opaque abstraction over the driver. However, we can't just=20
throw away an important performance feature (striding RQ) to support=20
some exotic case of a fill ring with a single frame only. AF_XDP is a=20
framework for high-performance applications, so it's extremely unlikely=20
that an AF_XDP application will only need to receive a single packet.=20
Such applications just won't need AF_XDP. So, given that the issue can't=20
be fixed without disabling striding RQ, and disabling striding RQ will=20
just reduce the performance of all real-world applications, we decided=20
to keep things as is for now, and if a customer complains about it, we=20
will suggest them to disable striding RQ in their configuration, and=20
we'll consider an option of disabling batching in legacy RQ for AF_XDP.

BTW, if the current API can't provide a good enough abstraction over=20
advanced features of mlx5e, maybe we should extend the API somehow?=20
E.g., when need_wakeup for RX goes to "yes", also tell how many frames=20
need to be refilled?

>>> /Magnus
>>>
>>>> I will examine what provides the best performance. On one hand it is
>>>> the number of updates to shared ring state (minimized by current
>>>> scheme) and the ability for the user app to but buffers on the fill
>>>> ring. Stating that putting e.g. half the packets on the fill ring
>>>> provides better performance (for some application) is not a
>>>> limitation. It is performance tuning advise :-).
>>
>> I have now made a set of measurements. First I just made a variation
>> study using the xdpsock app, varying the amount of packets the kernel
>> can withdraw from a consumer ring (fill and Tx) before updating global
>> state. For the 1 core case (app and driver on the same core) the more
>> frequent you do this update, the better. The reason for this is that
>> it costs very little to update the state since the application is not
>> running. And it is beneficial for the app to have a freshly updated
>> state when it starts to execute as it can operate on more packets. For
>> the 2 core case (app on one core, driver on another) it is the
>> complete opposite: the fewer updates to global state, the better. The
>> reason for this is that it costs a lot to update global state as it
>> triggers cache coherency actions between the two cores.
>>
>> What I did then was to compare the current scheme, update only when
>> grabbing new packets, to a new scheme were we also update the global
>> consumer pointer when we are exiting Rx or Tx processing in the NAPI
>> context. On two cores the current scheme gets 0.5 to 1 Mpps more in
>> throughput than also updating the pointer at the end of NAPI. But for
>> 1 core case, the new scheme is the best and generates between 0.2 and
>> 0.3 Mpps more in throughput than the current one. But all in all, the
>> current scheme is more beneficial than the proposed one if we say that
>> both the 1 core and the 2 core case is equally important.
>>
>> Something to note is that the xdpsock application only puts batch size
>> (64) of packets in the fill ring in every iteration, and this might
>> lead to some good pacing for the current scheme and the 2 core case.
>> I.e., we do not get into the case of the fill ring only being full or
>> empty. But I will run this on some real apps to get some more results,
>> and I know that Bj=C3=B6rn has an optimized xdpsock application that put=
s
>> many more packets into the fill queue than 64. This optimization might
>> actually make the new proposal (also updating at the end of NAPI) be
>> better and make the current scheme suffer. We will examine this
>> further and get back.
>=20
> Actually, after some more thought and discussions I think we should
> optimize for the 1 core case, since that is what gives the whole
> system the best performance, provided that you can scale your
> application with instantiation that is. For a 4 core system, 4 x the 1
> core performance > 2 x 2 core performance by a lot. I think that the 1
> core case is the one that is going to be used out there. At least that
> is what I hear and see.
>=20
> So, when the merge window opens I am going to submit a patch that
> updates the consumer pointer when we exit NAPI too. Will increase the
> performance of the 1 core case.

That sounds good to me. It doesn't make sense to update it multiple=20
times per NAPI (in the single core case the application won't run at=20
that time anyway), so once per NAPI is the most frequent, and according=20
to your experiments it should be the most efficient. It should make=20
mlx5e work again. One concern though: you say you are going to submit it=20
to -next, but a kernel with your patches has been released, and it has=20
broken AF_XDP support in mlx5e. I can send a small fix to net that will=20
revert the behavior back to updating the consumer index once every 16=20
frames (so it makes mlx5e work again), and your patch will go on top of=20
my bugfix. Does it sound right to you?

Thanks for taking time to do the tests!

> /Magnus
>=20
>> /Magnus
>>
>>>>>> I will look into this
>>>>>> and see what I get.
>>>>>>
>>>>>>> 4. As mlx5e allocates frames in batches, the consequences are even =
more
>>>>>>> severe: it's a deadlock where the driver waits for the application,=
 and
>>>>>>> vice versa. The driver never reaches the point where cons_tail gets
>>>>>>> equal to cons_head. E.g., if cons_tail + 3 =3D=3D cons_head, and th=
e batch
>>>>>>> size requested by the driver is 8, the driver won't peek anything f=
rom
>>>>>>> the fill ring waiting for difference between cons_tail and cons_hea=
d to
>>>>>>> increase to be at least 8. On the other hand, the application can't=
 put
>>>>>>> anything to the ring, because it still thinks that the consumer ind=
ex is
>>>>>>> 0. As cons_tail never reaches cons_head, the consumer index doesn't=
 get
>>>>>>> updated, hence the deadlock.
>>>>>>
>>>>>> Good thing that you detected this. Maybe I should get a Mellanox car=
d
>>>>>> :-). This is different from how we implemented Intel's drivers that
>>>>>> just work on any batch size. If it gets 3 packets back, it will use
>>>>>> those. How do you deal with the case when the application just puts =
a
>>>>>> single buffer in the fill ring and wants to receive a single packet?
>>>>>
>>>>> mlx5e will wait until the full batch is available. As AF_XDP is inten=
ded
>>>>> for high-performance apps, this scenario is less expected. We prefer =
to
>>>>> leverage our performance features.
>>>>
>>>> That you cannot support all applications on top of AF_XDP with your
>>>> zero-copy support seems broken to me. But I give you that you might
>>>> support all the ones you care about with your current batching
>>>> support. Like you say, most apps will put plenty of buffers on the
>>>> fill ring, so this should not be a problem. Can you not implement some
>>>> slow path for these cases? You must have one for the skb case.
>>>>
>>>>>> Why does the Mellanox driver need a specific batch size? This is jus=
t
>>>>>> for my understanding so we can find a good solution.
>>>>>
>>>>> The main reason is our performance feature called striding RQ. Skippi=
ng
>>>>> all irrelevant details, a batch of 64 pages is posted to the NIC with=
 a
>>>>> single request, and the NIC fills them progressively. This feature is
>>>>> turned on by default on modern NICs, and it's really good for
>>>>> performance.
>>>>>
>>>>> It might be possible to post a smaller batch though, I'm not sure abo=
ut
>>>>> it, it needs to be checked, but anyway it's not something that we wil=
l
>>>>> likely do, because it's a complication of the data path, and if we kn=
ow
>>>>> more frames are coming, it's much better for the performance to wait =
for
>>>>> them, rather than to post several incomplete batches.
>>>>>
>>>>>>> So, in my vision, the decision to remove RX_BATCH_SIZE and periodic
>>>>>>> updates of the consumer index was wrong. It totally breaks mlx5e, t=
hat
>>>>>>> does batching, and it will affect the performance of any driver, be=
cause
>>>>>>> the application can't refill the ring until it gets completely empt=
y and
>>>>>>> the driver starts waiting for frames. I suggest that periodic updat=
es of
>>>>>>> the consumer index should be readded to xskq_cons_peek_addr.
>>>>>>
>>>>>> The reason I wanted to remove RX_BATCH_SIZE is that application
>>>>>> developers complained about it giving rise to counter intuitive
>>>>>> behavior in user space. I will try to dig out the complaints and the
>>>>>> explanations Bj=C3=B6rn and I had to send which it seemed that users=
 really
>>>>>> should not have to care about. It should just work.
>>>>>
>>>>> I think the counter that doesn't update till the very last moment and
>>>>> then advances by the ring size will also be something to complain abo=
ut
>>>>> (and I am the first one to complain :D). Such bursts are not good in =
any
>>>>> case.
>>>>
>>>> Do you have any performance data that shows this scheme is bad for
>>>> performance? The good thing about this scheme is that global state is
>>>> updated less frequently. And the bad thing is what you mentioned. But
>>>> which one has the greatest effect, is the question.
>>>>
>>>>>> I also do not like
>>>>>> to have arbitrary constants like this. Why 16?
>>>>>
>>>>> I believe any batching mechanism has a constant that look arbitrary.
>>>>> This constant should be the golden mean: if it's too small, there is
>>>>> little effect from batching; if it's too big, it gets too bursty.
>>>>>
>>>>> Basically, after your patch it just changed from 16 to the ring size.
>>>>> Maybe we can tie that constant to ring size? Make it ring_size /
>>>>> another_arbitrary_constant? :)
>>>>
>>>> Agreed, I thought about this too. Something tied to ring_size might be
>>>> a good compromise. Will examine this. But I want to base this on
>>>> performance data not idle speculation, so need to run some experiments
>>>> first.
>>>>
>>>> /Magnus
>>>>
>>>>>> Would much prefer not
>>>>>> having to deal with this, unless of course it horribly breaks
>>>>>> something or gives rise to worse performance. Might still be the cas=
e
>>>>>> here, but if not, I would like to remove it.
>>>>>>
>>>>>> Thanks: Magnus
>>>>>>
>>>>>>> Magnus, what do you think of the suggestion above?
>>>>>>>
>>>>>>> Thanks,
>>>>>>> Max
>>>>>>>
>>>>>>>>>
>>>>>>>>> I tracked this issue in our internal bug tracker in case we need =
to
>>>>>>>>> perform actual debugging of mlx5e. I'm looking forward to your fe=
edback
>>>>>>>>> on my assumption above.
>>>>>>>>>
>>>>>>>>>>> The hardware I am using is a Mellanox ConnectX4 2x100G card (MC=
X416A-
>>>>>> CCAT)
>>>>>>>>>>> running the mlx5 driver.
>>>>>>>>>
>>>>>>>>> This one should run without striding RQ, please verify it with et=
htool
>>>>>>>>> --show-priv-flags (the flag name is rx_striding_rq).
>>>>>>>>
>>>>>>>> I do not remember changing this option, so whatever the default is=
, is
>>>>>> what it
>>>>>>>> was running with. I am traveling this week and do not have access =
to
>>>>>> these
>>>>>>>> systems, but will ensure that this flag is set properly when I get=
 back.
>>>>>>>>
>>>>>>>
