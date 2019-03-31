Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-io1-f71.google.com ([209.85.166.71]:50238 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730662AbfCaSUB (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Sun, 31 Mar 2019 14:20:01 -0400
Received: by mail-io1-f71.google.com with SMTP id s24so6313632ioe.17
        for <xdp-newbies@vger.kernel.org>; Sun, 31 Mar 2019 11:20:01 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 31 Mar 2019 11:20:00 -0700
In-Reply-To: <000000000000e92d1805711f5552@google.com>
Message-ID: <000000000000bbcb82058567f37d@google.com>
Subject: Re: WARNING in bpf_jit_free
From: syzbot <syzbot+2ff1e7cb738fd3c41113@syzkaller.appspotmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: airlied@linux.ie, ast@kernel.org, bpf@vger.kernel.org, daniel@ffwll.ch, daniel@iogearbox.net, davem@davemloft.net, dri-devel@lists.freedesktop.org, hawk@kernel.org, jakub.kicinski@netronome.com, john.fastabend@gmail.com, kafai@fb.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, maxime.ripard@bootlin.com, netdev@vger.kernel.org, paul.kocialkowski@bootlin.com, songliubraving@fb.com, syzkaller-bugs@googlegroups.com, wens@csie.org, xdp-newbies@vger.kernel.org, yhs@fb.com

syzbot has bisected this bug to:

commit 0fff724a33917ac581b5825375d0b57affedee76
Author: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Date:   Fri Jan 18 14:51:13 2019 +0000

     drm/sun4i: backend: Use explicit fourcc helpers for packed YUV422 check

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1467550f200000
start commit:   0e40da3e Merge tag 'kbuild-fixes-v5.1' of git://git.kernel..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=1667550f200000
console output: https://syzkaller.appspot.com/x/log.txt?x=1267550f200000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8dcdce25ea72bedf
dashboard link: https://syzkaller.appspot.com/bug?extid=2ff1e7cb738fd3c41113
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16973653200000

Reported-by: syzbot+2ff1e7cb738fd3c41113@syzkaller.appspotmail.com
Fixes: 0fff724a3391 ("drm/sun4i: backend: Use explicit fourcc helpers for  
packed YUV422 check")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
