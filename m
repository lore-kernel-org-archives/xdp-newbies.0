Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pf1-f194.google.com ([209.85.210.194]:32889 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbfBAVym (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Fri, 1 Feb 2019 16:54:42 -0500
Received: by mail-pf1-f194.google.com with SMTP id c123so3883505pfb.0
        for <xdp-newbies@vger.kernel.org>; Fri, 01 Feb 2019 13:54:41 -0800 (PST)
Date: Fri, 1 Feb 2019 13:54:36 -0800
From: Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: Re: bpf_perf_event_output() from pinned program
Message-ID: <20190201135424.607d77de@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <DM5PR0102MB3512A9C012B936AE7D9A6CCCF6920@DM5PR0102MB3512.prod.exchangelabs.com>
References: <DM5PR0102MB3512A9C012B936AE7D9A6CCCF6920@DM5PR0102MB3512.prod.exchangelabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: "Jones, Conner" <Connor.Jones@netscout.com>
Cc: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>

On Fri, 1 Feb 2019 19:29:54 +0000, Jones, Conner wrote:
> Hey All,
>=20
> I've been struggling to try to get an eBPF program attached to XDP to out=
put to a perf_event buffer. I have read the kernel samples [1][2] and found=
 Toke's sample[3] but I can't seem to get my eBPF program to output to the =
PERF_EVENT_ARRAY.=20
>=20
> My current approach is that I have a binary which pins my maps and loads =
my elf object and attaches the program to XDP. I then have a second binary =
which allocates a file descriptor for each cpu with sys_perf_event_open() a=
nd stores that to the index of the map. I then use perf_event_mmap_header()=
 to mmap all of the fds. I end by calling perf_event_poll_multi().=C2=A0
>=20
> I have determined that bpf_perf_event_output() is returning ENOENT. Which=
 makes sense when the program is first loaded but shouldn't the program use=
 the fds in the map after they are put there by the second binary? or is th=
is incorrect?
>=20
> Summary: Is my approach of using two binaries valid? Can I update the PER=
F_EVENT_ARRY with the mmap'd fds after the program is running?
>=20
> Any insight would be greatly appreciated!
>=20
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tr=
ee/samples/bpf/trace_output_user.c
> [2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tr=
ee/samples/bpf/trace_output_kern.c
> [3] https://lore.kernel.org/netdev/152830792912.21161.3609946361971472545=
.stgit@alrua-kau/

Did you give "bpftool map event_pipe" a try?  That should work, it may
help you isolate the problem to the kernel vs user space parts.
