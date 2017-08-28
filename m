Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-ua0-f181.google.com ([209.85.217.181]:35268 "EHLO
        mail-ua0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751190AbdH1VRH (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 28 Aug 2017 17:17:07 -0400
Received: by mail-ua0-f181.google.com with SMTP id g11so5224075uah.2
        for <xdp-newbies@vger.kernel.org>; Mon, 28 Aug 2017 14:17:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAC1LvL0WgC0bqEuGHp+LepyajskFdAkPruKY-9F6rL=zf49RKw@mail.gmail.com>
References: <CAC1LvL0WgC0bqEuGHp+LepyajskFdAkPruKY-9F6rL=zf49RKw@mail.gmail.com>
From: Y Song <ys114321@gmail.com>
Date: Mon, 28 Aug 2017 14:16:25 -0700
Message-ID: <CAH3MdRWk5R1DtUcPBbpNSv3kB-jJjP6RFUccRvqFS_7SZLnwzA@mail.gmail.com>
Subject: Re: Issues with bpf_trace_printk
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Zvi Effron <zeffron@riotgames.com>
Cc: xdp-newbies@vger.kernel.org

bpf program itself is okay.
I replaced linux:samples/bpf/xdp1_kern.c with this program and the
bpf_trace_printk works fine.
It could be some setup issue. But in any case, data start and data end
are suspicious.
It would be good you list all steps which can reproduce the issue.

On Mon, Aug 28, 2017 at 10:20 AM, Zvi Effron <zeffron@riotgames.com> wrote:
> Hello,
>
> I'm having an issue where bpf_trace_printk seems to always print 0 for
> values. I'm running the following xdp program:
>
>
> #include <uapi/linux/bpf.h>
>
> static int (*bpf_trace_printk)(const char *fmt, int fmt_size, ...) =
> (void *) BPF_FUNC_trace_printk;
>
> int xdp(struct xdp_md *ctx) {
>     char format_string[] = "Data start: %x\tData end: %x\n";
>     bpf_trace_printk(format_string, sizeof(format_string), ctx->data,
> ctx->data_end);
>
>     {
>         char format_string[] = "Constant: %x\n";
>         bpf_trace_printk(format_string, sizeof(format_string), 1);
>     }
>
>     if (ctx->data == 0) {
>         char format_string[] = "Data starts at offset 0";
>         bpf_trace_printk(format_string, sizeof(format_string));
>     }
>     if (ctx->data_end == 0) {
>         char format_string[] = "Data ends at offset 0";
>         bpf_trace_printk(format_string, sizeof(format_string));
>     }
>     return XDP_PASS;
> }
>
> char __attribute__((section("license"), used)) license[] = "GPL";
>
>
> and I get the following output in /sys/kernel/debug/tracing/trace_pipe
>
>
>             sshd-4824  [000] ..s1 67372.673714: : Data start: 0 Data end: 0
>             sshd-4824  [000] ..s1 67372.673720: : Constant: 0
>           <idle>-0     [000] ..s. 67372.675062: : Data start: 0 Data end: 0
>           <idle>-0     [000] .Ns. 67372.675090: : Constant: 0
>           <idle>-0     [000] .Ns. 67372.675116: : Data start: 0 Data end: 0
>           <idle>-0     [000] .Ns. 67372.675117: : Constant: 0
>           <idle>-0     [000] .Ns. 67372.675129: : Data start: 0 Data end: 0
>           <idle>-0     [000] .Ns. 67372.675130: : Constant: 0
>           <idle>-0     [000] .Ns. 67372.675136: : Data start: 0 Data end: 0
>           <idle>-0     [000] .Ns. 67372.675137: : Constant: 0
>           <idle>-0     [000] .Ns. 67372.675142: : Data start: 0 Data end: 0
>           <idle>-0     [000] .Ns. 67372.675143: : Constant: 0
>               ip-6458  [000] ..s. 67372.676083: : Data start: 0 Data end: 0
>               ip-6458  [000] ..s. 67372.676084: : Constant: 0
>               ip-6458  [000] ..s. 67372.676093: : Data start: 0 Data end: 0
>               ip-6458  [000] ..s. 67372.676094: : Constant: 0
>
>
> It looks like ctx->data and ctx->data_end are not 0, because the calls
> to bpf_trace_printk in those ifs aren't being called, and the constant
> is definitely not 0.
>
> What might I be missing or doing incorrectly?
>
> Thank you!
> --Zvi
