Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qk1-f196.google.com ([209.85.222.196]:44748 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727340AbfGIDth (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Mon, 8 Jul 2019 23:49:37 -0400
MIME-Version: 1.0
References: <000000000000b13e1d058d2da276@google.com>
In-Reply-To: <000000000000b13e1d058d2da276@google.com>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Mon, 8 Jul 2019 20:49:25 -0700
Message-ID: <CAEf4BzaUEWwGL3k0VeiFYFqyJexQU9cDZWN69jSDpBjP1ZEcpw@mail.gmail.com>
Subject: Re: WARNING in mark_chain_precision
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: syzbot <syzbot+f21251a7468cd46efc60@syzkaller.appspotmail.com>
Cc: aaron.f.brown@intel.com, Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, "David S. Miller" <davem@davemloft.net>, hawk@kernel.org, intel-wired-lan@lists.osuosl.org, Jakub Kicinski <jakub.kicinski@netronome.com>, jeffrey.t.kirsher@intel.com, john fastabend <john.fastabend@gmail.com>, Martin Lau <kafai@fb.com>, open list <linux-kernel@vger.kernel.org>, Networking <netdev@vger.kernel.org>, sasha.neftin@intel.com, Song Liu <songliubraving@fb.com>, syzkaller-bugs@googlegroups.com, xdp-newbies@vger.kernel.org, Yonghong Song <yhs@fb.com>

#syz test: https://github.com/anakryiko/linux bpf-fix-precise-bpf_st
