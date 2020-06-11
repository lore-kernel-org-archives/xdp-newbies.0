Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbgFKQkE (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 11 Jun 2020 12:40:04 -0400
MIME-Version: 1.0
References: <CAMDScmnpbPgs+mB_aMY16aXLMMWBgfu0sqna06MH8RPoGpw7_Q@mail.gmail.com>
 <87imfy7hrx.fsf@toke.dk> <CAMDScmm5nCzeffaeEuSFHATunsH36XW2VzbsFCuWhU5OYr_naA@mail.gmail.com>
 <87a71a7gay.fsf@toke.dk> <CAMDScmnTYKfjMjiqLGduY4Pk3X0D7RQhjtY7DuPmh65VMNeCRw@mail.gmail.com>
 <20200611125952.3527dfdb@carbon> <CAEf4BzafLSnjjqdeH9-Wu7J69a=7_3gmqqDBV8ysTOTmnvmtyw@mail.gmail.com>
In-Reply-To: <CAEf4BzafLSnjjqdeH9-Wu7J69a=7_3gmqqDBV8ysTOTmnvmtyw@mail.gmail.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Thu, 11 Jun 2020 09:39:48 -0700
Message-ID: <CAADnVQKB6+8JWVWfn+p2gcooVvoW1LEv7Lsv17+GrApy+osWLw@mail.gmail.com>
Subject: Re: [iovisor-dev] Error loading xdp program that worked with bpf_load
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>, Elerion <elerion1000@gmail.com>, "iovisor-dev@lists.iovisor.org" <iovisor-dev@lists.iovisor.org>, =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>, Xdp <xdp-newbies@vger.kernel.org>, Yonghong Song <ys114321@gmail.com>, bpf <bpf@vger.kernel.org>

On Thu, Jun 11, 2020 at 9:35 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Thu, Jun 11, 2020 at 4:00 AM Jesper Dangaard Brouer
> <brouer@redhat.com> wrote:
> >
> > (Cross-posting to iovisor-dev)
> >
> > Seeking input from BPF-llvm developers. How come Clang/LLVM 10+ is
> > generating incompatible BTF-info in ELF file, and downgrading to LLVM-9
> > fixes the issue ?
> >
> >
> > On Wed, 10 Jun 2020 14:50:27 -0700 Elerion <elerion1000@gmail.com> wrote:
> >
> > > Never mind, I fixed it by downgrading to Clang 9.
> > >
> > > It appears to be an issue with Clang/LLVM 10+
> > >
> > > https://github.com/cilium/ebpf/issues/43
>
> This is newer Clang recording that function is global, not static.
> libbpf is sanitizing BTF to remove this flag, if kernel doesn't
> support this. But given this is re-implementation of libbpf, that's
> probably not happening, right?

just running ./test_xdp_veth.sh on the latest bpf-next with the latest
clang I see:
BTF debug data section '.BTF' rejected: Invalid argument (22)!
 - Length:       514
Verifier analysis:
...
[11] VAR _license type_id=9 linkage=1
[12] DATASEC license size=0 vlen=1 size == 0


BTF debug data section '.BTF' rejected: Invalid argument (22)!
 - Length:       494
Verifier analysis:
...
[11] VAR _license type_id=9 linkage=1
[12] DATASEC license size=0 vlen=1 size == 0


BTF debug data section '.BTF' rejected: Invalid argument (22)!
11] VAR _license type_id=9 linkage=1
[12] DATASEC license size=0 vlen=1 size == 0

PING 10.1.1.33 (10.1.1.33) 56(84) bytes of data.
64 bytes from 10.1.1.33: icmp_seq=1 ttl=64 time=0.042 ms

--- 10.1.1.33 ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 0.042/0.042/0.042/0.000 ms
selftests: xdp_veth [PASS]

Is that just the noise from libbpf probing or what?
