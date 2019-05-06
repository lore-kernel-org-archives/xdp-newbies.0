Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qt1-f174.google.com ([209.85.160.174]:42868 "EHLO
        mail-qt1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726383AbfEFVAb (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Mon, 6 May 2019 17:00:31 -0400
Received: by mail-qt1-f174.google.com with SMTP id p20so16539613qtc.9
        for <xdp-newbies@vger.kernel.org>; Mon, 06 May 2019 14:00:30 -0700 (PDT)
Date: Mon, 6 May 2019 14:00:22 -0700
From: Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: Re: netronome/nfp/bpf/jit.c cannot be build with -O3
Message-ID: <20190506140022.188d2b84@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <673b885183fb64f1cbb3ed2387524077@natalenko.name>
References: <673b885183fb64f1cbb3ed2387524077@natalenko.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Oleksandr Natalenko <oleksandr@natalenko.name>
Cc: "David S. Miller" <davem@davemloft.net>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, netdev@vger.kernel.org, bpf@vger.kernel.org, oss-drivers@netronome.com, linux-kernel@vger.kernel.org, xdp-newbies@vger.kernel.org, valdis@vt.edu

On Mon, 06 May 2019 21:40:07 +0200, Oleksandr Natalenko wrote:
> Hi.
> 
> Obligatory disclaimer: building the kernel with -O3 is a non-standard 
> thing done via this patch [1], but I've asked people in #kernelnewbies, 
> and it was suggested that the issue should be still investigated.
> 
> So, with v5.1 kernel release I cannot build the kernel with -O3 anymore. 
> It fails as shown below:

Any chance you could try different compiler versions?  The code in
question does not look too unusual.  Could you try if removing
FIELD_FIT() on line 326 makes a difference?
