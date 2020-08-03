Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:21934 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725945AbgHCQ27 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 3 Aug 2020 12:28:59 -0400
Subject: Re: Clang target bpf compile issue/fail on Ubuntu and Debian
References: <20200729211341.1a713559@carbon>
From: Yonghong Song <yhs@fb.com>
Message-ID: <c2bf6327-f9c5-b78e-ed7f-d4f78e216db3@fb.com>
Date: Mon, 3 Aug 2020 09:28:31 -0700
In-Reply-To: <20200729211341.1a713559@carbon>
Content-Language: en-US
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Jesper Dangaard Brouer <brouer@redhat.com>, Andrii Nakryiko <andrii.nakryiko@gmail.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <borkmann@iogearbox.net>, BPF-dev-list <bpf@vger.kernel.org>, "iovisor-dev@lists.iovisor.org" <iovisor-dev@lists.iovisor.org>
Cc: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, Arnaldo Carvalho de Melo <acme@redhat.com>, Jiri Olsa <jolsa@redhat.com>, Shaun Crampton <shaun@tigera.io>, steve.langasek@canonical.com, wookey@debian.org, Yonghong Song <ys114321@gmail.com>



On 7/29/20 12:13 PM, Jesper Dangaard Brouer wrote:
> 
> The BPF UAPI header file <linux/bpf.h> includes <linux/types.h>, which gives
> BPF-programs access to types e.g. __u32, __u64, __u8, etc.
> 
> On Ubuntu/Debian when compiling with clang option[1] "-target bpf" the
> compile fails because it cannot find the file <asm/types.h>, which is
> included from <linux/types.h>. This is because Ubuntu/Debian tries to
> support multiple architectures on a single system[2]. On x86_64 the file
> <asm/types.h> is located in /usr/include/x86_64-linux-gnu/, which the distro
> compiler will add to it's search path (/usr/include/<triplet> [3]). Note, it
> works if not specifying target bpf, but as explained in kernel doc[1] the
> clang target bpf should really be used (to avoid other issues).
> 
> There are two workarounds: (1) To have an extra include dir on Ubuntu (which
> seems too x86 specific) like: CFLAGS += -I/usr/include/x86_64-linux-gnu .

How about non x86 architecture? It will be something like 
/usr/include/aarch64-linux-gnu? Do you think we could have some header 
file conflict
since this directory may contain a lot other header files as well?

> Or (2) install the package gcc-multilib on Ubuntu.

I think having a /usr/include/bpf-unknown-none and the distro add this
path to the compiler has target bpf. In this way, only necessary header
files will be put there. Less potential issues.

But in either case, it will be good if this level of details are
hidden from the user.

I am not super familiar with the distro packaging of a particular 
compiler and its include directories. The above is just my 2 cents.

> 
> The question is: Should Ubuntu/Debian have a /usr/include/<triplet>
> directory for BPF? (as part of their multi-arch approach)
> 
> Or should clang use the compile-host's triplet for the /usr/include/triplet
> path even when giving clang -target bpf option?
> 
> p.s. GCC choose 'bpf-unknown-none' target triplet for BPF.
> 
> 
> Links:
> [1] https://www.kernel.org/doc/html/latest/bpf/bpf_devel_QA.html#q-clang-flag-for-target-bpf
> [2] https://urldefense.proofpoint.com/v2/url?u=https-3A__wiki.ubuntu.com_MultiarchSpec&d=DwICAg&c=5VD0RTtNlTh3ycd41b3MUw&r=DA8e1B5r073vIqRrFz7MRA&m=ZEguArah72427WZMt53NXZa8LuQEGJKvCOgjH96NggQ&s=5xL0VWya8ULHcj4pfw6oxqHoKWIXNfJnj2G7rdaQyR8&e=
> [3] https://urldefense.proofpoint.com/v2/url?u=https-3A__wiki.osdev.org_Target-5FTriplet&d=DwICAg&c=5VD0RTtNlTh3ycd41b3MUw&r=DA8e1B5r073vIqRrFz7MRA&m=ZEguArah72427WZMt53NXZa8LuQEGJKvCOgjH96NggQ&s=mym8eKus7o0PzfkC2-IMyPU84OwVb2_A4ky2JHcdexQ&e=
> 
