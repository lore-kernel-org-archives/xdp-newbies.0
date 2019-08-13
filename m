Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from smtp3.emailarray.com ([65.39.216.17]:54538 "EHLO
        smtp3.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726323AbfHMRn1 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 13 Aug 2019 13:43:27 -0400
From: "Jonathan Lemon" <jlemon@flugsvamp.com>
Subject: Re: [PATCH bpf-next 1/3] libbpf: add asm/unistd.h to xsk to get
 __NR_mmap2
Date: Tue, 13 Aug 2019 10:36:42 -0700
Message-ID: <12D743F3-6BA0-4D9D-A80D-613EB0F86816@flugsvamp.com>
In-Reply-To: <20190813102318.5521-2-ivan.khoronzhuk@linaro.org>
References: <20190813102318.5521-1-ivan.khoronzhuk@linaro.org>
 <20190813102318.5521-2-ivan.khoronzhuk@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc: magnus.karlsson@intel.com, bjorn.topel@intel.com, davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com, jakub.kicinski@netronome.com, daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org, xdp-newbies@vger.kernel.org, linux-kernel@vger.kernel.org



On 13 Aug 2019, at 3:23, Ivan Khoronzhuk wrote:

> That's needed to get __NR_mmap2 when mmap2 syscall is used.
>
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>

Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
