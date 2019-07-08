Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34648 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388215AbfGHQbt (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Mon, 8 Jul 2019 12:31:49 -0400
Received: by mail-wr1-f65.google.com with SMTP id 31so1053321wrm.1
        for <xdp-newbies@vger.kernel.org>; Mon, 08 Jul 2019 09:31:47 -0700 (PDT)
From: Krzesimir Nowak <krzesimir@kinvolk.io>
Subject: [bpf-next v3 00/12] Test the 32bit narrow reads
Date: Mon,  8 Jul 2019 18:31:09 +0200
Message-Id: <20190708163121.18477-1-krzesimir@kinvolk.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Alban Crequy <alban@kinvolk.io>, =?UTF-8?q?Iago=20L=C3=B3pez=20Galeiras?= <iago@kinvolk.io>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org, bpf@vger.kernel.org, xdp-newbies@vger.kernel.org, Krzesimir Nowak <krzesimir@kinvolk.io>

These patches try to test the fix made in commit e2f7fc0ac695 ("bpf:
fix undefined behavior in narrow load handling"). The problem existed
in the generated BPF bytecode that was doing a 32bit narrow read of a
64bit field, so to test it the code would need to be executed.
Currently the only such field exists in BPF_PROG_TYPE_PERF_EVENT,
which was not supported by bpf_prog_test_run().

I'm sending these patches to bpf-next now as they introduce a new
feature. But maybe some of those patches could go to the bpf branch?


There is a bit of yak shaving to do for the test to be run:

1. Print why the program could not be run (patch 1).

2. Some fixes for errno clobbering (patches 2 and 3).

3. Using bpf_prog_test_run_xattr, so I can pass ctx_in stuff too
   (patch 4).

4. Adding ctx stuff and data out size override to struct bpf_test, and
   use them for the perf event tests (patches 5 and 6).

5. Some tools headers syncing (patches 7 and 8).

6. Split out some useful functions for bpf_prog_test_run
   implementation out of the net/bpf/test_run.c (patch 9)

7. Implement bpf_prog_test_run for perf event programs and test it
   (patches 10 and 11).


The last point is where I'm least sure how things should be done
properly:

1. There is a bunch of stuff to prepare for the
   bpf_perf_prog_read_value to work, and that stuff is very hacky. I
   would welcome some hints about how to set up the perf_event and
   perf_sample_data structs in a way that is a bit more future-proof
   than just setting some fields in a specific way, so some other code
   won't use some other fields (like setting event.oncpu to -1 to
   avoid event.pmu to be used for reading the value of the event).

2. The tests try to see if the test run for perf event sets up the
   context properly, so they verify the struct pt_regs contents. They
   way it is currently written Works For Me, but surely it won't work
   on other arch. So what would be the way forward? Just put the test
   case inside #ifdef __x86_64__?

3. Another thing in tests - I'm trying to make sure that the
   bpf_perf_prog_read_value helper works as it seems to be the only
   bpf perf helper that takes the ctx as a parameter. Is that enough
   or I should test other helpers too?


About the test itself - I'm not sure if it will work on a big endian
machine. I think it should, but I don't have anything handy here to
verify it.

Krzesimir Nowak (12):
  selftests/bpf: Print a message when tester could not run a program
  selftests/bpf: Avoid a clobbering of errno
  selftests/bpf: Avoid another case of errno clobbering
  selftests/bpf: Use bpf_prog_test_run_xattr
  selftests/bpf: Allow passing more information to BPF prog test run
  selftests/bpf: Make sure that preexisting tests for perf event work
  tools headers: Adopt compiletime_assert from kernel sources
  tools headers: Sync struct bpf_perf_event_data
  bpf: Split out some helper functions
  bpf: Implement bpf_prog_test_run for perf event programs
  selftests/bpf: Add tests for bpf_prog_test_run for perf events progs
  selftests/bpf: Test correctness of narrow 32bit read on 64bit field

 include/linux/bpf.h                           |  28 ++
 kernel/bpf/Makefile                           |   1 +
 kernel/bpf/test_run.c                         | 212 ++++++++++++++
 kernel/trace/bpf_trace.c                      |  60 ++++
 net/bpf/test_run.c                            | 263 +++++-------------
 tools/include/linux/compiler.h                |  28 ++
 tools/include/uapi/linux/bpf_perf_event.h     |   1 +
 tools/testing/selftests/bpf/test_verifier.c   | 197 ++++++++++++-
 .../selftests/bpf/verifier/perf_event_run.c   |  96 +++++++
 .../bpf/verifier/perf_event_sample_period.c   |   4 +
 .../testing/selftests/bpf/verifier/var_off.c  |  21 ++
 11 files changed, 700 insertions(+), 211 deletions(-)
 create mode 100644 kernel/bpf/test_run.c
 create mode 100644 tools/testing/selftests/bpf/verifier/perf_event_run.c

-- 
2.20.1
