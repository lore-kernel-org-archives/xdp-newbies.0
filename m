Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from forward101p.mail.yandex.net ([77.88.28.101]:38417 "EHLO
        forward101p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389846AbfJQXBt (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 17 Oct 2019 19:01:49 -0400
Subject: Re: i40e: Kernel freezes with XDP_ZEROCOPY
References: <CAHApi-mbMMx5bhdyfoLuiw7V3qML3L8f+N-+ReQ9XmAKH_2q8A@mail.gmail.com>
 <CAHApi-mwp8ZjoC9MavMbzKSdEi9c2js-cD1+Qr8nzJF-P-Sz9g@mail.gmail.com>
From: Ilya Goslhtein <ilejn@yandex.ru>
Message-ID: <10b8a1a6-5b59-7226-df49-ec902d6c3261@yandex.ru>
Date: Fri, 18 Oct 2019 01:56:27 +0300
MIME-Version: 1.0
In-Reply-To: <CAHApi-mwp8ZjoC9MavMbzKSdEi9c2js-cD1+Qr8nzJF-P-Sz9g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Kal Cutter Conley <kal.conley@dectris.com>, xdp-newbies@vger.kernel.org

Hello Kal,

I've noticed that all created processes in your code snippet bound to 
the same queue without SHARED flag.

Is it supposed to work?

Thanks.

On 17.10.2019 11:53, Kal Cutter Conley wrote:
> Hello,
> I have managed to extract a reproducer that crashes the kernel. We
> observe the crash with all drivers that support XDP zerocopy (i40e,
> ixgbe, mlx5_core). The program source is attached (C++). Compile with
> a newer clang++ or g++ using flag -std=c++17. It must also be linked
> with libbpf. Use libbpf v0.0.5 and make sure to revert
> 5771dacd3dc2fdd041c51242819a9f212e04af55.
>
> The crash is a kernel NULL pointer dereference in xsk_umem_consume_tx.
>
> Hopefully this is useful,
> Kal
>
> On Wed, Aug 7, 2019 at 10:48 PM Kal Cutter Conley
> <kal.conley@dectris.com> wrote:
>> Hello,
>> I am trying to get AF_XDP working with the i40e driver (Ethernet
>> Controller X710 for 10GbE SFP+). After bind() with XDP_ZEROCOPY the
>> kernel (machine) freezes hard. I have reproduced this on varying
>> kernel versions between 5.1 and 5.3-rc3 with 5.3 kernels freezing
>> also, but at a later stage. I tried replacing my XDP program with a
>> trivial one that simply returns XDP_PASS but it didn't help. On the
>> same system, the xdpsock sample does appear to work with the -z flag,
>> however. Are there any current known issues that could be causing
>> this? I will try to extract a minimal example that exercises the
>> freeze.
>>
>> Thanks,
>> Kal

-- 
Best regards,
Ilya Golshtein
