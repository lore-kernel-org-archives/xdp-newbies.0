Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pg0-f47.google.com ([74.125.83.47]:33115 "EHLO
        mail-pg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752613AbdF3TzJ (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 30 Jun 2017 15:55:09 -0400
Received: by mail-pg0-f47.google.com with SMTP id f127so68169639pgc.0
        for <xdp-newbies@vger.kernel.org>; Fri, 30 Jun 2017 12:55:09 -0700 (PDT)
MIME-Version: 1.0
From: "MD I. Islam" <tamim@csebuet.org>
Date: Fri, 30 Jun 2017 15:54:48 -0400
Message-ID: <CAM7NYThuodV+4DE9XUh_xVNyoAWRvqsY9E-gnFhqZ6qUQMLRow@mail.gmail.com>
Subject: bpf_trace_printk isn't working
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org

Hi

I have following code attached to an interface:

SEC("simple")
int handle_ingress(struct __sk_buff *skb)
{
        unsigned char *data = (unsigned char *)(long)skb->data;
        char fmt[] = "%u\n";
        bpf_trace_printk(fmt, sizeof(fmt), *data);
        return 0;
}

When packets pass through the interface, it does not print anything at
/sys/kernel/debug/tracing/trace_pipe. However if I do
bpf_trace_printk(fmt, sizeof(fmt), data), it prints the pointer. Could
you please advise what is wrong here?

Many thanks
Tamim
