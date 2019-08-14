Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-lf1-f66.google.com ([209.85.167.66]:45853 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbfHNJYK (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 14 Aug 2019 05:24:10 -0400
Received: by mail-lf1-f66.google.com with SMTP id a30so15765256lfk.12
        for <xdp-newbies@vger.kernel.org>; Wed, 14 Aug 2019 02:24:08 -0700 (PDT)
Date: Wed, 14 Aug 2019 12:24:05 +0300
From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: Re: [PATCH bpf-next 1/3] libbpf: add asm/unistd.h to xsk to get
 __NR_mmap2
Message-ID: <20190814092403.GA4142@khorivan>
References: <20190813102318.5521-1-ivan.khoronzhuk@linaro.org>
 <20190813102318.5521-2-ivan.khoronzhuk@linaro.org>
 <CAEf4BzZ2y_DmTXkVqFh6Hdcquo6UvntvCygw5h5WwrWYXRRg_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAEf4BzZ2y_DmTXkVqFh6Hdcquo6UvntvCygw5h5WwrWYXRRg_g@mail.gmail.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: Magnus Karlsson <magnus.karlsson@intel.com>, =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>, "David S. Miller" <davem@davemloft.net>, Jesper Dangaard Brouer <hawk@kernel.org>, john fastabend <john.fastabend@gmail.com>, Jakub Kicinski <jakub.kicinski@netronome.com>, Daniel Borkmann <daniel@iogearbox.net>, Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, xdp-newbies@vger.kernel.org, open list <linux-kernel@vger.kernel.org>

On Tue, Aug 13, 2019 at 04:38:13PM -0700, Andrii Nakryiko wrote:

Hi, Andrii

>On Tue, Aug 13, 2019 at 3:24 AM Ivan Khoronzhuk
><ivan.khoronzhuk@linaro.org> wrote:
>>
>> That's needed to get __NR_mmap2 when mmap2 syscall is used.
>>
>> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
>> ---
>>  tools/lib/bpf/xsk.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
>> index 5007b5d4fd2c..f2fc40f9804c 100644
>> --- a/tools/lib/bpf/xsk.c
>> +++ b/tools/lib/bpf/xsk.c
>> @@ -12,6 +12,7 @@
>>  #include <stdlib.h>
>>  #include <string.h>
>>  #include <unistd.h>
>> +#include <asm/unistd.h>
>
>asm/unistd.h is not present in Github libbpf projection. Is there any

Look on includes from
tools/lib/bpf/libpf.c
tools/lib/bpf/bpf.c

That's how it's done... Copping headers to arch/arm will not
solve this, it includes both of them anyway, and anyway it needs
asm/unistd.h inclusion here, only because xsk.c needs __NR_*


>way to avoid including this header? Generally, libbpf can't easily use
>all of kernel headers, we need to re-implemented all the extra used
>stuff for Github version of libbpf, so we try to minimize usage of new
>headers that are not just plain uapi headers from include/uapi.

Yes I know, it's far away from real number of changes needed.
I faced enough about this already and kernel headers, especially
for arm32 it's a bit decency problem. But this patch it's part of
normal one. I have couple issues despite this normally fixed mmap2
that is the same even if uapi includes are coppied to tools/arch/arm.

In continuation of kernel headers inclusion and arm build:

For instance, what about this rough "kernel headers" hack:
https://github.com/ikhorn/af_xdp_stuff/commit/aa645ccca4d844f404ec3c2b27402d4d7848d1b5

or this one related for arm32 only:
https://github.com/ikhorn/af_xdp_stuff/commit/2c6c6d538605aac39600dcb3c9b66de11c70b963

I have more...

>
>>  #include <arpa/inet.h>
>>  #include <asm/barrier.h>
>>  #include <linux/compiler.h>
>> --
>> 2.17.1
>>

-- 
Regards,
Ivan Khoronzhuk
