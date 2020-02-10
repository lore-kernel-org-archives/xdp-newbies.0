Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-am6eur05on2061.outbound.protection.outlook.com ([40.107.22.61]:7258
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727369AbgBJNn3 (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 10 Feb 2020 08:43:29 -0500
Subject: Re: [PATCH bpf] xsk: publish global consumer pointers when NAPI is
 finsihed
References: <1581068272-4615-1-git-send-email-magnus.karlsson@intel.com>
 <c5d6fd11-8696-e898-6f05-5fcc087c0065@mellanox.com>
 <95de5e86-8930-5655-62b9-ec60b9952440@iogearbox.net>
 <CAJ8uoz2Qn496NX2Q49_Ct_r4b_NjouqhM8iz+c2yp8y9=e4wSg@mail.gmail.com>
From: Maxim Mikityanskiy <maximmi@mellanox.com>
Message-ID: <ad324d2e-c9ab-f2fa-c11a-d26bc8d21284@mellanox.com>
Date: Mon, 10 Feb 2020 15:43:15 +0200
In-Reply-To: <CAJ8uoz2Qn496NX2Q49_Ct_r4b_NjouqhM8iz+c2yp8y9=e4wSg@mail.gmail.com>
Content-Language: en-US
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Magnus Karlsson <magnus.karlsson@gmail.com>, Magnus Karlsson <magnus.karlsson@intel.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>, Xdp <xdp-newbies@vger.kernel.org>, Ryan Goodfellow <rgoodfel@isi.edu>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>, Tariq Toukan <tariqt@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, Moshe Shemesh <moshe@mellanox.com>

On 2020-02-09 11:58, Magnus Karlsson wrote:
> On Fri, Feb 7, 2020 at 10:41 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>>
>> On 2/7/20 1:34 PM, Maxim Mikityanskiy wrote:
>>> On 2020-02-07 11:37, Magnus Karlsson wrote:
>>>> The commit 4b638f13bab4 ("xsk: Eliminate the RX batch size")
>>>> introduced a much more lazy way of updating the global consumer
>>>> pointers from the kernel side, by only doing so when running out of
>>>> entries in the fill or Tx rings (the rings consumed by the
>>>> kernel). This can result in a deadlock with the user application if
>>>> the kernel requires more than one entry to proceed and the application
>>>> cannot put these entries in the fill ring because the kernel has not
>>>> updated the global consumer pointer since the ring is not empty.
>> [...]
>>>
>>> Acked-by: Maxim Mikityanskiy <maximmi@mellanox.com>
>>>
>>> Is it intentional that you didn't send it to bpf and netdev mailing lists?
>>
>> Yep, please resend with Maxim's ACK to bpf + netdev in Cc. Thanks!
> 
> It was intentional, but maybe confusing. In the mail just before this
> patch I suggested that this patch should be part of a patch set that
> we send to bpf and netdev. The purpose of sending it was for you Maxim
> to ok it, and you did with your ack :-). But I will repeat the other
> questions from that mail here.

OK, I see. Sorry, I didn't see the previous email (and still can't find 
it, BTW).

> Does the Mellanox driver set the need_wakeup flag on Rx when it needs
> more buffers in the fill ring to form its stride and the HW Rx ring is
> empty? If yes, great. If not, please submit a patch for this.

Yes, it does (regardless of emptiness of the HW RX ring). If 
xsk_umem_has_addrs_rq returns false, the driver sets the need_wakeup flag.

> I will produce a documentation patch that clarifies that when the
> need_wakeup flag is set for the fill ring, the user need to put more
> packets on the fill ring and wakeup the kernel. It is already
> mentioned in the documentation, but I will make it more explicit.
> 

Great, thanks!

There's still room for optimization here, though: how many is "more"? If 
the application puts them one by one and wakes up the driver every time, 
it's not very effective comparing to the case if it knew the exact 
amount of missing frames. On the other hand, normally the application 
would put enough frames in advance, and it shouldn't get to this point.
