Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-vk0-f47.google.com ([209.85.213.47]:34817 "EHLO
        mail-vk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751233AbdGAFyB (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Sat, 1 Jul 2017 01:54:01 -0400
Received: by mail-vk0-f47.google.com with SMTP id 191so75584514vko.2
        for <xdp-newbies@vger.kernel.org>; Fri, 30 Jun 2017 22:54:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAH3MdRV8aH-p1C01UGaCupgyWgpY7U6rZfwC+u8-WZdfsS=M_w@mail.gmail.com>
References: <CAM7NYThuodV+4DE9XUh_xVNyoAWRvqsY9E-gnFhqZ6qUQMLRow@mail.gmail.com>
 <CAH3MdRVnOO9gcjzC3+KpNCePox+xdOaG1tNpX_zdrDLG0jtRwg@mail.gmail.com>
 <CAM7NYTj3EQPAG49+mvAEn9ffnwJRGvbnnAvcmRWsk5KXS=KUew@mail.gmail.com> <CAH3MdRV8aH-p1C01UGaCupgyWgpY7U6rZfwC+u8-WZdfsS=M_w@mail.gmail.com>
From: Y Song <ys114321@gmail.com>
Date: Fri, 30 Jun 2017 22:53:20 -0700
Message-ID: <CAH3MdRWg=1zd_AyixM7Cde9e=giG0BrXO1xzVkxeOPutgV421w@mail.gmail.com>
Subject: Re: bpf_trace_printk isn't working
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: "MD I. Islam" <tamim@csebuet.org>
Cc: xdp-newbies@vger.kernel.org

I tested on latest net-next 4.12.0-rc6+ which is also fine.

On Fri, Jun 30, 2017 at 9:26 PM, Y Song <ys114321@gmail.com> wrote:
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
