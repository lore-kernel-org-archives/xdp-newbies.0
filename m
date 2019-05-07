Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from vulcan.natalenko.name ([104.207.131.136]:56392 "EHLO
        vulcan.natalenko.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbfEGFFW (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Tue, 7 May 2019 01:05:22 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Tue, 07 May 2019 07:05:18 +0200
From: Oleksandr Natalenko <oleksandr@natalenko.name>
Subject: Re: [oss-drivers] netronome/nfp/bpf/jit.c cannot be build with -O3
In-Reply-To: <87mujzutsw.fsf@netronome.com>
References: <673b885183fb64f1cbb3ed2387524077@natalenko.name>
 <87mujzutsw.fsf@netronome.com>
Message-ID: <4414f1798ea3c0f70128b7e4caa14edc@natalenko.name>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jiong Wang <jiong.wang@netronome.com>
Cc: Jakub Kicinski <jakub.kicinski@netronome.com>, "David S. Miller" <davem@davemloft.net>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, netdev@vger.kernel.org, bpf@vger.kernel.org, oss-drivers@netronome.com, linux-kernel@vger.kernel.org, xdp-newbies@vger.kernel.org, valdis@vt.edu

Hi.

On 07.05.2019 00:01, Jiong Wang wrote:
> I guess it's because constant prop. Could you try the following change 
> to
> __emit_shift?
> 
> drivers/net/ethernet/netronome/nfp/bpf/jit.c
> __emit_shift:331
> -       if (sc == SHF_SC_L_SHF)
> +       if (sc == SHF_SC_L_SHF && shift)
>                 shift = 32 - shift;
> 
> emit_shf_indir is passing "0" as shift to __emit_shift which will
> eventually be turned into 32 and it was OK because we truncate to 
> 5-bit,
> but before truncation, it will overflow the shift mask.

Yup, it silences the error for me.

-- 
   Oleksandr Natalenko (post-factum)
