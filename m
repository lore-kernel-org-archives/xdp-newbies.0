Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-io1-f69.google.com ([209.85.166.69]:35696 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726031AbfGIEIB (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Tue, 9 Jul 2019 00:08:01 -0400
Received: by mail-io1-f69.google.com with SMTP id w17so21597017iom.2
        for <xdp-newbies@vger.kernel.org>; Mon, 08 Jul 2019 21:08:00 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 08 Jul 2019 21:08:00 -0700
In-Reply-To: <CAEf4BzZfqnFZRbDVo1-=Vph=NpOm1g=wGuV_O5Cniuxj9f9CsQ@mail.gmail.com>
Message-ID: <000000000000d676f2058d37b4a9@google.com>
Subject: Re: WARNING in __mark_chain_precision
From: syzbot <syzbot+4da3ff23081bafe74fc2@syzkaller.appspotmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: andrii.nakryiko@gmail.com, ast@kernel.org, bcrl@kvack.org, bpf@vger.kernel.org, daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org, jakub.kicinski@netronome.com, john.fastabend@gmail.com, kafai@fb.com, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, songliubraving@fb.com, syzkaller-bugs@googlegroups.com, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, xdp-newbies@vger.kernel.org, yhs@fb.com

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger  
crash:

Reported-and-tested-by:  
syzbot+4da3ff23081bafe74fc2@syzkaller.appspotmail.com

Tested on:

commit:         b9321614 bpf: fix precision bit propagation for BPF_ST ins..
git tree:       https://github.com/anakryiko/linux bpf-fix-precise-bpf_st
kernel config:  https://syzkaller.appspot.com/x/.config?x=6bb3e6e7997c14f9
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Note: testing is done by a robot and is best-effort only.
