Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-eopbgr50043.outbound.protection.outlook.com ([40.107.5.43]:14672
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726044AbfIQT5a (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 17 Sep 2019 15:57:30 -0400
From: Vlad Buslov <vladbu@mellanox.com>
Subject: Re: BUG: sleeping function called from invalid context in
 tcf_chain0_head_change_cb_del
Date: Tue, 17 Sep 2019 19:57:19 +0000
Message-ID: <vbf8sqmd7cn.fsf@mellanox.com>
References: <00000000000029a3a00592b41c48@google.com>
 <CAM_iQpX0FAvhcZgKjRd=3Rbp8cbfYiUqkF2KnmF9Pd0U4EkSDw@mail.gmail.com>
 <vbfk1a7cooq.fsf@mellanox.com>
 <CAM_iQpWNSdx59iTTNO6GdyZ6NBAMD8=wON6Q7dvnhiX50pwEvQ@mail.gmail.com>
In-Reply-To: <CAM_iQpWNSdx59iTTNO6GdyZ6NBAMD8=wON6Q7dvnhiX50pwEvQ@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Vlad Buslov <vladbu@mellanox.com>, syzbot <syzbot+ac54455281db908c581e@syzkaller.appspotmail.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, David Miller <davem@davemloft.net>, David Ahern <dsahern@gmail.com>, Florian Fainelli <f.fainelli@gmail.com>, "hawk@kernel.org" <hawk@kernel.org>, Ido Schimmel <idosch@mellanox.com>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@mellanox.com>, Jiri Pirko <jiri@resnulli.us>, John Fastabend <john.fastabend@gmail.com>, Martin KaFai Lau <kafai@fb.com>, LKML <linux-kernel@vger.kernel.org>, Linux Kernel Network Developers <netdev@vger.kernel.org>, Nikolay Aleksandrov <nikolay@cumulusnetworks.com>, Petr Machata <petrm@mellanox.com>, Roopa Prabhu <roopa@cumulusnetworks.com>, Song Liu <songliubraving@fb.com>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, "yhs@fb.com" <yhs@fb.com>


On Tue 17 Sep 2019 at 20:03, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> On Tue, Sep 17, 2019 at 1:27 AM Vlad Buslov <vladbu@mellanox.com> wrote:
>> Hi Cong,
>>
>> Don't see why we would need qdisc tree lock while releasing the
>> reference to (or destroying) previous Qdisc. I've skimmed through other
>> scheds and it looks like sch_multiq, sch_htb and sch_tbf are also
>> affected. Do you want me to send patches?
>
> Yes, please do.

It looks like tbf is not affected by the bug after all. Relevant part of
code from tbf_change():

	if (q->qdisc !=3D &noop_qdisc) {
		err =3D fifo_set_limit(q->qdisc, qopt->limit);
		if (err)
			goto done;
	} else if (qopt->limit > 0) {
		child =3D fifo_create_dflt(sch, &bfifo_qdisc_ops, qopt->limit,
					 extack);
		if (IS_ERR(child)) {
			err =3D PTR_ERR(child);
			goto done;
		}

		/* child is fifo, no need to check for noop_qdisc */
		qdisc_hash_add(child, true);
	}

	sch_tree_lock(sch);
	if (child) {
		qdisc_tree_flush_backlog(q->qdisc);
		qdisc_put(q->qdisc);
		q->qdisc =3D child;
	}

It seems that qdisc_put() is redundant here because it is only called
q->qdisc =3D=3D &noop_qdisc, which is a noop.
