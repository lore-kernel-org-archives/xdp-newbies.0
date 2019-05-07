Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-wm1-f43.google.com ([209.85.128.43]:55847 "EHLO
        mail-wm1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbfEGLbe (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Tue, 7 May 2019 07:31:34 -0400
Received: by mail-wm1-f43.google.com with SMTP id y2so19678345wmi.5
        for <xdp-newbies@vger.kernel.org>; Tue, 07 May 2019 04:31:33 -0700 (PDT)
References: <673b885183fb64f1cbb3ed2387524077@natalenko.name> <87mujzutsw.fsf@netronome.com> <4414f1798ea3c0f70128b7e4caa14edc@natalenko.name>
From: Jiong Wang <jiong.wang@netronome.com>
Subject: Re: [oss-drivers] netronome/nfp/bpf/jit.c cannot be build with -O3
In-reply-to: <4414f1798ea3c0f70128b7e4caa14edc@natalenko.name>
Date: Tue, 07 May 2019 12:31:29 +0100
Message-ID: <87ef5abiwe.fsf@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Oleksandr Natalenko <oleksandr@natalenko.name>
Cc: Jiong Wang <jiong.wang@netronome.com>, Jakub Kicinski <jakub.kicinski@netronome.com>, "David S. Miller" <davem@davemloft.net>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, netdev@vger.kernel.org, bpf@vger.kernel.org, oss-drivers@netronome.com, linux-kernel@vger.kernel.org, xdp-newbies@vger.kernel.org, valdis@vt.edu


Oleksandr Natalenko writes:

> Hi.
>
> On 07.05.2019 00:01, Jiong Wang wrote:
>> I guess it's because constant prop. Could you try the following change 
>> to
>> __emit_shift?
>> 
>> drivers/net/ethernet/netronome/nfp/bpf/jit.c
>> __emit_shift:331
>> -       if (sc == SHF_SC_L_SHF)
>> +       if (sc == SHF_SC_L_SHF && shift)
>>                 shift = 32 - shift;
>> 
>> emit_shf_indir is passing "0" as shift to __emit_shift which will
>> eventually be turned into 32 and it was OK because we truncate to 
>> 5-bit,
>> but before truncation, it will overflow the shift mask.
>
> Yup, it silences the error for me.

Thanks for the testing.

I have also reproduced this issue after switching to gcc 8.3, and confirmed
the error is triggered from "value too large for the field" check inside
__BF_FIELD_CHECK due to immediate "32" is out of range for mask 0x1f.

Will send out a fix.

Regards,
Jiong
