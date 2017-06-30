Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:35038 "EHLO
        mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753051AbdF3V20 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 30 Jun 2017 17:28:26 -0400
Received: by mail-pf0-f174.google.com with SMTP id c73so72800133pfk.2
        for <xdp-newbies@vger.kernel.org>; Fri, 30 Jun 2017 14:28:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAH9hs-JBuZszp80eayjYx+faYM0z3XpYNw_Ox7oFFxgNOES_wA@mail.gmail.com>
References: <CAM7NYThuodV+4DE9XUh_xVNyoAWRvqsY9E-gnFhqZ6qUQMLRow@mail.gmail.com>
 <CAH3MdRVnOO9gcjzC3+KpNCePox+xdOaG1tNpX_zdrDLG0jtRwg@mail.gmail.com> <CAH9hs-JBuZszp80eayjYx+faYM0z3XpYNw_Ox7oFFxgNOES_wA@mail.gmail.com>
From: "MD I. Islam" <tamim@csebuet.org>
Date: Fri, 30 Jun 2017 17:28:05 -0400
Message-ID: <CAM7NYTgxyYPZ8NXZ0vj9FZORNvQ9F+uvSkgzsmLpFUPu98zdQw@mail.gmail.com>
Subject: Re: bpf_trace_printk isn't working
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Brenden Blanco <bblanco@gmail.com>
Cc: Y Song <ys114321@gmail.com>, xdp-newbies@vger.kernel.org

On Fri, Jun 30, 2017 at 5:18 PM, Brenden Blanco <bblanco@gmail.com> wrote:
> On Fri, Jun 30, 2017 at 2:16 PM, Y Song <ys114321@gmail.com> wrote:
>> Maybe *data is not a printable character?
>>
>> On Fri, Jun 30, 2017 at 12:54 PM, MD I. Islam <tamim@csebuet.org> wrote:
>>> Hi
>>>
>>> I have following code attached to an interface:
>>>
>>> SEC("simple")
>>> int handle_ingress(struct __sk_buff *skb)
>>> {
>>>         unsigned char *data = (unsigned char *)(long)skb->data;
>
> Don't you need a data_end check first?

Yes, I will need those sanity check. I just posted the code snippet
that is causing the problem.
>
>>>         char fmt[] = "%u\n";
>>>         bpf_trace_printk(fmt, sizeof(fmt), *data);
>>>         return 0;
>>> }
>>>
>>> When packets pass through the interface, it does not print anything at
>>> /sys/kernel/debug/tracing/trace_pipe. However if I do
>>> bpf_trace_printk(fmt, sizeof(fmt), data), it prints the pointer. Could
>>> you please advise what is wrong here?
>>>
>>> Many thanks
>>> Tamim
