Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from vulcan.natalenko.name ([104.207.131.136]:56084 "EHLO
        vulcan.natalenko.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbfEGFBG (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Tue, 7 May 2019 01:01:06 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Tue, 07 May 2019 07:01:02 +0200
From: Oleksandr Natalenko <oleksandr@natalenko.name>
Subject: Re: netronome/nfp/bpf/jit.c cannot be build with -O3
In-Reply-To: <20190506143559.31e7c968@cakuba.hsd1.ca.comcast.net>
References: <673b885183fb64f1cbb3ed2387524077@natalenko.name>
 <20190506140022.188d2b84@cakuba.hsd1.ca.comcast.net>
 <2a3761669e4ec13847205d30384c0a17@natalenko.name>
 <20190506143559.31e7c968@cakuba.hsd1.ca.comcast.net>
Message-ID: <a3e3339dd813d471b6c81fea0171f220@natalenko.name>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jakub Kicinski <jakub.kicinski@netronome.com>
Cc: "David S. Miller" <davem@davemloft.net>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, netdev@vger.kernel.org, bpf@vger.kernel.org, oss-drivers@netronome.com, linux-kernel@vger.kernel.org, xdp-newbies@vger.kernel.org, valdis@vt.edu

Hi.

On 06.05.2019 23:35, Jakub Kicinski wrote:
> I just did a make CC=gcc-8 CFLAGS=-O3 with GCC 8.2 here, and doesn't
> seem to trigger either.

I think passing CFLAGS like this is inefficient, and you should do it 
via Makefile directly.

-- 
   Oleksandr Natalenko (post-factum)
