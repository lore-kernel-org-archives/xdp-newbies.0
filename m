Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pg0-f50.google.com ([74.125.83.50]:36341 "EHLO
        mail-pg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751911AbdGAUIw (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Sat, 1 Jul 2017 16:08:52 -0400
Received: by mail-pg0-f50.google.com with SMTP id u62so77896870pgb.3
        for <xdp-newbies@vger.kernel.org>; Sat, 01 Jul 2017 13:08:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAH3MdRV8aH-p1C01UGaCupgyWgpY7U6rZfwC+u8-WZdfsS=M_w@mail.gmail.com>
References: <CAM7NYThuodV+4DE9XUh_xVNyoAWRvqsY9E-gnFhqZ6qUQMLRow@mail.gmail.com>
 <CAH3MdRVnOO9gcjzC3+KpNCePox+xdOaG1tNpX_zdrDLG0jtRwg@mail.gmail.com>
 <CAM7NYTj3EQPAG49+mvAEn9ffnwJRGvbnnAvcmRWsk5KXS=KUew@mail.gmail.com> <CAH3MdRV8aH-p1C01UGaCupgyWgpY7U6rZfwC+u8-WZdfsS=M_w@mail.gmail.com>
From: "MD I. Islam" <tamim@csebuet.org>
Date: Sat, 1 Jul 2017 16:08:30 -0400
Message-ID: <CAM7NYTj2fOXxW+YLtCsQtae7zLvc4x7krQbq1iHxLk2VTEskcw@mail.gmail.com>
Subject: Re: bpf_trace_printk isn't working
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Y Song <ys114321@gmail.com>, Brenden Blanco <bblanco@gmail.com>
Cc: xdp-newbies@vger.kernel.org

Thank you Song and Brenden! Apparently I do need to check the
data_end. Is there a reason why it was silently ignoring the
print_trace? I also got following warning;

clang  -nostdinc -isystem /usr/lib/gcc/x86_64-linux-gnu/5/include
-I./arch/x86/include -I./arch/x86/include/generated/uapi
-I./arch/x86/include/generated  -I./include -I./arch/x86/include/uapi
-I./include/uapi -I./include/generated/uapi -include
./include/linux/kconfig.h  \
-D__KERNEL__ -D__ASM_SYSREG_H -Wno-unused-value -Wno-pointer-sign \
-Wno-compare-distinct-pointer-types \
-Wno-gnu-variable-sized-type-not-at-end \
-Wno-address-of-packed-member -Wno-tautological-compare \
-O2 -emit-llvm -c samples/bpf/parse_simple.c -o -| llc -march=bpf
-filetype=obj -o samples/bpf/parse_simple.o
warning: unknown warning option '-Wno-address-of-packed-member'
      [-Wunknown-warning-option]

Does it have anything to do with the problem?

Many thanks
Tamim

On Sat, Jul 1, 2017 at 12:26 AM, Y Song <ys114321@gmail.com> wrote:
> I created a test case on fc25 (kernel 4.8.6) like below and it works
> fine for me.
>
>     unsigned char *data = (unsigned char *)(long)skb->data;
>     unsigned char *data_end = (unsigned char *)(long)skb->data_end;
>     if (data + 2 > data_end)
>       return 0;
>     char fmt[] = "%u\n";
>     bpf_trace_printk_(fmt, sizeof(fmt), *data);
>
>
>
> On Fri, Jun 30, 2017 at 2:25 PM, MD I. Islam <tamim@csebuet.org> wrote:
>> I tried to cast it into int *. In that case, it should print the
>> integer. But I get the same problem.
>>
>> On Fri, Jun 30, 2017 at 5:16 PM, Y Song <ys114321@gmail.com> wrote:
>>> Maybe *data is not a printable character?
>>>
>>> On Fri, Jun 30, 2017 at 12:54 PM, MD I. Islam <tamim@csebuet.org> wrote:
>>>> Hi
>>>>
>>>> I have following code attached to an interface:
>>>>
>>>> SEC("simple")
>>>> int handle_ingress(struct __sk_buff *skb)
>>>> {
>>>>         unsigned char *data = (unsigned char *)(long)skb->data;
>>>>         char fmt[] = "%u\n";
>>>>         bpf_trace_printk(fmt, sizeof(fmt), *data);
>>>>         return 0;
>>>> }
>>>>
>>>> When packets pass through the interface, it does not print anything at
>>>> /sys/kernel/debug/tracing/trace_pipe. However if I do
>>>> bpf_trace_printk(fmt, sizeof(fmt), data), it prints the pointer. Could
>>>> you please advise what is wrong here?
>>>>
>>>> Many thanks
>>>> Tamim
