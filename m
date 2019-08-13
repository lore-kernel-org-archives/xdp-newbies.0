Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qt1-f196.google.com ([209.85.160.196]:32994 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbfHMXiZ (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 13 Aug 2019 19:38:25 -0400
MIME-Version: 1.0
References: <20190813102318.5521-1-ivan.khoronzhuk@linaro.org> <20190813102318.5521-2-ivan.khoronzhuk@linaro.org>
In-Reply-To: <20190813102318.5521-2-ivan.khoronzhuk@linaro.org>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Tue, 13 Aug 2019 16:38:13 -0700
Message-ID: <CAEf4BzZ2y_DmTXkVqFh6Hdcquo6UvntvCygw5h5WwrWYXRRg_g@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/3] libbpf: add asm/unistd.h to xsk to get __NR_mmap2
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc: Magnus Karlsson <magnus.karlsson@intel.com>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>, "David S. Miller" <davem@davemloft.net>, Jesper Dangaard Brouer <hawk@kernel.org>, john fastabend <john.fastabend@gmail.com>, Jakub Kicinski <jakub.kicinski@netronome.com>, Daniel Borkmann <daniel@iogearbox.net>, Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, xdp-newbies@vger.kernel.org, open list <linux-kernel@vger.kernel.org>

On Tue, Aug 13, 2019 at 3:24 AM Ivan Khoronzhuk
<ivan.khoronzhuk@linaro.org> wrote:
>
> That's needed to get __NR_mmap2 when mmap2 syscall is used.
>
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
> ---
>  tools/lib/bpf/xsk.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> index 5007b5d4fd2c..f2fc40f9804c 100644
> --- a/tools/lib/bpf/xsk.c
> +++ b/tools/lib/bpf/xsk.c
> @@ -12,6 +12,7 @@
>  #include <stdlib.h>
>  #include <string.h>
>  #include <unistd.h>
> +#include <asm/unistd.h>

asm/unistd.h is not present in Github libbpf projection. Is there any
way to avoid including this header? Generally, libbpf can't easily use
all of kernel headers, we need to re-implemented all the extra used
stuff for Github version of libbpf, so we try to minimize usage of new
headers that are not just plain uapi headers from include/uapi.

>  #include <arpa/inet.h>
>  #include <asm/barrier.h>
>  #include <linux/compiler.h>
> --
> 2.17.1
>
