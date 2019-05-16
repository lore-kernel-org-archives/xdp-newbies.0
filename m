Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-lj1-f194.google.com ([209.85.208.194]:37014 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726546AbfEPSnQ (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 16 May 2019 14:43:16 -0400
MIME-Version: 1.0
References: <20190516112105.12887-1-mrostecki@opensuse.org>
In-Reply-To: <20190516112105.12887-1-mrostecki@opensuse.org>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Thu, 16 May 2019 11:43:03 -0700
Message-ID: <CAADnVQLFrZyjbFb6o0YezLyqGBKcsiT=jVGfwDaupGLvgLp31A@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/2] Move bpf_printk to bpf_helpers.h
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Michal Rostecki <mrostecki@opensuse.org>
Cc: Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, Jiong Wang <jiong.wang@netronome.com>, Mathieu Xhonneux <m.xhonneux@gmail.com>, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Xdp <xdp-newbies@vger.kernel.org>

On Thu, May 16, 2019 at 4:21 AM Michal Rostecki <mrostecki@opensuse.org> wrote:
>
> This series of patches move the commonly used bpf_printk macro to
> bpf_helpers.h which is already included in all BPF programs which
> defined that macro on their own.

makes sense, but it needs to wait until bpf-next reopens.
