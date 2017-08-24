Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-vk0-f42.google.com ([209.85.213.42]:33944 "EHLO
        mail-vk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753391AbdHXQSO (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 24 Aug 2017 12:18:14 -0400
Received: by mail-vk0-f42.google.com with SMTP id v15so3636831vkd.1
        for <xdp-newbies@vger.kernel.org>; Thu, 24 Aug 2017 09:18:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <24D45A9F-03F3-435C-A281-98F710A789CF@renci.org>
References: <24D45A9F-03F3-435C-A281-98F710A789CF@renci.org>
From: Y Song <ys114321@gmail.com>
Date: Thu, 24 Aug 2017 09:17:32 -0700
Message-ID: <CAH3MdRV4+oZubJ36foLua_q87YGg8UsaFejKrWON5zN7DEEC5A@mail.gmail.com>
Subject: Re: modifying packets in XDP
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: Ilya Baldin <ibaldin@renci.org>
Cc: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, Tom Herbert via iovisor-dev <iovisor-dev@lists.iovisor.org>

CC to bcc mailing list as well.

bpf_probe_read is not allowed in XDP programs.

Your comparison may need to comparison not just starting offset, but
also including the memory size so the
whole write won't fall beyond the "data_end".

Regarding to bcc translates "start[off2]" to bpf_probe_read, it is
possible that bcc rewriter tries to infer bpf_probe candidate and
finds this one ...

On Thu, Aug 24, 2017 at 8:22 AM, Ilya Baldin <ibaldin@renci.org> wrote:
> Hello everyone,
>
> A couple of questions. I’m using XDP with BCC on a Fedora 25 with kernel 4.13.0-0.rc5.git0.2.fc27.x86_64 with e1000 driver. Basic XDP examples appear to work, I was able to create my own simple example counting TCP SYN packets, so the setup is at least partially correct.
>
> I’m playing around now with modifying TCP payload on the fly and failing miserably. The function that is supposed to swap two u16s in TCP payload is below
>
> static inline int swapu16(uint16_t *start, void *data_end, int off1, int off2) {
>   int len = (uint16_t*)data_end - start;
>   uint16_t poff1, poff2;
>
>   if (((void*)&start[off1] > data_end) || ((void*)&start[off2] > data_end))
>     return 0;
>
>   poff1 = start[off1];
>   poff2 = start[off2];
>
>   //start[off2] = poff1;
>   //start[off1] = poff2;
>
>   return 1;
> }
>
> and it gets called with start pointing to the beginning of the payload (I’m reasonably sure that is correct).
>
> If I *uncomment* either of the two lines in the function I get verifier errors suggesting I use bpf_probe_read. First question
>
> 1. Is what I’m attempting even possible - am I allowed to modify the packet in XDP hook? If no this may be a short conversation.
>
> 2. If it is possible, is there a canonical way of doing it compared to what I’m trying to do?
>
> 3. I actually attempted to use bpf_probe_read() (even though with the code structured as above, it appears they are inserted automatically, because the BPF program is installed properly with those two lines commented out), like in the code shown below:
>
> static inline int swapu16(uint16_t *start, void *data_end, int off1, int off2) {
>   int len = (uint16_t*)data_end - start;
>   uint16_t poff1, poff2;
>
>   if (((void*)&start[off1] > data_end) || ((void*)&start[off2] > data_end))
>     return 0;
>
>   bpf_probe_read(&poff1, sizeof(uint16_t), (void*)&start[off1]);
>   //poff1 = start[off1];
>   //poff2 = start[off2];
>
>   //start[off2] = poff1;
>   //start[off1] = poff2;
>
>   return 1;
> }
>
> I get a verifier error
> ….
> 60: (2d) if r1 > r2 goto pc+5
>  R1=inv,min_value=4,max_value=65539,min_align=1,aux_off_align=2 R2=pkt_end R3=inv,min_value=2,max_value=65537,min_align=1,aux_off_align=2 R4=imm0,min_value=0,max_value=0,min_align=2147483648 R5=pkt(id=0,off=42,r=42) R6=pkt(id=1,off=0,r=20),aux_off_align=2 R7=imm0,min_value=0,max_value=0,min_align=2147483648 R10=fp
> 61: (bf) r1 = r10
> 62: (07) r1 += -32
> 63: (b7) r2 = 2
> 64: (85) call bpf_probe_read#4
> unknown func bpf_probe_read#4
>
> which is really strange. In fact it appears I’m unable to invoke any of the helper bpf functions explicitly.
>
> Many thanks for your suggestions.
>
> -ilya
>
> Ilya Baldin
