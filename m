Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qk1-f171.google.com ([209.85.222.171]:39394 "EHLO
        mail-qk1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbfEFVgI (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Mon, 6 May 2019 17:36:08 -0400
Received: by mail-qk1-f171.google.com with SMTP id z128so6284017qkb.6
        for <xdp-newbies@vger.kernel.org>; Mon, 06 May 2019 14:36:07 -0700 (PDT)
Date: Mon, 6 May 2019 14:35:59 -0700
From: Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: Re: netronome/nfp/bpf/jit.c cannot be build with -O3
Message-ID: <20190506143559.31e7c968@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <2a3761669e4ec13847205d30384c0a17@natalenko.name>
References: <673b885183fb64f1cbb3ed2387524077@natalenko.name>
        <20190506140022.188d2b84@cakuba.hsd1.ca.comcast.net>
        <2a3761669e4ec13847205d30384c0a17@natalenko.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Oleksandr Natalenko <oleksandr@natalenko.name>
Cc: "David S. Miller" <davem@davemloft.net>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, netdev@vger.kernel.org, bpf@vger.kernel.org, oss-drivers@netronome.com, linux-kernel@vger.kernel.org, xdp-newbies@vger.kernel.org, valdis@vt.edu

On Mon, 06 May 2019 23:24:39 +0200, Oleksandr Natalenko wrote:
> Hi.
> 
> On 06.05.2019 23:00, Jakub Kicinski wrote:
> > Any chance you could try different compiler versions?  The code in
> > question does not look too unusual.  Could you try if removing
> > FIELD_FIT() on line 326 makes a difference?  
> 
> If building with gcc from CentOS 7:
> 
> gcc (GCC) 4.8.5 20150623 (Red Hat 4.8.5-36)
> 
> the issue is not reproducible.

I just did a make CC=gcc-8 CFLAGS=-O3 with GCC 8.2 here, and doesn't
seem to trigger either.

> Also, commenting out the whole "if" block with FIELD_FIT() prevents the 
> issue from occurring too.

Hm, could it be that GCC 8.3 has some constant propagation bug which
breaks BUILD_BUG_ON()?  My uneducated guess it tries to pull the mask
validation out of FIELD_FIT() and FIELD_PREP() into one place but in
doing so loses some information.
