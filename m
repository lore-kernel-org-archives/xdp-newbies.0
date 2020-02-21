Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:26771 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730376AbgBUIkc (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 21 Feb 2020 03:40:32 -0500
From: "Eelco Chaudron" <echaudro@redhat.com>
Subject: Re: xdpsock poll syscall CPU 100%
Date: Fri, 21 Feb 2020 09:40:23 +0100
Message-ID: <FA00F7E2-E4E2-413B-9CC0-93AB2BA861A2@redhat.com>
In-Reply-To: <CAJ8uoz3t6mKVr+aHx_WDkPg66_wTSsMNySzWny9JhCR1VG7mBA@mail.gmail.com>
References: <CALDO+SZmCxtWCeqh93HO6vm1KHh_UGxMby+td2ba_o66ZT+MVQ@mail.gmail.com>
 <28C7C59E-0ED6-4331-8547-952419F20D1F@redhat.com>
 <CAJ8uoz3t6mKVr+aHx_WDkPg66_wTSsMNySzWny9JhCR1VG7mBA@mail.gmail.com>
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: quoted-printable
To: Magnus Karlsson <magnus.karlsson@gmail.com>
Cc: William Tu <u9012063@gmail.com>, Xdp <xdp-newbies@vger.kernel.org>, "Karlsson, Magnus" <magnus.karlsson@intel.com>, =?utf-8?b?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>



On 21 Feb 2020, at 9:33, Magnus Karlsson wrote:

> On Fri, Feb 21, 2020 at 9:30 AM Eelco Chaudron <echaudro@redhat.com>=20
> wrote:
>>
>>
>>
>> On 20 Feb 2020, at 23:49, William Tu wrote:
>>
>>> Hi,
>>>
>>> I'm trying to save some CPU cycles when there is no packet arrives.
>>> I enable the poll syscall option of xdpsock, by doing
>>>
>>> $ ./xdpsock -r -p -S -i ens16
>>>  sock0@ens160:0 rxdrop xdp-skb poll()
>>>                 pps         pkts        1.00
>>> rx              0           0
>>> tx              0           0
>>>
>>> Since there is no packet coming, I though by calling poll()
>>> system call, the xdpsock process will be blocked and CPU utilization
>>> should be way under 100%. However, I'm still seeing 100%
>>> CPU utilization. Am I understanding this correctly?
>>
>> Hi William, I can remember I saw this in the past two with this code.=20
>> It
>> had something to do with the way xdpsock waits for the buffers to be
>> free=E2=80=99 ed by the kernel. What I can remember it had something to =
do
>> with the veth interfaces also.
>>
>> I do remember that I fixed it in the tutorial for AF_XDP:
>> https://github.com/xdp-project/xdp-tutorial/blob/master/advanced03-AF_XD=
P/af_xdp_user.c
>
> Eelco,
>
> Do you remember exactly what you had to fix in the xdpsock sample?
> Your tutorial is quite a rewrite so it is hard for me to tell exactly
> which of all the changes that fix this problem. The reason I ask is
> that it would be nice to fix this in the sample too.
>
> Thanks: Magnus

 From an earlier email conversation we had this is where it looped in my=20
case:

>>>>> One other thing I noticed, which I need to research is that if I
>>>>> use
>>>>> rx_drop() function from /xdpsock_user.c it loops a lot in:
>>>>>
>>>>>   =09while (ret !=3D rcvd) {
>>>>>    =09=09if (ret < 0) {
>>>>> =09  =09=09=09exit(-1);
>>>>> =09=09}
>>>>>    =09=09ret =3D xsk_ring_prod__reserve(&xsk->umem-
>>> fq, rcvd, &idx_fq);
>>>>>
>>>>>    =09}
>>>>>
>>>>> As ret return 0, until (it looks like) I send more packets. So=20
>>>>> even
>>>>> in the poll() mode, it uses 100% cpu after sending a single=20
>>>>> packet.
>>>>> Note this is with the default Fedora Kernel, as I=E2=80=99m working o=
n=20
>>>>> this
>>>>> from my laptop. Does this sound familiar? If not I=E2=80=99ll dig int=
o=20
>>>>> it
>>>>> once I=E2=80=99m back.
>>>>
>>>> The xdpsock test is a busypolling test, to compare against DPDK
>>>> speeds.  For real use-cases, I think people will want to trade-off
>>>> latency vs. burning CPU.
>>>
>>> I understand the use case, but even with the xdpsock test program,=20
>>> if
>>> I send a single packet it=E2=80=99s not received, or at least not when=
=20
>>> it's
>>> sent. It takes 16 (or a multiple of it) before the get
>>> detected/processed. I think it=E2=80=99s because of the
>>> xsk_ring_prod__reserve(), but I=E2=80=99ll try to debug it more today a=
nd=20
>>> to
>>> understand the APIs better.
