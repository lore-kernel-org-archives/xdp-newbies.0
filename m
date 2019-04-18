Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-lj1-f193.google.com ([209.85.208.193]:34114 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387519AbfDRJr0 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 18 Apr 2019 05:47:26 -0400
Received: by mail-lj1-f193.google.com with SMTP id j89so1389416ljb.1
        for <xdp-newbies@vger.kernel.org>; Thu, 18 Apr 2019 02:47:24 -0700 (PDT)
Date: Thu, 18 Apr 2019 12:47:21 +0300
From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: Re: [RFC PATCH 0/3] net: ethernet: ti: cpsw: Add XDP support
Message-ID: <20190418094719.GC27879@khorivan>
References: <20190417174942.11811-1-ivan.khoronzhuk@linaro.org>
 <CAJ+HfNhzBMgQwan-x1KV48V_z0jVQgWnAD+HDxvYLyCmTxAJbw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJ+HfNhzBMgQwan-x1KV48V_z0jVQgWnAD+HDxvYLyCmTxAJbw@mail.gmail.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>
Cc: grygorii.strashko@ti.com, linux-omap@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, hawk@kernel.org, Xdp <xdp-newbies@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, aniel@iogearbox.net, Jakub Kicinski <jakub.kicinski@netronome.com>, John Fastabend <john.fastabend@gmail.com>, "Karlsson, Magnus" <magnus.karlsson@intel.com>

On Thu, Apr 18, 2019 at 08:12:06AM +0200, Björn Töpel wrote:
>On Wed, 17 Apr 2019 at 19:51, Ivan Khoronzhuk
><ivan.khoronzhuk@linaro.org> wrote:
>>
>> This patchset is RFC adding XDP support for TI cpsw driver that is
>> based on page_pool allocator. It was verified with af_xdp sockets
>> and on xdp drop. For XDP redirect to another interface it's under
>> verification, still not sure about all cases that should be verified.
>> Also regular tests with iperf2 were done in order to verify impact on
>> regular netstack performance, compared with base commit from
>> net-next/master: 432bc230700f86801cffa5e159e05dea6229f722
>>
>> It was verified with following configs enabled:
>> CONFIG_JIT=y
>> CONFIG_BPFILTER=y
>> CONFIG_BPF_SYSCALL=y
>> CONFIG_XDP_SOCKETS=y
>> CONFIG_BPF_EVENTS=y
>> CONFIG_HAVE_EBPF_JIT=y
>> CONFIG_BPF_JIT=y
>> CONFIG_CGROUP_BPF=y
>>
>> iperf2 UDP RX summary (packet size / Mbps):
>> +--------------------------------------------------------------+
>> | pkt_size/rate | 1024 | 1500 | 1470 |  64  | 128  | 512 | 256 |
>> |---------------+------+------+------+------+------+-----+-----|
>> | base commit   | 561  | 470  | 796  |  35  | 70.1 | 281 | 140 |
>> |---------------+------+------+------+------+------+-----+-----|
>> | XDP patched   | 563  | 455  | 808  |  35  | 70.2 | 282 | 141 |
>> +--------------------------------------------------------------+
>>
>> iperf2 UDP TX summary (packet size / Mbps):
>> +--------------------------------------------------------------+
>> | pkt_size/rate | 1024 | 1500 | 1470 |  64  | 128  | 512 | 256 |
>> |---------------+------+------+------+------+------+-----+-----|
>> | base commit   | 555  | 666  | 736  | 34.5 | 70.3 | 281 | 140 |
>> |---------------+------+------+------+------+------+-----+-----|
>> | XDP patched   | 558  | 696  | 759  | 35.2 | 69.2 | 279 | 140 |
>> +--------------------------------------------------------------+
>>
>> iperf2 TCP summary (window size / Mbps):
>> +------------------------------------------------------------+
>> | window size/rate |  16  |  32  |  64  |  128 |  8   | 256  |
>> |------------------+------+------+------+------+------+------|
>> | base commit      | 753  | 887  | 931  | 932  | 676  | 932  |
>> |------------------+------+------+------+------+------+------|
>> | XDP patched      | 823  | 888  | 932  | 933  | 669  | 933  |
>> +------------------------------------------------------------+
>>
>> For af_xdp socket type verification several generic changes should be added
>> that can be seen here (rough fixes, for samples related seems like last version
>> of samples is more integrated with libbpf api, so should be rebased,
>> witch I will send as RFC separately):
>> https://github.com/ikhorn/af_xdp_stuff/tree/af_xdp_armv7
>>
>
>More XDP support, yay!
>
>As for mmap/AF_XDP on 32-bit systems; Instead of hacking the if_xdp.h,
>mmap2 should be used. Have a look at the libbpf code here [1]
I more bothering about this fast fix (not investigated deep enough):
https://github.com/ikhorn/af_xdp_stuff/commit/f77cd4faf95ad744bbf37d0ba81d0ec79c1b0d29

That's about when page_address(umem->pgs[i]) returns nothing.

>
>
>Björn
>
>[1] https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/tree/tools/lib/bpf/xsk.c#n81
>
>
>> Ivan Khoronzhuk (3):
>>   net: ethernet: ti: davinci_cpdma: add dma mapped submit
>>   net: ethernet: ti: davinci_cpdma: return handler status
>>   net: ethernet: ti: cpsw: add XDP support
>>
>>  drivers/net/ethernet/ti/Kconfig         |   1 +
>>  drivers/net/ethernet/ti/cpsw.c          | 552 +++++++++++++++++++++---
>>  drivers/net/ethernet/ti/davinci_cpdma.c | 117 +++--
>>  drivers/net/ethernet/ti/davinci_cpdma.h |   6 +-
>>  drivers/net/ethernet/ti/davinci_emac.c  |  18 +-
>>  5 files changed, 591 insertions(+), 103 deletions(-)
>>
>> --
>> 2.17.1
>>

-- 
Regards,
Ivan Khoronzhuk
