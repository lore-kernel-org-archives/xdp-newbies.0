Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38713 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389910AbfETQxY (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 20 May 2019 12:53:24 -0400
Received: by mail-pf1-f195.google.com with SMTP id b76so7513567pfb.5
        for <xdp-newbies@vger.kernel.org>; Mon, 20 May 2019 09:53:23 -0700 (PDT)
Date: Mon, 20 May 2019 09:53:22 -0700
From: Stanislav Fomichev <sdf@fomichev.me>
Subject: Re: [PATCH 2/5] libbpf: add missing typedef
Message-ID: <20190520165322.GH10244@mini-arch>
References: <20190518004639.20648-1-mcroce@redhat.com>
 <20190518004639.20648-2-mcroce@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190518004639.20648-2-mcroce@redhat.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Matteo Croce <mcroce@redhat.com>
Cc: xdp-newbies@vger.kernel.org, bpf@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>

On 05/18, Matteo Croce wrote:
> Sync tools/include/linux/types.h with the UAPI one to fix this build error:
> 
> make -C samples/bpf/../../tools/lib/bpf/ RM='rm -rf' LDFLAGS= srctree=samples/bpf/../../ O=
>   HOSTCC  samples/bpf/sock_example
> In file included from samples/bpf/sock_example.c:27:
> /usr/include/linux/ip.h:102:2: error: unknown type name ‘__sum16’
>   102 |  __sum16 check;
>       |  ^~~~~~~
> make[2]: *** [scripts/Makefile.host:92: samples/bpf/sock_example] Error 1
> make[1]: *** [Makefile:1763: samples/bpf/] Error 2
> 
> Signed-off-by: Matteo Croce <mcroce@redhat.com>
> ---
>  tools/include/linux/types.h | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/tools/include/linux/types.h b/tools/include/linux/types.h
> index 154eb4e3ca7c..5266dbfee945 100644
> --- a/tools/include/linux/types.h
> +++ b/tools/include/linux/types.h
> @@ -58,6 +58,9 @@ typedef __u32 __bitwise __be32;
>  typedef __u64 __bitwise __le64;
>  typedef __u64 __bitwise __be64;
>  
> +typedef __u16 __bitwise __sum16;
> +typedef __u32 __bitwise __wsum;
If you do that, you should probably remove 'typedef __u16 __sum16;'
from test_progs.h:

https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git/tree/tools/testing/selftests/bpf/test_progs.h#n13

> +
>  typedef struct {
>  	int counter;
>  } atomic_t;
> -- 
> 2.21.0
> 
