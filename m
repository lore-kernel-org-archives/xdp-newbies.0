Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:48444 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725742AbeKPFEY (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 16 Nov 2018 00:04:24 -0500
Received: from [64.251.81.190] (helo=[172.21.59.138])
        by home.regit.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <eric@regit.org>)
        id 1gNMFo-0007WE-EU
        for xdp-newbies@vger.kernel.org; Thu, 15 Nov 2018 19:20:37 +0100
Message-ID: <92cbca4a5165be75b164271ce0f97992a16f9b39.camel@regit.org>
Subject: Pinning map and libbpf
From: Eric Leblond <eric@regit.org>
Date: Thu, 15 Nov 2018 19:20:33 +0100
Content-Type: text/plain; charset="ISO-8859-15"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Xdp <xdp-newbies@vger.kernel.org>

Hi,

I've just added an libbpf bpf_pin_obj call to a working setup and this
did cause bpf_map_lookup_elem() call to fail and return a value even if
the set is empty.

The maps structure is the following:

struct bpf_map_def SEC("maps") ipv4_drop = {
    .type = BPF_MAP_TYPE_HASH,
    .key_size = sizeof(__u32),
    .value_size = sizeof(__u32),
    .max_entries = 32768,
};

Is there something I should change ?

I'm using 4.18. 

BR,
-- 
Eric Leblond <eric@regit.org>
