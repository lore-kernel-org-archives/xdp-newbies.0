Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45286 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725830AbfGUGnC (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Sun, 21 Jul 2019 02:43:02 -0400
Date: Sun, 21 Jul 2019 08:42:54 +0200
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: AF_XDP and packet timestamp
Message-ID: <20190721084254.0fca2aaa@carbon>
In-Reply-To: <87d0jca2z1.fsf@toke.dk>
References: <86f135475a7820adadb05e7ac9a05c71846bebd6.camel@regit.org>
        <87d0jca2z1.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc: Eric Leblond <eric@regit.org>, xdp-newbies@vger.kernel.org, brouer@redhat.com

On Mon, 17 Jun 2019 13:03:14 +0200
Toke Høiland-Jørgensen <toke@redhat.com> wrote:

> Eric Leblond <eric@regit.org> writes:
> 
> > Hello,
> >
> > I did start to work on AF_XDP support for Suricata. API was really easy
> > to use via libbpf.
> >
> > From Suricata point of view, the current system with default
> > configuration is lacking an important information. I don't have access
> > to the timestamp of the packet. I'm in particular interested by the
> > hardware timestamp as it would allow to do reordering in some capture
> > cases.
> >
> > Is there a way to get the information via AF_XDP. I've seen the
> > discussion on hardware hints but there was no code example I was able
> > to find.  
> 
> Making more information from the hardware available to XDP is currently
> on our list of things we plan to enable in the future:
> https://github.com/xdp-project/xdp-project/blob/master/xdp-project.org#metadata-available-to-programs
> 
> I just added timestamps as a field we want in there (so we don't
> forget).
> 
> I.e., no, there is no way to get this information from XDP (and thus not
> from AF_XDP either) yet...

We/XDP don't have access to hardware info, yet... BUT I plan to add
this, e.g. see my slides[1].  (Where to place this HW info, and how to
make it avail to both XDP and netstack, didn't reach a conclusion at
NetConf2019, so the "roadmap" is fuzzy).

To get a software timestamp into AF_XDP, simply use helper
bpf_ktime_get_ns() to get the time, and store info into metadata area
(placed in front of packet) via helper bpf_xdp_adjust_meta() example
see[2].  Then AF_XDP userspace can read this metadata area, which is
placed just in front of packet headers.


[1] http://vger.kernel.org/netconf2019_files/xdp-metadata-discussion.pdf
[2] https://github.com/torvalds/linux/blob/master/samples/bpf/xdp2skb_meta_kern.c
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
