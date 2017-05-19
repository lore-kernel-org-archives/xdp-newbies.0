Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:38336 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750718AbdESHj3 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 19 May 2017 03:39:29 -0400
Received: by mail-wm0-f48.google.com with SMTP id v15so77310148wmv.1
        for <xdp-newbies@vger.kernel.org>; Fri, 19 May 2017 00:39:28 -0700 (PDT)
Subject: Re: BPF Verifier Overview
References: <20170518.140009.2301493573177276287.davem@davemloft.net>
From: Quentin Monnet <quentin.monnet@6wind.com>
Message-ID: <fec0a8a5-766f-0fb4-3d54-7dddd372cbaf@6wind.com>
Date: Fri, 19 May 2017 09:39:22 +0200
MIME-Version: 1.0
In-Reply-To: <20170518.140009.2301493573177276287.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: David Miller <davem@davemloft.net>, xdp-newbies@vger.kernel.org

Thanks a lot for this overview!

2017-05-18 (14:00 -0400) ~ David Miller <davem@davemloft.net>
> 
[…]
> 
> You can capture dumps like this quite simply by using the
> bpf_verify_program() library helper.  You can see how this is
> used in tools/testing/samples/bpf/test_align.c

Minor correction: the actual path seems to be
tools/testing/selftests/bpf/test_align.c

Best,
Quentin
