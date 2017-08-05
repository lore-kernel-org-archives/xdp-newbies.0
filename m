Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.12]:16790 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751226AbdHEQlH (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Sat, 5 Aug 2017 12:41:07 -0400
Date: Sat, 5 Aug 2017 09:40:58 -0700
From: Jakub Kicinski <kubakici@wp.pl>
Subject: Re: XDP/BPF C and python libraries?
Message-ID: <20170805094058.42b2fe3e@cakuba>
In-Reply-To: <e3f6bfa8-abee-4467-9647-4c6ab7e8232a@gmail.com>
References: <20170720225308.14e2ac14@cakuba.netronome.com>
        <5971D5D6.8010300@iogearbox.net>
        <20170721153743.31cd84a0@cakuba.netronome.com>
        <20170722002050.315717be@cakuba.netronome.com>
        <e3f6bfa8-abee-4467-9647-4c6ab7e8232a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>, xdp-newbies@vger.kernel.org, ast@fb.com, Martin KaFai Lau <kafai@fb.com>, Hannes Frederic Sowa <hannes@redhat.com>

On Fri, 4 Aug 2017 16:20:19 -0600, David Ahern wrote:
> On 7/22/17 1:20 AM, Jakub Kicinski wrote:
> > I put together this very simple tool with iproute2-like syntax:
> > 
> > https://github.com/Netronome/bpf-tool
> > 
> > These are available subcommands:
> >   
> 
> Looking to add my code that pretty-prints instructions, but having
> trouble building the tool. What bpf headers should be installed? e.g.,
> <bpf/bpf.h>. hunting and pecking now based on what is in the kernel tree.

Hmm..  Did you run make install_headers?  I think my commit message
diverged from what the Makefile does.  To keep things in line with
tools/lib/traceevent/Makefile I made it a separate target.

I just tested on fresh Fedora 26 w/ net-next:

$ git rev-parse HEAD
a54df682e559da9cf09b41779ee62bc9f11d3804
$ make headers_install INSTALL_HDR_PATH=/usr/
[...]
$ cd tools/lib/bpf/
$ make -j 6
Auto-detecting system features:
...                        libelf: [ on  ]
...                           bpf: [ on  ]

Warning: tools/include/uapi/linux/bpf.h differs from kernel
  CC       libbpf.o
  CC       bpf.o
  LD       libbpf-in.o
  LINK     libbpf.a
  LINK     libbpf.so
$ sudo make install prefix=/usr/
Password: 
Warning: tools/include/uapi/linux/bpf.h differs from kernel
  INSTALL  libbpf.a
  INSTALL  libbpf.so
$ sudo make install_headers
  INSTALL  headers
$ cd ../bpf-tool
$ make
gcc -std=gnu99 -O2 -W -Wall -Wextra -Wno-unused-parameter -Wshadow   -c -MMD -o bpf-map.o bpf-map.c
gcc -std=gnu99 -O2 -W -Wall -Wextra -Wno-unused-parameter -Wshadow   -c -MMD -o bpf-prog.o bpf-prog.c
gcc -std=gnu99 -O2 -W -Wall -Wextra -Wno-unused-parameter -Wshadow   -c -MMD -o bpf-common.o bpf-common.c
gcc -std=gnu99 -O2 -W -Wall -Wextra -Wno-unused-parameter -Wshadow   -c -MMD -o bpf-jit-disasm.o bpf-jit-disasm.c
gcc -std=gnu99 -O2 -W -Wall -Wextra -Wno-unused-parameter -Wshadow -o bpftool bpf.o bpf-map.o bpf-prog.o bpf-common.o bpf-jit-disasm.o -lelf -lbpf -lelf -lbfd -lopcodes
$ ./bpftool 
Usage: ./bpftool OBJECT { COMMAND | help }
       ./bpftool batch file FILE

       OBJECT := { program | map }
