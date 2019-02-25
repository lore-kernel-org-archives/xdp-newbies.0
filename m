Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from smtprelay0025.hostedemail.com ([216.40.44.25]:47251 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728028AbfBYQzr (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 25 Feb 2019 11:55:47 -0500
Message-ID: <57807dca3bf554d0a07356ba1e53fae4d58cfb51.camel@perches.com>
Subject: Re: INFO: task hung in rtnetlink_rcv_msg
From: Joe Perches <joe@perches.com>
Date: Mon, 25 Feb 2019 08:55:40 -0800
In-Reply-To: <20190225093933.748ceab4@carbon>
References: <000000000000c07a5805827e85d5@google.com>
         <20190222120129.1f2f1c17@cakuba.netronome.com>
         <e049375f676938b5ad64898ac928b27cd783dc2a.camel@perches.com>
         <20190222134511.13eb7a82@cakuba.netronome.com>
         <279c5bae-0b18-b03a-2858-4749e18afa26@iogearbox.net>
         <20190225093933.748ceab4@carbon>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jesper Dangaard Brouer <brouer@redhat.com>, Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Kicinski <jakub.kicinski@netronome.com>, syzbot <syzbot+8218a8a0ff60c19b8eae@syzkaller.appspotmail.com>, ast@kernel.org, christian@brauner.io, davem@davemloft.net, dsahern@gmail.com, hawk@kernel.org, idosch@mellanox.com, john.fastabend@gmail.com, kafai@fb.com, ktkhai@virtuozzo.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, petrm@mellanox.com, roopa@cumulusnetworks.com, songliubraving@fb.com, syzkaller-bugs@googlegroups.com, xdp-newbies@vger.kernel.org, yhs@fb.com

On Mon, 2019-02-25 at 09:39 +0100, Jesper Dangaard Brouer wrote:
> On Sat, 23 Feb 2019 01:47:00 +0100
> Daniel Borkmann <daniel@iogearbox.net> wrote:
> 
> > On 02/22/2019 10:45 PM, Jakub Kicinski wrote:
> > > On Fri, 22 Feb 2019 12:14:57 -0800, Joe Perches wrote:  
> > > > On Fri, 2019-02-22 at 12:01 -0800, Jakub Kicinski wrote:  
> > > > > Hi!
> > > > > 
> > > > > Seems like something funny is going on with get_maintainer.pl since XDP
> > > > > entry got added.  We seem to have been CCed on:    
> > > > 
> > > > I suggest removing the MAINTAINERS line with
> > > > 
> > > > 	K:	xdp
> > > > 
> > > > as xdp is a pretty generic file/patch content
> > > > regex match for the K: type
> > > > 
> > > > $ git grep --name-only xdp | wc -l
> > > > 236
> 
> I'm unsure how K: works, but you grep definitely selects some wrong files.
> 
> I tried with "xdp_":
>  git grep --name-only xdp_
> 
> That does catch all the driver that have XDP support, which is the
> point of the exercise (to catch drivers).
> 
> It does contain a couple of false-positives:
>   drivers/net/ethernet/neterion/vxge/vxge-traffic.c
>   drivers/thunderbolt/tb_msgs.h
>   drivers/thunderbolt/xdomain.c
>   sound/soc/codecs/rt5670.c
> 
> Via the pattern '[^a-z]xdp_' I'm only left with the thunderbolt
> false-positive, as it have a data struct's called tb_xdp_*.

Then it's probably better to use

K:	\Wxdp_

and if XDP_ is also to be matched, maybe

K:	(?i:\Wxdp_)
