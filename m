Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:49440 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726581AbgG2TOB (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 29 Jul 2020 15:14:01 -0400
Date: Wed, 29 Jul 2020 21:13:41 +0200
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Clang target bpf compile issue/fail on Ubuntu and Debian
Message-ID: <20200729211341.1a713559@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andrii.nakryiko@gmail.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <borkmann@iogearbox.net>, BPF-dev-list <bpf@vger.kernel.org>, "iovisor-dev@lists.iovisor.org" <iovisor-dev@lists.iovisor.org>
Cc: brouer@redhat.com, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, Arnaldo Carvalho de Melo <acme@redhat.com>, Jiri Olsa <jolsa@redhat.com>, Shaun Crampton <shaun@tigera.io>, steve.langasek@canonical.com, wookey@debian.org, Yonghong Song <ys114321@gmail.com>


The BPF UAPI header file <linux/bpf.h> includes <linux/types.h>, which gives
BPF-programs access to types e.g. __u32, __u64, __u8, etc.

On Ubuntu/Debian when compiling with clang option[1] "-target bpf" the
compile fails because it cannot find the file <asm/types.h>, which is
included from <linux/types.h>. This is because Ubuntu/Debian tries to
support multiple architectures on a single system[2]. On x86_64 the file
<asm/types.h> is located in /usr/include/x86_64-linux-gnu/, which the distro
compiler will add to it's search path (/usr/include/<triplet> [3]). Note, it
works if not specifying target bpf, but as explained in kernel doc[1] the
clang target bpf should really be used (to avoid other issues).

There are two workarounds: (1) To have an extra include dir on Ubuntu (which
seems too x86 specific) like: CFLAGS += -I/usr/include/x86_64-linux-gnu .
Or (2) install the package gcc-multilib on Ubuntu.

The question is: Should Ubuntu/Debian have a /usr/include/<triplet>
directory for BPF? (as part of their multi-arch approach)

Or should clang use the compile-host's triplet for the /usr/include/triplet
path even when giving clang -target bpf option?

p.s. GCC choose 'bpf-unknown-none' target triplet for BPF.


Links:
[1] https://www.kernel.org/doc/html/latest/bpf/bpf_devel_QA.html#q-clang-flag-for-target-bpf
[2] https://wiki.ubuntu.com/MultiarchSpec
[3] https://wiki.osdev.org/Target_Triplet
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
