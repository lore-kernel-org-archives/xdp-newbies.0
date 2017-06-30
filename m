Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-it0-f52.google.com ([209.85.214.52]:37988 "EHLO
        mail-it0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752946AbdF3VSl (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 30 Jun 2017 17:18:41 -0400
Received: by mail-it0-f52.google.com with SMTP id k192so31208299ith.1
        for <xdp-newbies@vger.kernel.org>; Fri, 30 Jun 2017 14:18:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAH3MdRVnOO9gcjzC3+KpNCePox+xdOaG1tNpX_zdrDLG0jtRwg@mail.gmail.com>
References: <CAM7NYThuodV+4DE9XUh_xVNyoAWRvqsY9E-gnFhqZ6qUQMLRow@mail.gmail.com>
 <CAH3MdRVnOO9gcjzC3+KpNCePox+xdOaG1tNpX_zdrDLG0jtRwg@mail.gmail.com>
From: Brenden Blanco <bblanco@gmail.com>
Date: Fri, 30 Jun 2017 14:18:20 -0700
Message-ID: <CAH9hs-JBuZszp80eayjYx+faYM0z3XpYNw_Ox7oFFxgNOES_wA@mail.gmail.com>
Subject: Re: bpf_trace_printk isn't working
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Y Song <ys114321@gmail.com>
Cc: "MD I. Islam" <tamim@csebuet.org>, xdp-newbies@vger.kernel.org

On Fri, Jun 30, 2017 at 2:16 PM, Y Song <ys114321@gmail.com> wrote:
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

Don't you need a data_end check first?

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
