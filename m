Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-io1-f65.google.com ([209.85.166.65]:38859 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727856AbfGAINB (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Mon, 1 Jul 2019 04:13:01 -0400
Received: by mail-io1-f65.google.com with SMTP id j6so26768302ioa.5
        for <xdp-newbies@vger.kernel.org>; Mon, 01 Jul 2019 01:13:01 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000104b00058c61eda4@google.com> <c0e440a1-30aa-a636-fe5c-44f71705857b@acm.org>
In-Reply-To: <c0e440a1-30aa-a636-fe5c-44f71705857b@acm.org>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Mon, 1 Jul 2019 10:12:49 +0200
Message-ID: <CACT4Y+Yb0mXOz=szuZ6P8X5bPzkgiDJ7+w0yb8ZG+hyRKSgN0g@mail.gmail.com>
Subject: Re: WARNING in is_bpf_text_address
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: syzbot <syzbot+bd3bba6ff3fcea7a6ec6@syzkaller.appspotmail.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, David Miller <davem@davemloft.net>, hawk@kernel.org, Jakub Kicinski <jakub.kicinski@netronome.com>, Johannes Berg <johannes.berg@intel.com>, Johannes Berg <johannes@sipsolutions.net>, John Fastabend <john.fastabend@gmail.com>, Martin KaFai Lau <kafai@fb.com>, LKML <linux-kernel@vger.kernel.org>, Waiman Long <longman@redhat.com>, Ingo Molnar <mingo@kernel.org>, netdev <netdev@vger.kernel.org>, Paul McKenney <paulmck@linux.vnet.ibm.com>, Peter Zijlstra <peterz@infradead.org>, Song Liu <songliubraving@fb.com>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Will Deacon <will.deacon@arm.com>, xdp-newbies@vger.kernel.org, Yonghong Song <yhs@fb.com>

On Fri, Jun 28, 2019 at 5:17 PM Bart Van Assche <bvanassche@acm.org> wrote:
>
> On 6/28/19 6:05 AM, syzbot wrote:
> > syzbot has bisected this bug to:
> >
> > commit a0b0fd53e1e67639b303b15939b9c653dbe7a8c4
> > Author: Bart Van Assche <bvanassche@acm.org>
> > Date:   Thu Feb 14 23:00:46 2019 +0000
> >
> >      locking/lockdep: Free lock classes that are no longer in use
> >
> > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=152f6a9da00000
> > start commit:   abf02e29 Merge tag 'pm-5.2-rc6' of
> > git://git.kernel.org/pu..
> > git tree:       upstream
> > final crash:    https://syzkaller.appspot.com/x/report.txt?x=172f6a9da00000
> > console output: https://syzkaller.appspot.com/x/log.txt?x=132f6a9da00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=28ec3437a5394ee0
> > dashboard link:
> > https://syzkaller.appspot.com/bug?extid=bd3bba6ff3fcea7a6ec6
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14ae828aa00000
> >
> > Reported-by: syzbot+bd3bba6ff3fcea7a6ec6@syzkaller.appspotmail.com
> > Fixes: a0b0fd53e1e6 ("locking/lockdep: Free lock classes that are no
> > longer in use")
> >
> > For information about bisection process see:
> > https://goo.gl/tpsmEJ#bisection
>
> Dmitry, this bisection result does not make any sense to me. Can I mark
> this bisection result myself as invalid?

Hi Bart,

syzbot does not use such bit of info for anything at the moment. So
just saying that it is invalid in this thread is enough to "mark it is
invalid" for all practical purposes. Let's consider it marked.
