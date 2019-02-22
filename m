Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qt1-f193.google.com ([209.85.160.193]:36907 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726086AbfBVUBi (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 22 Feb 2019 15:01:38 -0500
Received: by mail-qt1-f193.google.com with SMTP id a48so3942266qtb.4
        for <xdp-newbies@vger.kernel.org>; Fri, 22 Feb 2019 12:01:37 -0800 (PST)
Date: Fri, 22 Feb 2019 12:01:29 -0800
From: Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: Re: INFO: task hung in rtnetlink_rcv_msg
Message-ID: <20190222120129.1f2f1c17@cakuba.netronome.com>
In-Reply-To: <000000000000c07a5805827e85d5@google.com>
References: <000000000000c07a5805827e85d5@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Joe Perches <joe@perches.com>
Cc: syzbot <syzbot+8218a8a0ff60c19b8eae@syzkaller.appspotmail.com>, ast@kernel.org, christian@brauner.io, daniel@iogearbox.net, davem@davemloft.net, dsahern@gmail.com, hawk@kernel.org, idosch@mellanox.com, john.fastabend@gmail.com, kafai@fb.com, ktkhai@virtuozzo.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, petrm@mellanox.com, roopa@cumulusnetworks.com, songliubraving@fb.com, syzkaller-bugs@googlegroups.com, xdp-newbies@vger.kernel.org, yhs@fb.com

Hi!

Seems like something funny is going on with get_maintainer.pl since XDP
entry got added.  We seem to have been CCed on:

net: ns83820: code cleanup for ns83820_probe_phy()
veth: Fix -Wformat-truncation
INFO: task hung in rtnetlink_rcv_msg

I tried Florian's veth patch myself and it does indeed produce:

"David S. Miller" <davem@davemloft.net> (odd fixer:NETWORKING DRIVERS,commit_signer:9/15=60%)
Alexei Starovoitov <ast@kernel.org> (supporter:XDP (eXpress Data Path))
Daniel Borkmann <daniel@iogearbox.net> (supporter:XDP (eXpress Data Path),commit_signer:6/15=40%)
Jakub Kicinski <jakub.kicinski@netronome.com> (supporter:XDP (eXpress Data Path))
Jesper Dangaard Brouer <hawk@kernel.org> (supporter:XDP (eXpress Data Path))
John Fastabend <john.fastabend@gmail.com> (supporter:XDP (eXpress Data Path),commit_signer:2/15=13%)
Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp> (commit_signer:11/15=73%,authored:11/15=73%,added_lines:1027/1055=97%,removed_lines:180/195=92%)
David Ahern <dsahern@gmail.com> (commit_signer:2/15=13%,authored:1/15=7%)
Li RongQing <lirongqing@baidu.com> (authored:1/15=7%,removed_lines:14/195=7%)
Michael Walle <michael@walle.cc> (authored:1/15=7%)
"Gustavo A. R. Silva" <gustavo@embeddedor.com> (authored:1/15=7%)
netdev@vger.kernel.org (open list:NETWORKING DRIVERS)
linux-kernel@vger.kernel.org (open list)
xdp-newbies@vger.kernel.org (open list:XDP (eXpress Data Path))

Even though it only touches:

 drivers/net/veth.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

And XDP entry is:

XDP (eXpress Data Path)
M:	Alexei Starovoitov <ast@kernel.org>
M:	Daniel Borkmann <daniel@iogearbox.net>
M:	David S. Miller <davem@davemloft.net>
M:	Jakub Kicinski <jakub.kicinski@netronome.com>
M:	Jesper Dangaard Brouer <hawk@kernel.org>
M:	John Fastabend <john.fastabend@gmail.com>
L:	netdev@vger.kernel.org
L:	xdp-newbies@vger.kernel.org
S:	Supported
F:	net/core/xdp.c
F:	include/net/xdp.h
F:	kernel/bpf/devmap.c
F:	kernel/bpf/cpumap.c
F:	include/trace/events/xdp.h
K:	xdp
N:	xdp

So no relation to drivers at all... 
