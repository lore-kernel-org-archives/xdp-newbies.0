Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-yw1-f66.google.com ([209.85.161.66]:40733 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbfJDWWI (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Fri, 4 Oct 2019 18:22:08 -0400
MIME-Version: 1.0
From: "Daniel T. Lee" <danieltimlee@gmail.com>
Date: Sat, 5 Oct 2019 07:21:50 +0900
Message-ID: <CAEKGpzhoYHrE4NTvaWSpy-R6CiLYehGHzLM6v+-9j8iemNyK0g@mail.gmail.com>
Subject: samples/bpf not working?
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: bpf <bpf@vger.kernel.org>, xdp-newbies@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>, Alexei Starovoitov <ast@kernel.org>, netdev <netdev@vger.kernel.org>

Currently, building the bpf samples isn't working.
Running make from the directory 'samples/bpf' will just shows following
result without compiling any samples.

$ make
make -C ../../ /git/linux/samples/bpf/ BPF_SAMPLES_PATH=/git/linux/samples/bpf
make[1]: Entering directory '/git/linux'
  CALL    scripts/checksyscalls.sh
  CALL    scripts/atomic/check-atomics.sh
  DESCEND  objtool
make[1]: Leaving directory '/git/linux'
$ ls *kern.o
ls: cannot access '*kern.o': No such file or directory

By using 'git bisect', found the problem is derived from below commit.
commit 394053f4a4b3 ("kbuild: make single targets work more correctly")

> Currently, the single target build directly descends into the directory
> of the target. For example,
>
>     $ make foo/bar/baz.o
>
> ... directly descends into foo/bar/.
>
> On the other hand, the normal build usually descends one directory at
> a time, i.e. descends into foo/, and then foo/bar/.
>
> This difference causes some problems.
>
> [...]
>
> This commit fixes those problems by making the single target build
> descend in the same way as the normal build does.

Not familiar with kbuild, so I'm not sure why this led to build failure.
My humble guess is, samples/bpf/Makefile tries to run make from current
directory, 'sample/bpf', but somehow upper commit changed the way it works.

samples/bpf/Makefile:232
# Trick to allow make to be run from this directory
all:
        $(MAKE) -C ../../ $(CURDIR)/ BPF_SAMPLES_PATH=$(CURDIR)

I've tried to figure out the problem with 'make --trace', but not sure why
it's not working. Just a hunch with build directory.

Any ideas to fix this problem?
