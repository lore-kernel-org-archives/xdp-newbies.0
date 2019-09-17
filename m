Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37801 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728702AbfIQRDU (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 17 Sep 2019 13:03:20 -0400
MIME-Version: 1.0
References: <00000000000029a3a00592b41c48@google.com> <CAM_iQpX0FAvhcZgKjRd=3Rbp8cbfYiUqkF2KnmF9Pd0U4EkSDw@mail.gmail.com>
 <vbfk1a7cooq.fsf@mellanox.com>
In-Reply-To: <vbfk1a7cooq.fsf@mellanox.com>
From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Tue, 17 Sep 2019 10:03:08 -0700
Message-ID: <CAM_iQpWNSdx59iTTNO6GdyZ6NBAMD8=wON6Q7dvnhiX50pwEvQ@mail.gmail.com>
Subject: Re: BUG: sleeping function called from invalid context in tcf_chain0_head_change_cb_del
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Vlad Buslov <vladbu@mellanox.com>
Cc: syzbot <syzbot+ac54455281db908c581e@syzkaller.appspotmail.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, David Miller <davem@davemloft.net>, David Ahern <dsahern@gmail.com>, Florian Fainelli <f.fainelli@gmail.com>, "hawk@kernel.org" <hawk@kernel.org>, Ido Schimmel <idosch@mellanox.com>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@mellanox.com>, Jiri Pirko <jiri@resnulli.us>, John Fastabend <john.fastabend@gmail.com>, Martin KaFai Lau <kafai@fb.com>, LKML <linux-kernel@vger.kernel.org>, Linux Kernel Network Developers <netdev@vger.kernel.org>, Nikolay Aleksandrov <nikolay@cumulusnetworks.com>, Petr Machata <petrm@mellanox.com>, Roopa Prabhu <roopa@cumulusnetworks.com>, Song Liu <songliubraving@fb.com>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, "yhs@fb.com" <yhs@fb.com>

On Tue, Sep 17, 2019 at 1:27 AM Vlad Buslov <vladbu@mellanox.com> wrote:
> Hi Cong,
>
> Don't see why we would need qdisc tree lock while releasing the
> reference to (or destroying) previous Qdisc. I've skimmed through other
> scheds and it looks like sch_multiq, sch_htb and sch_tbf are also
> affected. Do you want me to send patches?

Yes, please do.
