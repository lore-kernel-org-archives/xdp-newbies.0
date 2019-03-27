Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-it1-f199.google.com ([209.85.166.199]:41885 "EHLO
        mail-it1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391934AbfC0SbI (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 27 Mar 2019 14:31:08 -0400
Received: by mail-it1-f199.google.com with SMTP id q184so818418itd.6
        for <xdp-newbies@vger.kernel.org>; Wed, 27 Mar 2019 11:31:07 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 27 Mar 2019 11:31:06 -0700
Message-ID: <00000000000012a28e058517a481@google.com>
Subject: INFO: rcu detected stall in sys_bpf
From: syzbot <syzbot+c70685d9eac9589eaffc@syzkaller.appspotmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org, jakub.kicinski@netronome.com, john.fastabend@gmail.com, kafai@fb.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, songliubraving@fb.com, syzkaller-bugs@googlegroups.com, xdp-newbies@vger.kernel.org, yhs@fb.com

Hello,

syzbot found the following crash on:

HEAD commit:    ab8bba4e Add linux-next specific files for 20190326
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=147da22f200000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8b5e4ab01fbe59f3
dashboard link: https://syzkaller.appspot.com/bug?extid=c70685d9eac9589eaffc
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+c70685d9eac9589eaffc@syzkaller.appspotmail.com

protocol 88fb is buggy, dev hsr_slave_0
protocol 88fb is buggy, dev hsr_slave_1
rcu: INFO: rcu_preempt self-detected stall on CPU
rcu: 	1-...!: (10499 ticks this GP) idle=4d6/1/0x4000000000000002  
softirq=15531/15535 fqs=1
rcu: 	 (t=10500 jiffies g=12661 q=236)
rcu: rcu_preempt kthread starved for 10498 jiffies! g12661 f0x0  
RCU_GP_WAIT_FQS(5) ->state=0x0 ->cpu=0
rcu: RCU grace-period kthread stack dump:
rcu_preempt     R  running task    29176    10      2 0x80000000
Call Trace:
  context_switch kernel/sched/core.c:2877 [inline]
  __schedule+0x817/0x1cc0 kernel/sched/core.c:3518
  schedule+0x92/0x180 kernel/sched/core.c:3562
  schedule_timeout+0x486/0xc50 kernel/time/timer.c:1807
  rcu_gp_fqs_loop kernel/rcu/tree.c:1971 [inline]
  rcu_gp_kthread+0x962/0x17b0 kernel/rcu/tree.c:2128
  kthread+0x357/0x430 kernel/kthread.c:253
  ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:352
NMI backtrace for cpu 1
CPU: 1 PID: 10138 Comm: syz-executor.4 Not tainted 5.1.0-rc2-next-20190326  
#11
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  <IRQ>
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  nmi_cpu_backtrace.cold+0x63/0xa4 lib/nmi_backtrace.c:101
  nmi_trigger_cpumask_backtrace+0x1be/0x236 lib/nmi_backtrace.c:62
  arch_trigger_cpumask_backtrace+0x14/0x20 arch/x86/kernel/apic/hw_nmi.c:38
  trigger_single_cpu_backtrace include/linux/nmi.h:164 [inline]
  rcu_dump_cpu_stacks+0x183/0x1cf kernel/rcu/tree.c:1223
  print_cpu_stall kernel/rcu/tree.c:1360 [inline]
  check_cpu_stall kernel/rcu/tree.c:1434 [inline]
  rcu_pending kernel/rcu/tree.c:3103 [inline]
  rcu_sched_clock_irq.cold+0x500/0xa4a kernel/rcu/tree.c:2544
  update_process_times+0x32/0x80 kernel/time/timer.c:1639
  tick_sched_handle+0xa2/0x190 kernel/time/tick-sched.c:161
  tick_sched_timer+0x47/0x130 kernel/time/tick-sched.c:1272
  __run_hrtimer kernel/time/hrtimer.c:1389 [inline]
  __hrtimer_run_queues+0x33e/0xde0 kernel/time/hrtimer.c:1451
  hrtimer_interrupt+0x314/0x770 kernel/time/hrtimer.c:1509
  local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1035 [inline]
  smp_apic_timer_interrupt+0x120/0x570 arch/x86/kernel/apic/apic.c:1060
  apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:807
  </IRQ>
RIP: 0010:bpf_prog_d4faa897062613d4+0x534/0x1000
Code: cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc  
cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc 55 <48> 89 e5 48 81  
ec 28 00 00 00 48 83 ed 28 48 89 5d 00 4c 89 6d 08
RSP: 0018:ffff88804e95fac0 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
RAX: ffffffffa0008533 RBX: ffff88804e95fba8 RCX: ffffc9000e663000
RDX: 0000000000040000 RSI: ffffc90001965038 RDI: ffff88804e95fc68
RBP: ffff88804e95fbd0 R08: ffff888096eda6c0 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: dffffc0000000000
R13: 00000000ffffffff R14: ffffc90001965000 R15: 0000000003d7c302
  bpf_prog_test_run_xdp+0x24f/0x4c0 net/bpf/test_run.c:235
  bpf_prog_test_run kernel/bpf/syscall.c:1969 [inline]
  __do_sys_bpf+0x15c2/0x3e50 kernel/bpf/syscall.c:2728
  __se_sys_bpf kernel/bpf/syscall.c:2672 [inline]
  __x64_sys_bpf+0x73/0xb0 kernel/bpf/syscall.c:2672
  do_syscall_64+0x103/0x610 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x458209
Code: ad b8 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 7b b8 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f74d2a2dc78 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000458209
RDX: 0000000000000028 RSI: 0000000020000240 RDI: 000000000000000a
RBP: 000000000073bf00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f74d2a2e6d4
R13: 00000000004be3c5 R14: 00000000004cea20 R15: 00000000ffffffff
net_ratelimit: 2 callbacks suppressed
protocol 88fb is buggy, dev hsr_slave_0
protocol 88fb is buggy, dev hsr_slave_1
protocol 88fb is buggy, dev hsr_slave_0
protocol 88fb is buggy, dev hsr_slave_1
protocol 88fb is buggy, dev hsr_slave_0
protocol 88fb is buggy, dev hsr_slave_1


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
