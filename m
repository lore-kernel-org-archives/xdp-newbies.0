Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qk1-f193.google.com ([209.85.222.193]:43270 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726491AbfGISza (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Tue, 9 Jul 2019 14:55:30 -0400
MIME-Version: 1.0
References: <CAEf4BzaUEWwGL3k0VeiFYFqyJexQU9cDZWN69jSDpBjP1ZEcpw@mail.gmail.com>
 <000000000000a94981058d37f1a4@google.com>
In-Reply-To: <000000000000a94981058d37f1a4@google.com>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Tue, 9 Jul 2019 11:55:17 -0700
Message-ID: <CAEf4BzYTGuXgN+vNJEoMbH_GFAVnSsBvq_YhvoFOeGG5Y+N_ug@mail.gmail.com>
Subject: Re: WARNING in mark_chain_precision
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: syzbot <syzbot+f21251a7468cd46efc60@syzkaller.appspotmail.com>
Cc: aaron.f.brown@intel.com, Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, "David S. Miller" <davem@davemloft.net>, hawk@kernel.org, intel-wired-lan@lists.osuosl.org, Jakub Kicinski <jakub.kicinski@netronome.com>, jeffrey.t.kirsher@intel.com, john fastabend <john.fastabend@gmail.com>, Martin Lau <kafai@fb.com>, open list <linux-kernel@vger.kernel.org>, Networking <netdev@vger.kernel.org>, sasha.neftin@intel.com, Song Liu <songliubraving@fb.com>, syzkaller-bugs@googlegroups.com, xdp-newbies@vger.kernel.org, Yonghong Song <yhs@fb.com>

Original reproducer is almost identical to the one that is fixed by
https://patchwork.ozlabs.org/patch/1129479/.

bpf_prog_free_deferred bug that's undeterministically exposed after
this fix seems to be the cause of a bunch of other bug reports and is
not related to verifier precision tracking.

#syz dup: WARNING in __mark_chain_precision
