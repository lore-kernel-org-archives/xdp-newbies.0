Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:20188 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727909AbfHNQRj (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 14 Aug 2019 12:17:39 -0400
From: Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH bpf-next 1/3] libbpf: add asm/unistd.h to xsk to get
 __NR_mmap2
Date: Wed, 14 Aug 2019 16:17:09 +0000
Message-ID: <8e8db765-cb2d-ca59-6712-5dd51ca83baf@fb.com>
References: <20190813102318.5521-1-ivan.khoronzhuk@linaro.org>
 <20190813102318.5521-2-ivan.khoronzhuk@linaro.org>
 <CAEf4BzZ2y_DmTXkVqFh6Hdcquo6UvntvCygw5h5WwrWYXRRg_g@mail.gmail.com>
 <20190814092403.GA4142@khorivan> <20190814115659.GC4142@khorivan>
 <CAJ+HfNiqu7WEoBFnfK3znU4tVyAmpPVabTjTSKH1ZVo2W1rrXg@mail.gmail.com>
In-Reply-To: <CAJ+HfNiqu7WEoBFnfK3znU4tVyAmpPVabTjTSKH1ZVo2W1rrXg@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <272FBCED56A08A4998F027F0A8B683B2@namprd15.prod.outlook.com>
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>, Andrii Nakryiko <andrii.nakryiko@gmail.com>, Magnus Karlsson <magnus.karlsson@intel.com>, =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>, "David S. Miller" <davem@davemloft.net>, Jesper Dangaard Brouer <hawk@kernel.org>, john fastabend <john.fastabend@gmail.com>, Jakub Kicinski <jakub.kicinski@netronome.com>, Daniel Borkmann <daniel@iogearbox.net>, Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, Xdp <xdp-newbies@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>



On 8/14/19 6:32 AM, Björn Töpel wrote:
> On Wed, 14 Aug 2019 at 13:57, Ivan Khoronzhuk
> <ivan.khoronzhuk@linaro.org> wrote:
>>
>> On Wed, Aug 14, 2019 at 12:24:05PM +0300, Ivan Khoronzhuk wrote:
>>> On Tue, Aug 13, 2019 at 04:38:13PM -0700, Andrii Nakryiko wrote:
>>>
>>> Hi, Andrii
>>>
>>>> On Tue, Aug 13, 2019 at 3:24 AM Ivan Khoronzhuk
>>>> <ivan.khoronzhuk@linaro.org> wrote:
>>>>>
>>>>> That's needed to get __NR_mmap2 when mmap2 syscall is used.
>>>>>
>>>>> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
>>>>> ---
>>>>> tools/lib/bpf/xsk.c | 1 +
>>>>> 1 file changed, 1 insertion(+)
>>>>>
>>>>> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
>>>>> index 5007b5d4fd2c..f2fc40f9804c 100644
>>>>> --- a/tools/lib/bpf/xsk.c
>>>>> +++ b/tools/lib/bpf/xsk.c
>>>>> @@ -12,6 +12,7 @@
>>>>> #include <stdlib.h>
>>>>> #include <string.h>
>>>>> #include <unistd.h>
>>>>> +#include <asm/unistd.h>
>>>>
>>>> asm/unistd.h is not present in Github libbpf projection. Is there any
>>>
>>> Look on includes from
>>> tools/lib/bpf/libpf.c
>>> tools/lib/bpf/bpf.c
>>>
>>> That's how it's done... Copping headers to arch/arm will not
>>> solve this, it includes both of them anyway, and anyway it needs
>>> asm/unistd.h inclusion here, only because xsk.c needs __NR_*
>>>
>>>
>>
>> There is one more radical solution for this I can send, but I'm not sure how it
>> can impact on other syscals/arches...
>>
>> Looks like:
>>
>>
>> diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
>> index 9312066a1ae3..8b2f8ff7ce44 100644
>> --- a/tools/lib/bpf/Makefile
>> +++ b/tools/lib/bpf/Makefile
>> @@ -113,6 +113,7 @@ override CFLAGS += -Werror -Wall
>>   override CFLAGS += -fPIC
>>   override CFLAGS += $(INCLUDES)
>>   override CFLAGS += -fvisibility=hidden
>> +override CFLAGS += -D_FILE_OFFSET_BITS=64
>>
> 
> Hmm, isn't this glibc-ism? Does is it work for, say, musl or bionic?
> 
> If this is portable, and works on 32-, and 64-bit archs, I'm happy
> with the patch. :-)

Second here. Looks defining -D_FILE_OFFSET_BITS=64 is a well known
fix for 32bit system to deal with files > 2GB.
I remembered I used it in distant past. The below link
also explains the case.
https://digital-domain.net/largefiles.html

