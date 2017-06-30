Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:33570 "EHLO
        mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753009AbdF3V0K (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 30 Jun 2017 17:26:10 -0400
Received: by mail-pf0-f177.google.com with SMTP id e7so72788677pfk.0
        for <xdp-newbies@vger.kernel.org>; Fri, 30 Jun 2017 14:26:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAH3MdRVnOO9gcjzC3+KpNCePox+xdOaG1tNpX_zdrDLG0jtRwg@mail.gmail.com>
References: <CAM7NYThuodV+4DE9XUh_xVNyoAWRvqsY9E-gnFhqZ6qUQMLRow@mail.gmail.com>
 <CAH3MdRVnOO9gcjzC3+KpNCePox+xdOaG1tNpX_zdrDLG0jtRwg@mail.gmail.com>
From: "MD I. Islam" <tamim@csebuet.org>
Date: Fri, 30 Jun 2017 17:25:49 -0400
Message-ID: <CAM7NYTj3EQPAG49+mvAEn9ffnwJRGvbnnAvcmRWsk5KXS=KUew@mail.gmail.com>
Subject: Re: bpf_trace_printk isn't working
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Y Song <ys114321@gmail.com>
Cc: xdp-newbies@vger.kernel.org

I tried to cast it into int *. In that case, it should print the
integer. But I get the same problem.

On Fri, Jun 30, 2017 at 5:16 PM, Y Song <ys114321@gmail.com> wrote:
> Maybe *data is not a printable character?
>
> On Fri, Jun 30, 2017 at 12:54 PM, MD I. Islam <tamim@csebuet.org> wrote:
>> Hi
>>
>> I have following code attached to an interface:
>>
>> SEC("simple")
>> int handle_ingress(struct __sk_buff *skb)
>> {
>>         unsigned char *data = (unsigned char *)(long)skb->data;
>>         char fmt[] = "%u\n";
>>         bpf_trace_printk(fmt, sizeof(fmt), *data);
>>         return 0;
>> }
>>
>> When packets pass through the interface, it does not print anything at
>> /sys/kernel/debug/tracing/trace_pipe. However if I do
>> bpf_trace_printk(fmt, sizeof(fmt), data), it prints the pointer. Could
>> you please advise what is wrong here?
>>
>> Many thanks
>> Tamim
