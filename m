Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:6569 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932698AbdIYKDw (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 25 Sep 2017 06:03:52 -0400
Subject: Re: libbpf missing set_link_xdp_fd ?
References: <1506276431.21618.2.camel@regit.org>
 <20170925112502.1879734a@redhat.com>
From: "Wangnan (F)" <wangnan0@huawei.com>
Message-ID: <31e809a3-d49a-8f62-4ef3-a8cc0695cf18@huawei.com>
Date: Mon, 25 Sep 2017 18:03:06 +0800
MIME-Version: 1.0
In-Reply-To: <20170925112502.1879734a@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jesper Dangaard Brouer <brouer@redhat.com>, Eric Leblond <eric@regit.org>
Cc: xdp-newbies@vger.kernel.org, Daniel Borkmann <borkmann@iogearbox.net>, Alexei Starovoitov <alexei.starovoitov@gmail.com>



On 2017/9/25 17:25, Jesper Dangaard Brouer wrote:
> On Sun, 24 Sep 2017 20:07:11 +0200
> Eric Leblond <eric@regit.org> wrote:
>
>> Hello,
>>
>> bpf_load is implementing the set_link_xdp_fd() function and it seems
>> this function is not available in libbpf.
> I also ran into this problem, when I wanted to switch my XDP programs
> into using tools/lib/bpf/.
>
> E.g.: https://github.com/netoptimizer/prototype-kernel/commit/5397e596c30416763
>
>> Should it be the case or should it be part of another library ?
> I'm not sure... maybe Alexei, Daniel or Wang have an opinion?
>

tools/lib/bpf is aiming at provide a better way to parse bpf object file,
load bpf program and maps. It doesn't operate link layer. set_link_xdp_fd()
and other socket and link related functions are better to be implement
separately. Two choices: 1. Move them into a library in samples/bpf.
2. make libbpf support XDP. The second choice looks good, but I'm
not familiar with XDP API and don't know how to give a good abstraction.

In my opinion it should be part of another library.

Thank you.
