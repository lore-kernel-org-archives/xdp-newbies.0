Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:35110 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726244AbgBUJX4 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 21 Feb 2020 04:23:56 -0500
From: "Eelco Chaudron" <echaudro@redhat.com>
Subject: Re: xdpsock poll syscall CPU 100%
Date: Fri, 21 Feb 2020 10:23:46 +0100
Message-ID: <95ABE3EC-8398-4928-B42B-086DE58CD8A2@redhat.com>
In-Reply-To: <CAJ8uoz3cGwP4xsCxxv=pvqP3hJw9LBL1u=Jivba2xRBTs6vmgA@mail.gmail.com>
References: <CALDO+SZmCxtWCeqh93HO6vm1KHh_UGxMby+td2ba_o66ZT+MVQ@mail.gmail.com>
 <28C7C59E-0ED6-4331-8547-952419F20D1F@redhat.com>
 <CAJ8uoz3t6mKVr+aHx_WDkPg66_wTSsMNySzWny9JhCR1VG7mBA@mail.gmail.com>
 <FA00F7E2-E4E2-413B-9CC0-93AB2BA861A2@redhat.com>
 <CAJ8uoz3cGwP4xsCxxv=pvqP3hJw9LBL1u=Jivba2xRBTs6vmgA@mail.gmail.com>
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: quoted-printable
To: Magnus Karlsson <magnus.karlsson@gmail.com>
Cc: William Tu <u9012063@gmail.com>, Xdp <xdp-newbies@vger.kernel.org>, "Karlsson, Magnus" <magnus.karlsson@intel.com>, =?utf-8?b?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>



On 21 Feb 2020, at 9:46, Magnus Karlsson wrote:

> On Fri, Feb 21, 2020 at 9:40 AM Eelco Chaudron <echaudro@redhat.com>=20
> wrote:
>>
>>
>>
>> On 21 Feb 2020, at 9:33, Magnus Karlsson wrote:
>>
>>> On Fri, Feb 21, 2020 at 9:30 AM Eelco Chaudron <echaudro@redhat.com>
>>> wrote:
>>>>
>>>>
>>>>
>>>> On 20 Feb 2020, at 23:49, William Tu wrote:
>>>>
>>>>> Hi,
>>>>>
>>>>> I'm trying to save some CPU cycles when there is no packet=20
>>>>> arrives.
>>>>> I enable the poll syscall option of xdpsock, by doing
>>>>>
>>>>> $ ./xdpsock -r -p -S -i ens16
>>>>>  sock0@ens160:0 rxdrop xdp-skb poll()
>>>>>                 pps         pkts        1.00
>>>>> rx              0           0
>>>>> tx              0           0
>>>>>
>>>>> Since there is no packet coming, I though by calling poll()
>>>>> system call, the xdpsock process will be blocked and CPU=20
>>>>> utilization
>>>>> should be way under 100%. However, I'm still seeing 100%
>>>>> CPU utilization. Am I understanding this correctly?
>>>>
>>>> Hi William, I can remember I saw this in the past two with this=20
>>>> code.
>>>> It
>>>> had something to do with the way xdpsock waits for the buffers to=20
>>>> be
>>>> free=E2=80=99 ed by the kernel. What I can remember it had something t=
o=20
>>>> do
>>>> with the veth interfaces also.
>>>>
>>>> I do remember that I fixed it in the tutorial for AF_XDP:
>>>> https://github.com/xdp-project/xdp-tutorial/blob/master/advanced03-AF_=
XDP/af_xdp_user.c
>>>
>>> Eelco,
>>>
>>> Do you remember exactly what you had to fix in the xdpsock sample?
>>> Your tutorial is quite a rewrite so it is hard for me to tell=20
>>> exactly
>>> which of all the changes that fix this problem. The reason I ask is
>>> that it would be nice to fix this in the sample too.
>>>
>>> Thanks: Magnus
>>
>>  From an earlier email conversation we had this is where it looped in=20
>> my
>> case:
>
> Thanks Eelco. Yes, the xdpsock sample is too simplistic in this case.
> I will put this on my backlog to fix so that we do not have this
> problem in the future. I might take some inspiration from your code
> :-). Hope you do not mind.

Its GPL so take whatever you need ;)
