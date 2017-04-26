Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37512 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1437730AbdDZPIZ (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 26 Apr 2017 11:08:25 -0400
Date: Wed, 26 Apr 2017 16:59:33 +0200
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [PATCH] Enable Netdev XDP tutorial for Ubuntu 17.04
Message-ID: <20170426165933.2aea7705@redhat.com>
In-Reply-To: <20170425103537.1114aece@redhat.com>
References: <20602.1491881713@famine>
        <1491997888.2855.1.camel@sipsolutions.net>
        <5170.1492808322@famine>
        <20170425103537.1114aece@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jay Vosburgh <jay.vosburgh@canonical.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, xdp-newbies@vger.kernel.org, Andy Gospodarek <andy@greyhouse.net>, brouer@redhat.com

Hi Jay,

On Tue, 25 Apr 2017 10:35:37 +0200
Jesper Dangaard Brouer <brouer@redhat.com> wrote:

> > 	Getting back to this after a couple of weeks...
> > 
> > 	The above changes didn't make any difference for me, but it
> > turns out all of the various Makefile hacks I did previously aren't
> > needed for Ubuntu 17.04, the following lets the examples build and run
> > fine:
> > 
> > diff --git a/kernel/samples/bpf/xdp_ddos01_blacklist_cmdline.c b/kernel/samples/bpf/xdp_ddos01_blacklist_cmdline.c
> > index 11157f9..5cf297e 100644
> > --- a/kernel/samples/bpf/xdp_ddos01_blacklist_cmdline.c
> > +++ b/kernel/samples/bpf/xdp_ddos01_blacklist_cmdline.c
> > @@ -13,7 +13,6 @@ static const char *__doc__=
> >  #include <string.h>
> >  #include <unistd.h>
> >  #include <locale.h>
> > -#include <linux/bitops.h>  
> 
> This include was added by Andy in commit 888606b5accb ("samples/bpf:
> xdp_ddos01 add support for port blacklisting").
> 
> To Andy, are you okay with this change/patch?

I've applied this and gave you author credit for the fix:
  https://github.com/netoptimizer/prototype-kernel/commit/7e879ecd6a96
 
> >  #include <sys/resource.h>
> >  #include <getopt.h>
> > @@ -212,7 +211,7 @@ static void blacklist_print_proto(int key, __u64 count)
> >  	printf("\n\t\"%s\" : %llu", xdp_proto_filter_names[key], count);
> >  }
> >  
> > -static void blacklist_print_port(int key, u32 val, int countfds[])
> > +static void blacklist_print_port(int key, __u32 val, int countfds[])
> >  {
> >  	int i;
> >  	__u64 count;
> >   

Applied

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
