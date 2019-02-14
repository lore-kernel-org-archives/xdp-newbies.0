Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:48758 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730191AbfBNLUy (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 14 Feb 2019 06:20:54 -0500
Received: from [2a07:1181:151:0:959e:2f80:414f:6d2f]
        by home.regit.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <eric@regit.org>)
        id 1guF4W-0006YR-UJ
        for xdp-newbies@vger.kernel.org; Thu, 14 Feb 2019 12:20:53 +0100
Message-ID: <509b74cb74f13b02122707d2505e5c690866b159.camel@regit.org>
Subject: Re: Interruption in eBPF program after  kernel update
From: Eric Leblond <eric@regit.org>
Date: Thu, 14 Feb 2019 12:20:50 +0100
In-Reply-To: <96e834867100a5ae9a941c639ef93456a2600021.camel@regit.org>
References: <96e834867100a5ae9a941c639ef93456a2600021.camel@regit.org>
Content-Type: text/plain; charset="ISO-8859-15"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>

Hello,

On Wed, 2019-02-13 at 20:46 +0100, Eric Leblond wrote:
> Hello,
> 
> I've got a simple socket filter program that seems to interrupt when
> calling the load_word construct. I'm seeing the first message but
> never
> the second one.
> 
> The code is the following 
> 
> int SEC("filter") hashfilter(struct __sk_buff *skb) {
>     __u32 nhoff = BPF_LL_OFF + ETH_HLEN;

So it seems the problem was coming from this line. Removing BPF_LL_OFF
fixes the problem for kernel starting 4.18.

Is this a known issue ?

Is there something that would allow a BPF file to work independently of
the kernel version ?

>     __u32 ip = 0;
>     __u32 *value = NULL;
> #if 1
>     char fmtrei[] = "word load\n";
>     bpf_trace_printk(fmtrei, sizeof(fmtrei));
> #endif
>     ip = load_word(skb, nhoff + offsetof(struct iphdr, saddr));
> #if 1
>     char fmti[] = "work done\n";
>     bpf_trace_printk(fmti, sizeof(fmti));
> #endif

> In 4.18 and above this is not working but older kernel were ok.
> 
> Any suggestion will be appreciated.
> 
> Best regards,

BR,
-- 
Eric Leblond <eric@regit.org>
