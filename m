Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-it1-f197.google.com ([209.85.166.197]:60387 "EHLO
        mail-it1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726152AbfBPKUE (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Sat, 16 Feb 2019 05:20:04 -0500
Received: by mail-it1-f197.google.com with SMTP id m136so19121448ita.9
        for <xdp-newbies@vger.kernel.org>; Sat, 16 Feb 2019 02:20:04 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 16 Feb 2019 02:20:03 -0800
Message-ID: <0000000000001d37cd0582003c53@google.com>
Subject: INFO: task hung in addrconf_dad_work
From: syzbot <syzbot+f4290c15a8ab6dee87c9@syzkaller.appspotmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: ast@kernel.org, christian@brauner.io, daniel@iogearbox.net, davem@davemloft.net, dsahern@gmail.com, hawk@kernel.org, idosch@mellanox.com, jakub.kicinski@netronome.com, john.fastabend@gmail.com, kafai@fb.com, ktkhai@virtuozzo.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, petrm@mellanox.com, roopa@cumulusnetworks.com, songliubraving@fb.com, syzkaller-bugs@googlegroups.com, xdp-newbies@vger.kernel.org, yhs@fb.com

Hello,

syzbot found the following crash on:

HEAD commit:    5ded5871030e Merge tag 'scsi-fixes' of git://git.kernel.or..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1577228f400000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ee434566c893c7b1
dashboard link: https://syzkaller.appspot.com/bug?extid=f4290c15a8ab6dee87c9
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10ee52d4c00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1073879cc00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+f4290c15a8ab6dee87c9@syzkaller.appspotmail.com

INFO: task kworker/0:1:12 blocked for more than 140 seconds.
       Not tainted 5.0.0-rc6+ #73
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kworker/0:1     D26560    12      2 0x80000000
Workqueue: ipv6_addrconf addrconf_dad_work
Call Trace:
  context_switch kernel/sched/core.c:2844 [inline]
  __schedule+0x817/0x1cc0 kernel/sched/core.c:3485
  schedule+0x92/0x180 kernel/sched/core.c:3529
  schedule_preempt_disabled+0x13/0x20 kernel/sched/core.c:3587
  __mutex_lock_common kernel/locking/mutex.c:1002 [inline]
  __mutex_lock+0x726/0x1310 kernel/locking/mutex.c:1072
  mutex_lock_nested+0x16/0x20 kernel/locking/mutex.c:1087
  rtnl_lock+0x17/0x20 net/core/rtnetlink.c:77
  addrconf_dad_work+0xad/0x1150 net/ipv6/addrconf.c:3995
  process_one_work+0x98e/0x1790 kernel/workqueue.c:2173
  worker_thread+0x98/0xe40 kernel/workqueue.c:2319
  kthread+0x357/0x430 kernel/kthread.c:246
  ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:352
INFO: task kworker/1:1:22 blocked for more than 140 seconds.
       Not tainted 5.0.0-rc6+ #73
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kworker/1:1     D26848    22      2 0x80000000
Workqueue: ipv6_addrconf addrconf_dad_work
Call Trace:
  context_switch kernel/sched/core.c:2844 [inline]
  __schedule+0x817/0x1cc0 kernel/sched/core.c:3485
  schedule+0x92/0x180 kernel/sched/core.c:3529
  schedule_preempt_disabled+0x13/0x20 kernel/sched/core.c:3587
  __mutex_lock_common kernel/locking/mutex.c:1002 [inline]
  __mutex_lock+0x726/0x1310 kernel/locking/mutex.c:1072
  mutex_lock_nested+0x16/0x20 kernel/locking/mutex.c:1087
  rtnl_lock+0x17/0x20 net/core/rtnetlink.c:77
  addrconf_dad_work+0xad/0x1150 net/ipv6/addrconf.c:3995
  process_one_work+0x98e/0x1790 kernel/workqueue.c:2173
  worker_thread+0x98/0xe40 kernel/workqueue.c:2319
  kthread+0x357/0x430 kernel/kthread.c:246
  ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:352

Showing all locks held in the system:
3 locks held by kworker/0:1/12:
  #0: 00000000c092f744 ((wq_completion)"%s"("ipv6_addrconf")){+.+.}, at:  
__write_once_size include/linux/compiler.h:220 [inline]
  #0: 00000000c092f744 ((wq_completion)"%s"("ipv6_addrconf")){+.+.}, at:  
arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
  #0: 00000000c092f744 ((wq_completion)"%s"("ipv6_addrconf")){+.+.}, at:  
atomic64_set include/asm-generic/atomic-instrumented.h:40 [inline]
  #0: 00000000c092f744 ((wq_completion)"%s"("ipv6_addrconf")){+.+.}, at:  
atomic_long_set include/asm-generic/atomic-long.h:59 [inline]
  #0: 00000000c092f744 ((wq_completion)"%s"("ipv6_addrconf")){+.+.}, at:  
set_work_data kernel/workqueue.c:617 [inline]
  #0: 00000000c092f744 ((wq_completion)"%s"("ipv6_addrconf")){+.+.}, at:  
set_work_pool_and_clear_pending kernel/workqueue.c:644 [inline]
  #0: 00000000c092f744 ((wq_completion)"%s"("ipv6_addrconf")){+.+.}, at:  
process_one_work+0x87e/0x1790 kernel/workqueue.c:2144
  #1: 00000000ba501015 ((work_completion)(&(&ifa->dad_work)->work)){+.+.},  
at: process_one_work+0x8b4/0x1790 kernel/workqueue.c:2148
  #2: 000000000a023ce4 (rtnl_mutex){+.+.}, at: rtnl_lock+0x17/0x20  
net/core/rtnetlink.c:77
3 locks held by kworker/1:1/22:
  #0: 00000000c092f744 ((wq_completion)"%s"("ipv6_addrconf")){+.+.}, at:  
__write_once_size include/linux/compiler.h:220 [inline]
  #0: 00000000c092f744 ((wq_completion)"%s"("ipv6_addrconf")){+.+.}, at:  
arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
  #0: 00000000c092f744 ((wq_completion)"%s"("ipv6_addrconf")){+.+.}, at:  
atomic64_set include/asm-generic/atomic-instrumented.h:40 [inline]
  #0: 00000000c092f744 ((wq_completion)"%s"("ipv6_addrconf")){+.+.}, at:  
atomic_long_set include/asm-generic/atomic-long.h:59 [inline]
  #0: 00000000c092f744 ((wq_completion)"%s"("ipv6_addrconf")){+.+.}, at:  
set_work_data kernel/workqueue.c:617 [inline]
  #0: 00000000c092f744 ((wq_completion)"%s"("ipv6_addrconf")){+.+.}, at:  
set_work_pool_and_clear_pending kernel/workqueue.c:644 [inline]
  #0: 00000000c092f744 ((wq_completion)"%s"("ipv6_addrconf")){+.+.}, at:  
process_one_work+0x87e/0x1790 kernel/workqueue.c:2144
  #1: 00000000609e3f2e ((work_completion)(&(&ifa->dad_work)->work)){+.+.},  
at: process_one_work+0x8b4/0x1790 kernel/workqueue.c:2148
  #2: 000000000a023ce4 (rtnl_mutex){+.+.}, at: rtnl_lock+0x17/0x20  
net/core/rtnetlink.c:77
1 lock held by khungtaskd/1039:
  #0: 000000009a681c98 (rcu_read_lock){....}, at:  
debug_show_all_locks+0x5f/0x27e kernel/locking/lockdep.c:4389
1 lock held by rsyslogd/7932:
  #0: 000000000ae60368 (&f->f_pos_lock){+.+.}, at: __fdget_pos+0xee/0x110  
fs/file.c:795
2 locks held by getty/8054:
  #0: 00000000330eb6bd (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:341
  #1: 00000000115a4ff9 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x232/0x1b70 drivers/tty/n_tty.c:2154
2 locks held by getty/8055:
  #0: 000000001f90753f (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:341
  #1: 000000001e27037e (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x232/0x1b70 drivers/tty/n_tty.c:2154
2 locks held by getty/8056:
  #0: 0000000027f8ba41 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:341
  #1: 00000000a0356b01 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x232/0x1b70 drivers/tty/n_tty.c:2154
2 locks held by getty/8057:
  #0: 000000009cf2ea94 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:341
  #1: 0000000097e38bce (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x232/0x1b70 drivers/tty/n_tty.c:2154
2 locks held by getty/8058:
  #0: 000000006dd48e75 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:341
  #1: 00000000a75b841a (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x232/0x1b70 drivers/tty/n_tty.c:2154
2 locks held by getty/8059:
  #0: 0000000020112132 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:341
  #1: 00000000c3504044 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x232/0x1b70 drivers/tty/n_tty.c:2154
2 locks held by getty/8060:
  #0: 000000001510234f (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:341
  #1: 00000000e70220db (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x232/0x1b70 drivers/tty/n_tty.c:2154
1 lock held by syz-executor112/8443:

=============================================

NMI backtrace for cpu 1
CPU: 1 PID: 1039 Comm: khungtaskd Not tainted 5.0.0-rc6+ #73
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  nmi_cpu_backtrace.cold+0x63/0xa4 lib/nmi_backtrace.c:101
  nmi_trigger_cpumask_backtrace+0x1be/0x236 lib/nmi_backtrace.c:62
  arch_trigger_cpumask_backtrace+0x14/0x20 arch/x86/kernel/apic/hw_nmi.c:38
  trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
  check_hung_uninterruptible_tasks kernel/hung_task.c:203 [inline]
  watchdog+0x9df/0xee0 kernel/hung_task.c:287
  kthread+0x357/0x430 kernel/kthread.c:246
  ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:352
Sending NMI from CPU 1 to CPUs 0:
INFO: NMI handler (nmi_cpu_backtrace_handler) took too long to run: 1.262  
msecs
NMI backtrace for cpu 0
CPU: 0 PID: 8443 Comm: syz-executor112 Not tainted 5.0.0-rc6+ #73
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:preempt_count_add+0xf8/0x1b0 kernel/sched/core.c:3210
Code: 11 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 80 3c 02  
00 0f 85 ab 00 00 00 49 89 9c 24 b0 11 00 00 5b 41 5c 5d <c3> 48 8b 45 00  
48 8b 58 08 48 89 df e8 27 e7 09 00 85 c0 74 b3 48
RSP: 0018:ffff88809e13f190 EFLAGS: 00000046
RAX: dffffc0000000000 RBX: 0000000000000286 RCX: 0000000000000000
RDX: 1ffff1100f1efe66 RSI: 0000000000000000 RDI: ffff888078f7f330
RBP: ffff88809e13f1a8 R08: ffff888078f7e180 R09: ffffed1015d05bd0
R10: ffffed1015d05bcf R11: ffff8880ae82de7b R12: ffffffff8a648b08
R13: 0000000000000086 R14: ffffffff8a648b08 R15: 00000000004012c0
FS:  00000000019f3940(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffff600400 CR3: 00000000a1211000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  __debug_check_no_obj_freed lib/debugobjects.c:776 [inline]
  debug_check_no_obj_freed+0xbe/0x464 lib/debugobjects.c:817
  kfree+0xbd/0x230 mm/slab.c:3805
  skb_free_head+0x93/0xb0 net/core/skbuff.c:553
  pskb_expand_head+0x2ba/0xdd0 net/core/skbuff.c:1498
  netlink_trim+0x215/0x270 net/netlink/af_netlink.c:1292
  netlink_unicast+0xbf/0x720 net/netlink/af_netlink.c:1326
  rtnetlink_send+0xf0/0x110 net/core/rtnetlink.c:721
  tcf_add_notify net/sched/act_api.c:1325 [inline]
  tcf_action_add+0x243/0x370 net/sched/act_api.c:1344
  tc_ctl_action+0x3b6/0x4bd net/sched/act_api.c:1392
  rtnetlink_rcv_msg+0x465/0xb00 net/core/rtnetlink.c:5130
  netlink_rcv_skb+0x17a/0x460 net/netlink/af_netlink.c:2477
  rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5148
  netlink_unicast_kernel net/netlink/af_netlink.c:1310 [inline]
  netlink_unicast+0x536/0x720 net/netlink/af_netlink.c:1336
  netlink_sendmsg+0x8ae/0xd70 net/netlink/af_netlink.c:1917
  sock_sendmsg_nosec net/socket.c:621 [inline]
  sock_sendmsg+0xdd/0x130 net/socket.c:631
  ___sys_sendmsg+0x806/0x930 net/socket.c:2114
  __sys_sendmsg+0x105/0x1d0 net/socket.c:2152
  __do_sys_sendmsg net/socket.c:2161 [inline]
  __se_sys_sendmsg net/socket.c:2159 [inline]
  __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2159
  do_syscall_64+0x103/0x610 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45b129
Code: e8 3c 0a 03 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 5b 07 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffc05c7adc8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 000000000045b129
RDX: 00000000000000c4 RSI: 0000000020000300 RDI: 0000000000000003
RBP: 0000000000000000 R08: 00000000000003e8 R09: 00000000000003e8
R10: 0000000000000004 R11: 0000000000000246 R12: 0000000000000162
R13: 000000000041bda0 R14: 0000000000000000 R15: 0000000000000000


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with  
syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