Testing on musl is necessary as Arnaldo's perf test suite
indeed tested it. Probably bionic too, not really familiar with that.

> 
> 
> Björn
> 
>>   ifeq ($(VERBOSE),1)
>>     Q =
>> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
>> index f2fc40f9804c..ff2d03b8380d 100644
>> --- a/tools/lib/bpf/xsk.c
>> +++ b/tools/lib/bpf/xsk.c
>> @@ -75,23 +75,6 @@ struct xsk_nl_info {
>>          int fd;
>>   };
>>
>> -/* For 32-bit systems, we need to use mmap2 as the offsets are 64-bit.
>> - * Unfortunately, it is not part of glibc.
>> - */
>> -static inline void *xsk_mmap(void *addr, size_t length, int prot, int flags,
>> -                            int fd, __u64 offset)
>> -{
>> -#ifdef __NR_mmap2
>> -       unsigned int page_shift = __builtin_ffs(getpagesize()) - 1;
>> -       long ret = syscall(__NR_mmap2, addr, length, prot, flags, fd,
>> -                          (off_t)(offset >> page_shift));
>> -
>> -       return (void *)ret;
>> -#else
>> -       return mmap(addr, length, prot, flags, fd, offset);
>> -#endif
>> -}
>> -
>>   int xsk_umem__fd(const struct xsk_umem *umem)
>>   {
>>          return umem ? umem->fd : -EINVAL;
>> @@ -211,10 +194,9 @@ int xsk_umem__create(struct xsk_umem **umem_ptr, void *umem_area, __u64 size,
>>                  goto out_socket;
>>          }
>>
>> -       map = xsk_mmap(NULL, off.fr.desc +
>> -                      umem->config.fill_size * sizeof(__u64),
>> -                      PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE,
>> -                      umem->fd, XDP_UMEM_PGOFF_FILL_RING);
>> +       map = mmap(NULL, off.fr.desc + umem->config.fill_size * sizeof(__u64),
>> +                  PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE, umem->fd,
>> +                  XDP_UMEM_PGOFF_FILL_RING);
>>          if (map == MAP_FAILED) {
>>                  err = -errno;
>>                  goto out_socket;
>> @@ -228,10 +210,9 @@ int xsk_umem__create(struct xsk_umem **umem_ptr, void *umem_area, __u64 size,
>>          fill->ring = map + off.fr.desc;
>>          fill->cached_cons = umem->config.fill_size;
>>
>> -       map = xsk_mmap(NULL,
>> -                      off.cr.desc + umem->config.comp_size * sizeof(__u64),
>> -                      PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE,
>> -                      umem->fd, XDP_UMEM_PGOFF_COMPLETION_RING);
>> +       map = mmap(NULL, off.cr.desc + umem->config.comp_size * sizeof(__u64),
>> +                  PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE, umem->fd,
>> +                  XDP_UMEM_PGOFF_COMPLETION_RING);
>>          if (map == MAP_FAILED) {
>>                  err = -errno;
>>                  goto out_mmap;
>> @@ -552,11 +533,10 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
>>          }
>>
>>          if (rx) {
>> -               rx_map = xsk_mmap(NULL, off.rx.desc +
>> -                                 xsk->config.rx_size * sizeof(struct xdp_desc),
>> -                                 PROT_READ | PROT_WRITE,
>> -                                 MAP_SHARED | MAP_POPULATE,
>> -                                 xsk->fd, XDP_PGOFF_RX_RING);
>> +               rx_map = mmap(NULL, off.rx.desc +
>> +                             xsk->config.rx_size * sizeof(struct xdp_desc),
>> +                             PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE,
>> +                             xsk->fd, XDP_PGOFF_RX_RING);
>>                  if (rx_map == MAP_FAILED) {
>>                          err = -errno;
>>                          goto out_socket;
>> @@ -571,11 +551,10 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
>>          xsk->rx = rx;
>>
>>          if (tx) {
>> -               tx_map = xsk_mmap(NULL, off.tx.desc +
>> -                                 xsk->config.tx_size * sizeof(struct xdp_desc),
>> -                                 PROT_READ | PROT_WRITE,
>> -                                 MAP_SHARED | MAP_POPULATE,
>> -                                 xsk->fd, XDP_PGOFF_TX_RING);
>> +               tx_map = mmap(NULL, off.tx.desc +
>> +                             xsk->config.tx_size * sizeof(struct xdp_desc),
>> +                             PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE,
>> +                             xsk->fd, XDP_PGOFF_TX_RING);
>>                  if (tx_map == MAP_FAILED) {
>>                          err = -errno;
>>                          goto out_mmap_rx;
>>
>>
>> If maintainers are ready to accept this I can send.
>> What do you say?
>>
>> --
>> Regards,
>> Ivan Khoronzhuk
