Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qk1-f196.google.com ([209.85.222.196]:33303 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbfGIDtU (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Mon, 8 Jul 2019 23:49:20 -0400
MIME-Version: 1.0
References: <000000000000a5d738058d2d1396@google.com>
In-Reply-To: <000000000000a5d738058d2d1396@google.com>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Mon, 8 Jul 2019 20:49:08 -0700
Message-ID: <CAEf4BzZfqnFZRbDVo1-=Vph=NpOm1g=wGuV_O5Cniuxj9f9CsQ@mail.gmail.com>
Subject: Re: WARNING in __mark_chain_precision
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: syzbot <syzbot+4da3ff23081bafe74fc2@syzkaller.appspotmail.com>
Cc: Alexei Starovoitov <ast@kernel.org>, bcrl@kvack.org, bpf <bpf@vger.kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, "David S. Miller" <davem@davemloft.net>, hawk@kernel.org, Jakub Kicinski <jakub.kicinski@netronome.com>, john fastabend <john.fastabend@gmail.com>, Martin Lau <kafai@fb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, open list <linux-kernel@vger.kernel.org>, Networking <netdev@vger.kernel.org>, Song Liu <songliubraving@fb.com>, syzkaller-bugs@googlegroups.com, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, xdp-newbies@vger.kernel.org, Yonghong Song <yhs@fb.com>

#syz test: https://github.com/anakryiko/linux bpf-fix-precise-bpf_st
