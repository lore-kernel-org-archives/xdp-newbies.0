Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pl1-f194.google.com ([209.85.214.194]:35568 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726730AbfF1PRU (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 28 Jun 2019 11:17:20 -0400
Subject: Re: WARNING in is_bpf_text_address
References: <000000000000104b00058c61eda4@google.com>
From: Bart Van Assche <bvanassche@acm.org>
Message-ID: <c0e440a1-30aa-a636-fe5c-44f71705857b@acm.org>
Date: Fri, 28 Jun 2019 08:17:16 -0700
MIME-Version: 1.0
In-Reply-To: <000000000000104b00058c61eda4@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: syzbot <syzbot+bd3bba6ff3fcea7a6ec6@syzkaller.appspotmail.com>, akpm@linux-foundation.org, ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org, jakub.kicinski@netronome.com, johannes.berg@intel.com, johannes@sipsolutions.net, john.fastabend@gmail.com, kafai@fb.com, linux-kernel@vger.kernel.org, longman@redhat.com, mingo@kernel.org, netdev@vger.kernel.org, paulmck@linux.vnet.ibm.com, peterz@infradead.org, songliubraving@fb.com, syzkaller-bugs@googlegroups.com, tglx@linutronix.de, tj@kernel.org, torvalds@linux-foundation.org, will.deacon@arm.com, xdp-newbies@vger.kernel.org, yhs@fb.com, Dmitry Vyukov <dvyukov@google.com>

On 6/28/19 6:05 AM, syzbot wrote:
> syzbot has bisected this bug to:
> 
> commit a0b0fd53e1e67639b303b15939b9c653dbe7a8c4
> Author: Bart Van Assche <bvanassche@acm.org>
> Date:   Thu Feb 14 23:00:46 2019 +0000
> 
>      locking/lockdep: Free lock classes that are no longer in use
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=152f6a9da00000
> start commit:   abf02e29 Merge tag 'pm-5.2-rc6' of 
> git://git.kernel.org/pu..
> git tree:       upstream
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=172f6a9da00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=132f6a9da00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=28ec3437a5394ee0
> dashboard link: 
> https://syzkaller.appspot.com/bug?extid=bd3bba6ff3fcea7a6ec6
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14ae828aa00000
> 
> Reported-by: syzbot+bd3bba6ff3fcea7a6ec6@syzkaller.appspotmail.com
> Fixes: a0b0fd53e1e6 ("locking/lockdep: Free lock classes that are no 
> longer in use")
> 
> For information about bisection process see: 
> https://goo.gl/tpsmEJ#bisection

Dmitry, this bisection result does not make any sense to me. Can I mark 
this bisection result myself as invalid?

Thanks,

Bart.
