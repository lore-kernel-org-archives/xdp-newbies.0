Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:27130 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726231AbfHNAdM (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 13 Aug 2019 20:33:12 -0400
From: Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH bpf-next 1/3] libbpf: add asm/unistd.h to xsk to get
 __NR_mmap2
Date: Wed, 14 Aug 2019 00:32:41 +0000
Message-ID: <05e5d15b-5ef9-b4dc-a76c-0d423fb2f15d@fb.com>
References: <20190813102318.5521-1-ivan.khoronzhuk@linaro.org>
 <20190813102318.5521-2-ivan.khoronzhuk@linaro.org>
In-Reply-To: <20190813102318.5521-2-ivan.khoronzhuk@linaro.org>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <ACBDF9403A26CA43B901796247CE5ED1@namprd15.prod.outlook.com>
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>, "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>, "bjorn.topel@intel.com" <bjorn.topel@intel.com>
Cc: "davem@davemloft.net" <davem@davemloft.net>, "hawk@kernel.org" <hawk@kernel.org>, "john.fastabend@gmail.com" <john.fastabend@gmail.com>, "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>, "daniel@iogearbox.net" <daniel@iogearbox.net>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>



On 8/13/19 3:23 AM, Ivan Khoronzhuk wrote:
> That's needed to get __NR_mmap2 when mmap2 syscall is used.

It seems I did not have this issue on x64 machine e.g., Fedora 29.
My glibc version is 2.28. gcc 8.2.1.

What is your particular system glibc version?
So needing kernel asm/unistd.h is because of older glibc on your
system, or something else? Could you clarify?

> 
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
> ---
>   tools/lib/bpf/xsk.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> index 5007b5d4fd2c..f2fc40f9804c 100644
> --- a/tools/lib/bpf/xsk.c
> +++ b/tools/lib/bpf/xsk.c
> @@ -12,6 +12,7 @@
>   #include <stdlib.h>
>   #include <string.h>
>   #include <unistd.h>
> +#include <asm/unistd.h>
>   #include <arpa/inet.h>
>   #include <asm/barrier.h>
>   #include <linux/compiler.h>
> 
