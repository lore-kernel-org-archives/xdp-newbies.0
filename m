Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-lj1-f196.google.com ([209.85.208.196]:37500 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbfHMS7F (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 13 Aug 2019 14:59:05 -0400
Received: by mail-lj1-f196.google.com with SMTP id t14so279343lji.4
        for <xdp-newbies@vger.kernel.org>; Tue, 13 Aug 2019 11:59:04 -0700 (PDT)
Date: Tue, 13 Aug 2019 21:59:00 +0300
From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: Re: [PATCH bpf-next 3/3] samples: bpf: syscal_nrs: use mmap2 if
 defined
Message-ID: <20190813185859.GB2856@khorivan>
References: <20190813102318.5521-1-ivan.khoronzhuk@linaro.org>
 <20190813102318.5521-4-ivan.khoronzhuk@linaro.org>
 <036BCF4A-53D6-4000-BBDE-07C04B8B23FA@flugsvamp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <036BCF4A-53D6-4000-BBDE-07C04B8B23FA@flugsvamp.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jonathan Lemon <jlemon@flugsvamp.com>
Cc: magnus.karlsson@intel.com, bjorn.topel@intel.com, davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com, jakub.kicinski@netronome.com, daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org, xdp-newbies@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Aug 13, 2019 at 10:41:54AM -0700, Jonathan Lemon wrote:
>
>
>On 13 Aug 2019, at 3:23, Ivan Khoronzhuk wrote:
>
>> For arm32 xdp sockets mmap2 is preferred, so use it if it's defined.
>>
>> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
>
>Doesn't this change the application API?
>-- 
>Jonathan

From what I know there is no reason to use both, so if __NR_mmap2 is defined
but not __NR_mmap. Despite the fact that it can be defined internally, say
#define __NR_mmap (__NR_SYSCALL_BASE + 90)
and be used anyway, at least arm use 2 definition one is for old abi and one is
for new and names as their numbers are different:

#define __NR_mmap (__NR_SYSCALL_BASE + 90)
#define __NR_mmap2 (__NR_SYSCALL_BASE + 192)

, so they are not interchangeable and if eabi is used then only __NR_mmap2 is
defined if oeabi then __NR_mmap only... But mmap() use only one and can hide
this from user.

In this patch, seems like here is direct access, so I have no declaration for
__NR_mmap and it breaks build. So here several solutions, I can block __NR_mmap
at all or replace it on __NR_mmap2...or define it by hand (for what then?).
I decided to replace on real one.

>
>
>> ---
>>  samples/bpf/syscall_nrs.c  |  5 +++++
>>  samples/bpf/tracex5_kern.c | 11 +++++++++++
>>  2 files changed, 16 insertions(+)
>>
>> diff --git a/samples/bpf/syscall_nrs.c b/samples/bpf/syscall_nrs.c
>> index 516e255cbe8f..2dec94238350 100644
>> --- a/samples/bpf/syscall_nrs.c
>> +++ b/samples/bpf/syscall_nrs.c
>> @@ -9,5 +9,10 @@ void syscall_defines(void)
>>  	COMMENT("Linux system call numbers.");
>>  	SYSNR(__NR_write);
>>  	SYSNR(__NR_read);
>> +#ifdef __NR_mmap2
>> +	SYSNR(__NR_mmap2);
>> +#else
>>  	SYSNR(__NR_mmap);
>> +#endif
>> +
>>  }
>> diff --git a/samples/bpf/tracex5_kern.c b/samples/bpf/tracex5_kern.c
>> index f57f4e1ea1ec..300350ad299a 100644
>> --- a/samples/bpf/tracex5_kern.c
>> +++ b/samples/bpf/tracex5_kern.c
>> @@ -68,12 +68,23 @@ PROG(SYS__NR_read)(struct pt_regs *ctx)
>>  	return 0;
>>  }
>>
>> +#ifdef __NR_mmap2
>> +PROG(SYS__NR_mmap2)(struct pt_regs *ctx)
>> +{
>> +	char fmt[] = "mmap2\n";
>> +
>> +	bpf_trace_printk(fmt, sizeof(fmt));
>> +	return 0;
>> +}
>> +#else
>>  PROG(SYS__NR_mmap)(struct pt_regs *ctx)
>>  {
>>  	char fmt[] = "mmap\n";
>> +
>>  	bpf_trace_printk(fmt, sizeof(fmt));
>>  	return 0;
>>  }
>> +#endif
>>
>>  char _license[] SEC("license") = "GPL";
>>  u32 _version SEC("version") = LINUX_VERSION_CODE;
>> --
>> 2.17.1

-- 
Regards,
Ivan Khoronzhuk
