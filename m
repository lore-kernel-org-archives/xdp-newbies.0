Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:38106 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726281AbfBMUZ3 (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 13 Feb 2019 15:25:29 -0500
Received: from [195.222.10.250] (helo=[10.10.2.169])
        by home.regit.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <eric@regit.org>)
        id 1gu0UT-0008Mu-2M
        for xdp-newbies@vger.kernel.org; Wed, 13 Feb 2019 20:46:42 +0100
Message-ID: <96e834867100a5ae9a941c639ef93456a2600021.camel@regit.org>
Subject: Interruption in eBPF program after  kernel update
From: Eric Leblond <eric@regit.org>
Date: Wed, 13 Feb 2019 20:46:40 +0100
Content-Type: text/plain; charset="ISO-8859-15"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>

Hello,

I've got a simple socket filter program that seems to interrupt when
calling the load_word construct. I'm seeing the first message but never
the second one.

The code is the following 

int SEC("filter") hashfilter(struct __sk_buff *skb) {
    __u32 nhoff = BPF_LL_OFF + ETH_HLEN;
    __u32 ip = 0;
    __u32 *value = NULL;
#if 1
    char fmtrei[] = "word load\n";
    bpf_trace_printk(fmtrei, sizeof(fmtrei));
#endif
    ip = load_word(skb, nhoff + offsetof(struct iphdr, saddr));
#if 1
    char fmti[] = "work done\n";
    bpf_trace_printk(fmti, sizeof(fmti));
#endif

In 4.18 and above this is not working but older kernel were ok.

Any suggestion will be appreciated.

Best regards,
-- 
Eric Leblond <eric@regit.org>
