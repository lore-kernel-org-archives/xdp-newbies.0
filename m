Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pf1-f173.google.com ([209.85.210.173]:39253 "EHLO
        mail-pf1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727677AbfJXUgD (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 24 Oct 2019 16:36:03 -0400
Received: by mail-pf1-f173.google.com with SMTP id v4so14117pff.6
        for <xdp-newbies@vger.kernel.org>; Thu, 24 Oct 2019 13:36:02 -0700 (PDT)
MIME-Version: 1.0
From: Farid Zakaria <farid.m.zakaria@gmail.com>
Date: Thu, 24 Oct 2019 13:35:50 -0700
Message-ID: <CACCo2jmAx7SGU_TNU8EhVCKumcb7gSiwF0wGYvbJ8Ld3Yqfdug@mail.gmail.com>
Subject: Useful request_id concept for bpf_debug_printk
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Xdp <xdp-newbies@vger.kernel.org>

I wanted to share an idiom we've used when first developing our ebpf filter:

When having first developed our ebpf filter we heavily leaned on
`bpf_trace_printk` and `/sys/kernel/debug/tracing/trace_pipe` for
debugging.

With any load on the filter however the messages become difficult to
parse as they are interleaved with other executions & the pid in the
message may be not enough to discern a single run of the filter.

I found the following macros useful:

#define REQUEST_ID() bpf_get_prandom_u32()
#define DEBUG(id, x, ...) bpf_debug_printk("[%u]" x, id, ##__VA_ARGS__)

unsigned long long request_id = REQUEST_ID();
DEBUG(request_id, "starting filter.\n");

After that you can easily pipe the output of trace_pipe through grep.

Cheers,
Farid Zakaria
