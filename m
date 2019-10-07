Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qt1-f176.google.com ([209.85.160.176]:37687 "EHLO
        mail-qt1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726889AbfJGIPY (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Mon, 7 Oct 2019 04:15:24 -0400
Received: by mail-qt1-f176.google.com with SMTP id e15so3096240qtr.4
        for <xdp-newbies@vger.kernel.org>; Mon, 07 Oct 2019 01:15:24 -0700 (PDT)
MIME-Version: 1.0
From: Radu Stoenescu <radu.stoe@gmail.com>
Date: Mon, 7 Oct 2019 11:15:12 +0300
Message-ID: <CAM-scZMSvAE0jny0b__Da1j=krBB38J8w_H_12s=sy7T=F0spQ@mail.gmail.com>
Subject: Unable to run eBPF program that uses maps
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org

I'm running this Ubuntu: Linux anemie 5.0.0-31-generic #33~18.04.1-Ubuntu SMP

I've cloned and compiled the Linux kernel - the same version and
config as of my machine's.

When trying to run the xdp_redirec_map sample program from samples/bpf I get:

sudo ./xdp_redirect_map 2 1
#=> failed to create map 0 (tx_port): 1 Operation not permitted

I read that, on certain systems, the default limit of locked memory
might pose problems, and I mitigated that as seen below:

ulimit -a

core file size          (blocks, -c) 0
data seg size           (kbytes, -d) unlimited
scheduling priority             (-e) 0
file size               (blocks, -f) unlimited
pending signals                 (-i) 31231
max locked memory       (kbytes, -l) 1024
max memory size         (kbytes, -m) unlimited
open files                      (-n) 1024
pipe size            (512 bytes, -p) 8
POSIX message queues     (bytes, -q) 819200
real-time priority              (-r) 0
stack size              (kbytes, -s) 8192
cpu time               (seconds, -t) unlimited
max user processes              (-u) 31231
virtual memory          (kbytes, -v) unlimited
file locks                      (-x) unlimited

What else can I try?

Regards
-- 
Radu Stoenescu
