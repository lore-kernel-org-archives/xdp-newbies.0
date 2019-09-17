Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-eopbgr150057.outbound.protection.outlook.com ([40.107.15.57]:21566
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728127AbfIQI2B (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 17 Sep 2019 04:28:01 -0400
From: Vlad Buslov <vladbu@mellanox.com>
Subject: Re: BUG: sleeping function called from invalid context in
 tcf_chain0_head_change_cb_del
Date: Tue, 17 Sep 2019 08:27:55 +0000
Message-ID: <vbfk1a7cooq.fsf@mellanox.com>
References: <00000000000029a3a00592b41c48@google.com>
 <CAM_iQpX0FAvhcZgKjRd=3Rbp8cbfYiUqkF2KnmF9Pd0U4EkSDw@mail.gmail.com>
In-Reply-To: <CAM_iQpX0FAvhcZgKjRd=3Rbp8cbfYiUqkF2KnmF9Pd0U4EkSDw@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: syzbot <syzbot+ac54455281db908c581e@syzkaller.appspotmail.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, David Miller <davem@davemloft.net>, David Ahern <dsahern@gmail.com>, Florian Fainelli <f.fainelli@gmail.com>, "hawk@kernel.org" <hawk@kernel.org>, Ido Schimmel <idosch@mellanox.com>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@mellanox.com>, Jiri Pirko <jiri@resnulli.us>, John Fastabend <john.fastabend@gmail.com>, Martin KaFai Lau <kafai@fb.com>, LKML <linux-kernel@vger.kernel.org>, Linux Kernel Network Developers <netdev@vger.kernel.org>, Nikolay Aleksandrov <nikolay@cumulusnetworks.com>, Petr Machata <petrm@mellanox.com>, Roopa Prabhu <roopa@cumulusnetworks.com>, Song Liu <songliubraving@fb.com>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, Vlad Buslov <vladbu@mellanox.com>, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, "yhs@fb.com" <yhs@fb.com>


On Tue 17 Sep 2019 at 04:58, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> On Mon, Sep 16, 2019 at 4:39 PM syzbot
> <syzbot+ac54455281db908c581e@syzkaller.appspotmail.com> wrote:
>>
>> Hello,
>>
>> syzbot found the following crash on:
>>
>> HEAD commit:    1609d760 Merge tag 'for-linus' of git://git.kernel.org/p=
ub..
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=3D10236abe6000=
00
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=3Ded2b148cd673=
82ec
>> dashboard link: https://syzkaller.appspot.com/bug?extid=3Dac54455281db90=
8c581e
>> compiler:       clang version 9.0.0 (/home/glider/llvm/clang
>> 80fee25776c2fb61e74c1ecb1a523375c2500b69)
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D116c4b1160=
0000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D15ff270d6000=
00
>>
>> The bug was bisected to:
>>
>> commit c266f64dbfa2a970a13b0574246c0ddfec492365
>> Author: Vlad Buslov <vladbu@mellanox.com>
>> Date:   Mon Feb 11 08:55:32 2019 +0000
>>
>>      net: sched: protect block state with mutex
>>
>> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=3D16e7ca656=
00000
>> final crash:    https://syzkaller.appspot.com/x/report.txt?x=3D15e7ca656=
00000
>> console output: https://syzkaller.appspot.com/x/log.txt?x=3D11e7ca656000=
00
>>
>> IMPORTANT: if you fix the bug, please add the following tag to the commi=
t:
>> Reported-by: syzbot+ac54455281db908c581e@syzkaller.appspotmail.com
>> Fixes: c266f64dbfa2 ("net: sched: protect block state with mutex")
>>
>> BUG: sleeping function called from invalid context at
>> kernel/locking/mutex.c:909
>> in_atomic(): 1, irqs_disabled(): 0, pid: 9297, name: syz-executor942
>> INFO: lockdep is turned off.
>> Preemption disabled at:
>> [<ffffffff8604de24>] spin_lock_bh include/linux/spinlock.h:343 [inline]
>> [<ffffffff8604de24>] sch_tree_lock include/net/sch_generic.h:570 [inline=
]
>> [<ffffffff8604de24>] sfb_change+0x284/0xd30 net/sched/sch_sfb.c:519
>> CPU: 0 PID: 9297 Comm: syz-executor942 Not tainted 5.3.0-rc8+ #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
>> Google 01/01/2011
>> Call Trace:
>>   __dump_stack lib/dump_stack.c:77 [inline]
>>   dump_stack+0x1d8/0x2f8 lib/dump_stack.c:113
>>   ___might_sleep+0x3ff/0x530 kernel/sched/core.c:6608
>>   __might_sleep+0x8f/0x100 kernel/sched/core.c:6561
>>   __mutex_lock_common+0x4e/0x2820 kernel/locking/mutex.c:909
>>   __mutex_lock kernel/locking/mutex.c:1077 [inline]
>>   mutex_lock_nested+0x1b/0x30 kernel/locking/mutex.c:1092
>>   tcf_chain0_head_change_cb_del+0x30/0x390 net/sched/cls_api.c:932
>>   tcf_block_put_ext+0x3d/0x2a0 net/sched/cls_api.c:1502
>>   tcf_block_put+0x6e/0x90 net/sched/cls_api.c:1515
>>   sfb_destroy+0x47/0x70 net/sched/sch_sfb.c:467
>>   qdisc_destroy+0x147/0x4d0 net/sched/sch_generic.c:968
>>   qdisc_put+0x58/0x90 net/sched/sch_generic.c:992
>>   sfb_change+0x52d/0xd30 net/sched/sch_sfb.c:522
>
> I don't think we have to hold the qdisc tree lock when destroying
> the old qdisc. Does the following change make sense?
>
> diff --git a/net/sched/sch_sfb.c b/net/sched/sch_sfb.c
> index 1dff8506a715..726d0fa956b1 100644
> --- a/net/sched/sch_sfb.c
> +++ b/net/sched/sch_sfb.c
> @@ -488,7 +488,7 @@ static int sfb_change(struct Qdisc *sch, struct nlatt=
r *opt,
>                       struct netlink_ext_ack *extack)
>  {
>         struct sfb_sched_data *q =3D qdisc_priv(sch);
> -       struct Qdisc *child;
> +       struct Qdisc *child, *tmp;
>         struct nlattr *tb[TCA_SFB_MAX + 1];
>         const struct tc_sfb_qopt *ctl =3D &sfb_default_ops;
>         u32 limit;
> @@ -519,7 +519,7 @@ static int sfb_change(struct Qdisc *sch, struct nlatt=
r *opt,
>         sch_tree_lock(sch);
>
>         qdisc_tree_flush_backlog(q->qdisc);
> -       qdisc_put(q->qdisc);
> +       tmp =3D q->qdisc;
>         q->qdisc =3D child;
>
>         q->rehash_interval =3D msecs_to_jiffies(ctl->rehash_interval);
> @@ -543,6 +543,7 @@ static int sfb_change(struct Qdisc *sch, struct nlatt=
r *opt,
>
>         sch_tree_unlock(sch);
>
> +       qdisc_put(tmp);
>         return 0;
>  }
>
>
> What do you think, Vlad?

Hi Cong,

Don't see why we would need qdisc tree lock while releasing the
reference to (or destroying) previous Qdisc. I've skimmed through other
scheds and it looks like sch_multiq, sch_htb and sch_tbf are also
affected. Do you want me to send patches?

Regards,
Vlad
