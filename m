Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-vk0-f43.google.com ([209.85.213.43]:36298 "EHLO
        mail-vk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752786AbdF3VRH (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 30 Jun 2017 17:17:07 -0400
Received: by mail-vk0-f43.google.com with SMTP id y70so72477542vky.3
        for <xdp-newbies@vger.kernel.org>; Fri, 30 Jun 2017 14:17:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAM7NYThuodV+4DE9XUh_xVNyoAWRvqsY9E-gnFhqZ6qUQMLRow@mail.gmail.com>
References: <CAM7NYThuodV+4DE9XUh_xVNyoAWRvqsY9E-gnFhqZ6qUQMLRow@mail.gmail.com>
From: Y Song <ys114321@gmail.com>
Date: Fri, 30 Jun 2017 14:16:26 -0700
Message-ID: <CAH3MdRVnOO9gcjzC3+KpNCePox+xdOaG1tNpX_zdrDLG0jtRwg@mail.gmail.com>
Subject: Re: bpf_trace_printk isn't working
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: "MD I. Islam" <tamim@csebuet.org>
Cc: xdp-newbies@vger.kernel.org

Maybe *data is not a printable character?

On Fri, Jun 30, 2017 at 12:54 PM, MD I. Islam <tamim@csebuet.org> wrote:
> Hi
>
> I have following code attached to an interface:
>
> SEC("simple")
> int handle_ingress(struct __sk_buff *skb)
> {
>         unsigned char *data = (unsigned char *)(long)skb->data;
>         char fmt[] = "%u\n";
>         bpf_trace_printk(fmt, sizeof(fmt), *data);
>         return 0;
> }
>
> When packets pass through the interface, it does not print anything at
> /sys/kernel/debug/tracing/trace_pipe. However if I do
> bpf_trace_printk(fmt, sizeof(fmt), data), it prints the pointer. Could
> you please advise what is wrong here?
>
> Many thanks
> Tamim
