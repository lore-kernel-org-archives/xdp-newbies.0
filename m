Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qt1-f194.google.com ([209.85.160.194]:41340 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726409AbfBVVpR (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 22 Feb 2019 16:45:17 -0500
Received: by mail-qt1-f194.google.com with SMTP id v10so4236683qtp.8
        for <xdp-newbies@vger.kernel.org>; Fri, 22 Feb 2019 13:45:16 -0800 (PST)
Date: Fri, 22 Feb 2019 13:45:11 -0800
From: Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: Re: INFO: task hung in rtnetlink_rcv_msg
Message-ID: <20190222134511.13eb7a82@cakuba.netronome.com>
In-Reply-To: <e049375f676938b5ad64898ac928b27cd783dc2a.camel@perches.com>
References: <000000000000c07a5805827e85d5@google.com>
        <20190222120129.1f2f1c17@cakuba.netronome.com>
        <e049375f676938b5ad64898ac928b27cd783dc2a.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Joe Perches <joe@perches.com>
Cc: syzbot <syzbot+8218a8a0ff60c19b8eae@syzkaller.appspotmail.com>, ast@kernel.org, christian@brauner.io, daniel@iogearbox.net, davem@davemloft.net, dsahern@gmail.com, hawk@kernel.org, idosch@mellanox.com, john.fastabend@gmail.com, kafai@fb.com, ktkhai@virtuozzo.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, petrm@mellanox.com, roopa@cumulusnetworks.com, songliubraving@fb.com, syzkaller-bugs@googlegroups.com, xdp-newbies@vger.kernel.org, yhs@fb.com

On Fri, 22 Feb 2019 12:14:57 -0800, Joe Perches wrote:
> On Fri, 2019-02-22 at 12:01 -0800, Jakub Kicinski wrote:
> > Hi!
> > 
> > Seems like something funny is going on with get_maintainer.pl since XDP
> > entry got added.  We seem to have been CCed on:  
> 
> I suggest removing the MAINTAINERS line with
> 
> 	K:	xdp
> 
> as xdp is a pretty generic file/patch content
> regex match for the K: type
> 
> $ git grep --name-only xdp | wc -l
> 236
> 
> Rather more files than desired.
> 
> The N: match is dubious too.
> 
> It's generally better to have specific lists of
> maintained file patterns rather than using the
> K: and N: pattern matches.
> 
> ---
>  MAINTAINERS | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index d7ad97b235ec..aa703e2cb882 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16970,7 +16970,6 @@ F:	include/net/xdp.h
>  F:	kernel/bpf/devmap.c
>  F:	kernel/bpf/cpumap.c
>  F:	include/trace/events/xdp.h
> -K:	xdp
>  N:	xdp
>  
>  XDP SOCKETS (AF_XDP)

Thanks for the explanation, at least now I know why it happens! :)
I'll leave it to Daniel to decide if we really need it removed, 
so far the false positives weren't overwhelming, just surprising.
