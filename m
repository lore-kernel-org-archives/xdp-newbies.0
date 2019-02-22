Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-it1-f200.google.com ([209.85.166.200]:36145 "EHLO
        mail-it1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727202AbfBVRAH (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 22 Feb 2019 12:00:07 -0500
Received: by mail-it1-f200.google.com with SMTP id i4so2356142itb.1
        for <xdp-newbies@vger.kernel.org>; Fri, 22 Feb 2019 09:00:05 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 22 Feb 2019 09:00:05 -0800
Message-ID: <000000000000c07a5805827e85d5@google.com>
Subject: INFO: task hung in rtnetlink_rcv_msg
From: syzbot <syzbot+8218a8a0ff60c19b8eae@syzkaller.appspotmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: ast@kernel.org, christian@brauner.io, daniel@iogearbox.net, davem@davemloft.net, dsahern@gmail.com, hawk@kernel.org, idosch@mellanox.com, jakub.kicinski@netronome.com, john.fastabend@gmail.com, kafai@fb.com, ktkhai@virtuozzo.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, petrm@mellanox.com, roopa@cumulusnetworks.com, songliubraving@fb.com, syzkaller-bugs@googlegroups.com, xdp-newbies@vger.kernel.org, yhs@fb.com

Hello,

syzbot found the following crash on:

HEAD commit:    64c0133eb88a Merge tag 'armsoc-fixes' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14976800c00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ee434566c893c7b1
dashboard link: https://syzkaller.appspot.com/bug?extid=8218a8a0ff60c19b8eae
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11c8a14cc00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1189db74c00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+8218a8a0ff60c19b8eae@syzkaller.appspotmail.com

INFO: task syz-executor725:8005 blocked for more than 140 seconds.
       Not tainted 5.0.0-rc6+ #75
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor725 D27984  8005   7591 0x00000004
Call Trace:
  context_switch kernel/sched/core.c:2844 [inline]
  __schedule+0x817/0x1cc0 kernel/sched/core.c:3485
  schedule+0x92/0x180 kernel/sched/core.c:3529
  schedule_preempt_disabled+0x13/0x20 kernel/sched/core.c:3587
  __mutex_lock_common kernel/locking/mutex.c:1002 [inline]
  __mutex_lock+0x726/0x1310 kernel/locking/mutex.c:1072
  mutex_lock_nested+0x16/0x20 kernel/locking/mutex.c:1087
  rtnl_lock net/core/rtnetlink.c:77 [inline]
  rtnetlink_rcv_msg+0x40a/0xb00 net/core/rtnetlink.c:5127
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
RIP: 0033:0x4459f9
Code: ff 11 7a fd ff 11 7a fd ff 11 7a fd ff 11 7a fd ff 11 7a fd ff 11 7a  
fd ff 11 7a fd ff 11 7a fd ff 11 7a fd ff 11 7a fd ff 11 <7a> fd ff 11 7a  
fd ff 11 7a fd ff 11 7a fd ff 11 7a fd ff 11 7a fd
RSP: 002b:00007ffdc979ac28 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00000000004459f9
RDX: 00000000000000c4 RSI: 0000000020000300 RDI: 0000000000000003
RBP: 00000000000ac037 R08: 00000000004002c8 R09: 00000000004002c8
R10: 00000000200015a6 R11: 0000000000000246 R12: 0000000000406890
R13: 0000000000406920 R14: 0000000000000000 R15: 0000000000000000
INFO: task syz-executor725:8008 blocked for more than 140 seconds.
       Not tainted 5.0.0-rc6+ #75
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor725 D27552  8008   7590 0x00000004
Call Trace:
  context_switch kernel/sched/core.c:2844 [inline]
  __schedule+0x817/0x1cc0 kernel/sched/core.c:3485
  schedule+0x92/0x180 kernel/sched/core.c:3529
  schedule_preempt_disabled+0x13/0x20 kernel/sched/core.c:3587
  __mutex_lock_common kernel/locking/mutex.c:1002 [inline]
  __mutex_lock+0x726/0x1310 kernel/locking/mutex.c:1072
  mutex_lock_nested+0x16/0x20 kernel/locking/mutex.c:1087
  rtnl_lock net/core/rtnetlink.c:77 [inline]
  rtnetlink_rcv_msg+0x40a/0xb00 net/core/rtnetlink.c:5127
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
RIP: 0033:0x4459f9
Code: ff 11 7a fd ff 11 7a fd ff 11 7a fd ff 11 7a fd ff 11 7a fd ff 11 7a  
fd ff 11 7a fd ff 11 7a fd ff 11 7a fd ff 11 7a fd ff 11 <7a> fd ff 11 7a  
fd ff 11 7a fd ff 11 7a fd ff 11 7a fd ff 11 7a fd
RSP: 002b:00007ffdc979ac28 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00000000004459f9
RDX: 00000000000000c4 RSI: 0000000020000300 RDI: 0000000000000003
RBP: 00000000000ac03d R08: 00000000004002c8 R09: 00000000004002c8
R10: 00000000200015a6 R11: 0000000000000246 R12: 0000000000406890
R13: 0000000000406920 R14: 0000000000000000 R15: 0000000000000000
INFO: task syz-executor725:8009 blocked for more than 140 seconds.
       Not tainted 5.0.0-rc6+ #75
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor725 D28008  8009   7595 0x00000004
Call Trace:
  context_switch kernel/sched/core.c:2844 [inline]
  __schedule+0x817/0x1cc0 kernel/sched/core.c:3485
  schedule+0x92/0x180 kernel/sched/core.c:3529
  schedule_preempt_disabled+0x13/0x20 kernel/sched/core.c:3587
  __mutex_lock_common kernel/locking/mutex.c:1002 [inline]
  __mutex_lock+0x726/0x1310 kernel/locking/mutex.c:1072
  mutex_lock_nested+0x16/0x20 kernel/locking/mutex.c:1087
  rtnl_lock net/core/rtnetlink.c:77 [inline]
  rtnetlink_rcv_msg+0x40a/0xb00 net/core/rtnetlink.c:5127
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
RIP: 0033:0x4459f9
Code: ff 11 7a fd ff 11 7a fd ff 11 7a fd ff 11 7a fd ff 11 7a fd ff 11 7a  
fd ff 11 7a fd ff 11 7a fd ff 11 7a fd ff 11 7a fd ff 11 <7a> fd ff 11 7a  
fd ff 11 7a fd ff 11 7a fd ff 11 7a fd ff 11 7a fd
RSP: 002b:00007ffdc979ac28 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00000000004459f9
RDX: 00000000000000c4 RSI: 0000000020000300 RDI: 0000000000000003
RBP: 00000000000ac03d R08: 00000000004002c8 R09: 00000000004002c8
R10: 00000000200015a6 R11: 0000000000000246 R12: 0000000000406890
R13: 0000000000406920 R14: 0000000000000000 R15: 0000000000000000
INFO: task syz-executor725:8010 blocked for more than 140 seconds.
       Not tainted 5.0.0-rc6+ #75
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor725 D28000  8010   7596 0x00000004
Call Trace:
  context_switch kernel/sched/core.c:2844 [inline]
  __schedule+0x817/0x1cc0 kernel/sched/core.c:3485
  schedule+0x92/0x180 kernel/sched/core.c:3529
  schedule_preempt_disabled+0x13/0x20 kernel/sched/core.c:3587
  __mutex_lock_common kernel/locking/mutex.c:1002 [inline]
  __mutex_lock+0x726/0x1310 kernel/locking/mutex.c:1072
  mutex_lock_nested+0x16/0x20 kernel/locking/mutex.c:1087
  rtnl_lock net/core/rtnetlink.c:77 [inline]
  rtnetlink_rcv_msg+0x40a/0xb00 net/core/rtnetlink.c:5127
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
RIP: 0033:0x4459f9
Code: ff 11 7a fd ff 11 7a fd ff 11 7a fd ff 11 7a fd ff 11 7a fd ff 11 7a  
fd ff 11 7a fd ff 11 7a fd ff 11 7a fd ff 11 7a fd ff 11 <7a> fd ff 11 7a  
fd ff 11 7a fd ff 11 7a fd ff 11 7a fd ff 11 7a fd
RSP: 002b:00007ffdc979ac28 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00000000004459f9
RDX: 00000000000000c4 RSI: 0000000020000300 RDI: 0000000000000003
RBP: 00000000000ac03e R08: 00000000004002c8 R09: 00000000004002c8
R10: 00000000200015a6 R11: 0000000000000246 R12: 0000000000406890
R13: 0000000000406920 R14: 0000000000000000 R15: 0000000000000000
INFO: task syz-executor725:8011 blocked for more than 140 seconds.
       Not tainted 5.0.0-rc6+ #75
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor725 D28008  8011   7594 0x00000004
Call Trace:
  context_switch kernel/sched/core.c:2844 [inline]
  __schedule+0x817/0x1cc0 kernel/sched/core.c:3485
  schedule+0x92/0x180 kernel/sched/core.c:3529
  schedule_preempt_disabled+0x13/0x20 kernel/sched/core.c:3587
  __mutex_lock_common kernel/locking/mutex.c:1002 [inline]
  __mutex_lock+0x726/0x1310 kernel/locking/mutex.c:1072
  mutex_lock_nested+0x16/0x20 kernel/locking/mutex.c:1087
  rtnl_lock net/core/rtnetlink.c:77 [inline]
  rtnetlink_rcv_msg+0x40a/0xb00 net/core/rtnetlink.c:5127
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
RIP: 0033:0x4459f9
Code: ff 11 7a fd ff 11 7a fd ff 11 7a fd ff 11 7a fd ff 11 7a fd ff 11 7a  
fd ff 11 7a fd ff 11 7a fd ff 11 7a fd ff 11 7a fd ff 11 <7a> fd ff 11 7a  
fd ff 11 7a fd ff 11 7a fd ff 11 7a fd ff 11 7a fd
RSP: 002b:00007ffdc979ac28 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00000000004459f9
RDX: 00000000000000c4 RSI: 0000000020000300 RDI: 0000000000000003
RBP: 00000000000ac03b R08: 00000000004002c8 R09: 00000000004002c8
R10: 00000000200015a6 R11: 0000000000000246 R12: 0000000000406890
R13: 0000000000406920 R14: 0000000000000000 R15: 0000000000000000

Showing all locks held in the system:
3 locks held by kworker/1:1/22:
  #0: 000000009b0b09b4 ((wq_completion)"%s"("ipv6_addrconf")){+.+.}, at:  
__write_once_size include/linux/compiler.h:220 [inline]
  #0: 000000009b0b09b4 ((wq_completion)"%s"("ipv6_addrconf")){+.+.}, at:  
arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
  #0: 000000009b0b09b4 ((wq_completion)"%s"("ipv6_addrconf")){+.+.}, at:  
atomic64_set include/asm-generic/atomic-instrumented.h:40 [inline]
  #0: 000000009b0b09b4 ((wq_completion)"%s"("ipv6_addrconf")){+.+.}, at:  
atomic_long_set include/asm-generic/atomic-long.h:59 [inline]
  #0: 000000009b0b09b4 ((wq_completion)"%s"("ipv6_addrconf")){+.+.}, at:  
set_work_data kernel/workqueue.c:617 [inline]
  #0: 000000009b0b09b4 ((wq_completion)"%s"("ipv6_addrconf")){+.+.}, at:  
set_work_pool_and_clear_pending kernel/workqueue.c:644 [inline]
  #0: 000000009b0b09b4 ((wq_completion)"%s"("ipv6_addrconf")){+.+.}, at:  
process_one_work+0x87e/0x1790 kernel/workqueue.c:2144
  #1: 00000000e8391065 ((addr_chk_work).work){+.+.}, at:  
process_one_work+0x8b4/0x1790 kernel/workqueue.c:2148
  #2: 00000000da1e0257 (rtnl_mutex){+.+.}, at: rtnl_lock+0x17/0x20  
net/core/rtnetlink.c:77
1 lock held by khungtaskd/1040:
  #0: 00000000083344d4 (rcu_read_lock){....}, at:  
debug_show_all_locks+0x5f/0x27e kernel/locking/lockdep.c:4389
1 lock held by rsyslogd/7472:
  #0: 000000007562dcc1 (&f->f_pos_lock){+.+.}, at: __fdget_pos+0xee/0x110  
fs/file.c:795
2 locks held by getty/7562:
  #0: 000000000837ceb2 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:341
  #1: 00000000d91e6e17 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x232/0x1b70 drivers/tty/n_tty.c:2154
2 locks held by getty/7563:
  #0: 00000000243db696 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:341
  #1: 000000000002034d (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x232/0x1b70 drivers/tty/n_tty.c:2154
2 locks held by getty/7564:
  #0: 00000000a59e483b (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:341
  #1: 000000004032d53a (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x232/0x1b70 drivers/tty/n_tty.c:2154
2 locks held by getty/7565:
  #0: 0000000025343c97 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:341
  #1: 00000000727bf19a (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x232/0x1b70 drivers/tty/n_tty.c:2154
2 locks held by getty/7566:
  #0: 000000003dac20af (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:341
  #1: 00000000fef38c44 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x232/0x1b70 drivers/tty/n_tty.c:2154
2 locks held by getty/7567:
  #0: 00000000da1bfc9c (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:341
  #1: 00000000f82cf636 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x232/0x1b70 drivers/tty/n_tty.c:2154
2 locks held by getty/7568:
  #0: 00000000a5d9fcdf (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:341
  #1: 000000005ae165cb (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x232/0x1b70 drivers/tty/n_tty.c:2154
1 lock held by syz-executor725/8002:
1 lock held by syz-executor725/8005:
  #0: 00000000da1e0257 (rtnl_mutex){+.+.}, at: rtnl_lock  
net/core/rtnetlink.c:77 [inline]
  #0: 00000000da1e0257 (rtnl_mutex){+.+.}, at: rtnetlink_rcv_msg+0x40a/0xb00  
net/core/rtnetlink.c:5127
1 lock held by syz-executor725/8008:
  #0: 00000000da1e0257 (rtnl_mutex){+.+.}, at: rtnl_lock  
net/core/rtnetlink.c:77 [inline]
  #0: 00000000da1e0257 (rtnl_mutex){+.+.}, at: rtnetlink_rcv_msg+0x40a/0xb00  
net/core/rtnetlink.c:5127
1 lock held by syz-executor725/8009:
  #0: 00000000da1e0257 (rtnl_mutex){+.+.}, at: rtnl_lock  
net/core/rtnetlink.c:77 [inline]
  #0: 00000000da1e0257 (rtnl_mutex){+.+.}, at: rtnetlink_rcv_msg+0x40a/0xb00  
net/core/rtnetlink.c:5127
1 lock held by syz-executor725/8010:
  #0: 00000000da1e0257 (rtnl_mutex){+.+.}, at: rtnl_lock  
net/core/rtnetlink.c:77 [inline]
  #0: 00000000da1e0257 (rtnl_mutex){+.+.}, at: rtnetlink_rcv_msg+0x40a/0xb00  
net/core/rtnetlink.c:5127
1 lock held by syz-executor725/8011:
  #0: 00000000da1e0257 (rtnl_mutex){+.+.}, at: rtnl_lock  
net/core/rtnetlink.c:77 [inline]
  #0: 00000000da1e0257 (rtnl_mutex){+.+.}, at: rtnetlink_rcv_msg+0x40a/0xb00  
net/core/rtnetlink.c:5127

=============================================

NMI backtrace for cpu 0
CPU: 0 PID: 1040 Comm: khungtaskd Not tainted 5.0.0-rc6+ #75
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
Sending NMI from CPU 0 to CPUs 1:
INFO: NMI handler (nmi_cpu_backtrace_handler) took too long to run: 1.415  
msecs
NMI backtrace for cpu 1
CPU: 1 PID: 8002 Comm: syz-executor725 Not tainted 5.0.0-rc6+ #75
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:unwind_next_frame.part.0+0x1a8/0x9a0  
arch/x86/kernel/unwind_frame.c:329
Code: 8b 6d 20 4c 89 ee 48 89 df 4c 89 95 60 ff ff ff 4c 89 9d 68 ff ff ff  
4c 89 8d 70 ff ff ff e8 6f f7 ff ff 4c 8b 8d 70 ff ff ff <41> 89 c0 4c 8b  
9d 68 ff ff ff b8 01 00 00 00 45 84 c0 4c 8b 95 60
RSP: 0018:ffff888096136e28 EFLAGS: 00000286
RAX: 0000000000000001 RBX: ffff888096136f00 RCX: 1ffff11012c26de8
RDX: dffffc0000000000 RSI: 1ffff11012c26d00 RDI: ffff888096136f48
RBP: ffff888096136ed8 R08: 0000000000000001 R09: ffff888096136f50
R10: ffff888096136f28 R11: ffff888096136f38 R12: 1ffff11012c26dca
R13: ffff888096137b70 R14: ffff888096137b40 R15: ffff888096137f58
FS:  00000000024b2880(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffff600400 CR3: 000000009810b000 CR4: 00000000001406e0
Call Trace:
  unwind_next_frame+0x3b/0x50 arch/x86/kernel/unwind_frame.c:287
  __save_stack_trace+0x7a/0xf0 arch/x86/kernel/stacktrace.c:44
  save_stack_trace+0x1a/0x20 arch/x86/kernel/stacktrace.c:60
  save_stack+0x45/0xd0 mm/kasan/common.c:73
  set_track mm/kasan/common.c:85 [inline]
  __kasan_kmalloc mm/kasan/common.c:496 [inline]
  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:469
  kasan_kmalloc+0x9/0x10 mm/kasan/common.c:504
  __do_kmalloc_node mm/slab.c:3673 [inline]
  __kmalloc_node_track_caller+0x4e/0x70 mm/slab.c:3687
  __kmalloc_reserve.isra.0+0x40/0xf0 net/core/skbuff.c:140
  pskb_expand_head+0x14e/0xdd0 net/core/skbuff.c:1465
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
RIP: 0033:0x4459f9
Code: e8 ac e8 ff ff 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 0b 0a fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffdc979ac28 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00000000004459f9
RDX: 00000000000000c4 RSI: 0000000020000300 RDI: 0000000000000003
RBP: 00000000000ac031 R08: 00000000004002c8 R09: 00000000004002c8
R10: 00000000200015a6 R11: 0000000000000246 R12: 0000000000406890
R13: 0000000000406920 R14: 0000000000000000 R15: 0000000000000000


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with  
syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
