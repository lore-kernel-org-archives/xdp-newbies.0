Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7453 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726054AbfBYIjp (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 25 Feb 2019 03:39:45 -0500
Date: Mon, 25 Feb 2019 09:39:33 +0100
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: INFO: task hung in rtnetlink_rcv_msg
Message-ID: <20190225093933.748ceab4@carbon>
In-Reply-To: <279c5bae-0b18-b03a-2858-4749e18afa26@iogearbox.net>
References: <000000000000c07a5805827e85d5@google.com>
        <20190222120129.1f2f1c17@cakuba.netronome.com>
        <e049375f676938b5ad64898ac928b27cd783dc2a.camel@perches.com>
        <20190222134511.13eb7a82@cakuba.netronome.com>
        <279c5bae-0b18-b03a-2858-4749e18afa26@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Kicinski <jakub.kicinski@netronome.com>, Joe Perches <joe@perches.com>, syzbot <syzbot+8218a8a0ff60c19b8eae@syzkaller.appspotmail.com>, ast@kernel.org, christian@brauner.io, davem@davemloft.net, dsahern@gmail.com, hawk@kernel.org, idosch@mellanox.com, john.fastabend@gmail.com, kafai@fb.com, ktkhai@virtuozzo.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, petrm@mellanox.com, roopa@cumulusnetworks.com, songliubraving@fb.com, syzkaller-bugs@googlegroups.com, xdp-newbies@vger.kernel.org, yhs@fb.com, brouer@redhat.com

On Sat, 23 Feb 2019 01:47:00 +0100
Daniel Borkmann <daniel@iogearbox.net> wrote:

> On 02/22/2019 10:45 PM, Jakub Kicinski wrote:
> > On Fri, 22 Feb 2019 12:14:57 -0800, Joe Perches wrote:  
> >> On Fri, 2019-02-22 at 12:01 -0800, Jakub Kicinski wrote:  
> >>> Hi!
> >>>
> >>> Seems like something funny is going on with get_maintainer.pl since XDP
> >>> entry got added.  We seem to have been CCed on:    
> >>
> >> I suggest removing the MAINTAINERS line with
> >>
> >> 	K:	xdp
> >>
> >> as xdp is a pretty generic file/patch content
> >> regex match for the K: type
> >>
> >> $ git grep --name-only xdp | wc -l
> >> 236

I'm unsure how K: works, but you grep definitely selects some wrong files.

I tried with "xdp_":
 git grep --name-only xdp_

That does catch all the driver that have XDP support, which is the
point of the exercise (to catch drivers).

It does contain a couple of false-positives:
  drivers/net/ethernet/neterion/vxge/vxge-traffic.c
  drivers/thunderbolt/tb_msgs.h
  drivers/thunderbolt/xdomain.c
  sound/soc/codecs/rt5670.c

Via the pattern '[^a-z]xdp_' I'm only left with the thunderbolt
false-positive, as it have a data struct's called tb_xdp_*.




> >> Rather more files than desired.
> >>
> >> The N: match is dubious too.
> >>
> >> It's generally better to have specific lists of
> >> maintained file patterns rather than using the
> >> K: and N: pattern matches.
> >>
> >> ---
> >>  MAINTAINERS | 1 -
> >>  1 file changed, 1 deletion(-)
> >>
> >> diff --git a/MAINTAINERS b/MAINTAINERS
> >> index d7ad97b235ec..aa703e2cb882 100644
> >> --- a/MAINTAINERS
> >> +++ b/MAINTAINERS
> >> @@ -16970,7 +16970,6 @@ F:	include/net/xdp.h
> >>  F:	kernel/bpf/devmap.c
> >>  F:	kernel/bpf/cpumap.c
> >>  F:	include/trace/events/xdp.h
> >> -K:	xdp
> >>  N:	xdp
> >>  
> >>  XDP SOCKETS (AF_XDP)  
> > 
> > Thanks for the explanation, at least now I know why it happens! :)
> > I'll leave it to Daniel to decide if we really need it removed, 
> > so far the false positives weren't overwhelming, just surprising.  
> 
> No strong opinion. I've seen this K+N pattern in a number of places
> in the maintainers file. I'm fine either way if it gets too noisy. :)



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
