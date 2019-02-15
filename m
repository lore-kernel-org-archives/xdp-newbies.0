Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:35670 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726008AbfBOIRX (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 15 Feb 2019 03:17:23 -0500
Message-ID: <0b81d664175a21be2a8421a3f7afdf520b376474.camel@regit.org>
Subject: Re: Interruption in eBPF program after kernel update
From: Eric Leblond <eric@regit.org>
Date: Fri, 15 Feb 2019 09:17:16 +0100
In-Reply-To: <CAH3MdRUckeeKXCSB+W4jJWcNNKSWQQ98LyUkQUG1DWWA7DYn6w@mail.gmail.com>
References: <96e834867100a5ae9a941c639ef93456a2600021.camel@regit.org>
         <509b74cb74f13b02122707d2505e5c690866b159.camel@regit.org>
         <CAH3MdRUckeeKXCSB+W4jJWcNNKSWQQ98LyUkQUG1DWWA7DYn6w@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Y Song <ys114321@gmail.com>
Cc: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>

Hello,

On Thu, 2019-02-14 at 14:39 -0800, Y Song wrote:
> On Thu, Feb 14, 2019 at 10:33 AM Eric Leblond <eric@regit.org> wrote:
> > Hello,
> > 
> > On Wed, 2019-02-13 at 20:46 +0100, Eric Leblond wrote:
> > > Hello,
> > > 
> > > I've got a simple socket filter program that seems to interrupt
> > > when
> > > calling the load_word construct. I'm seeing the first message but
> > > never
> > > the second one.
> > > 
> > > The code is the following
> > > 
> > > int SEC("filter") hashfilter(struct __sk_buff *skb) {
> > >     __u32 nhoff = BPF_LL_OFF + ETH_HLEN;
> > 
> > So it seems the problem was coming from this line. Removing
> > BPF_LL_OFF
> > fixes the problem for kernel starting 4.18.
> 
> Maybe removing BPF_LL_OFF should work for all kernels?

OK, you are right. I really don't understand how it is possible but
same eBPF file without BPF_LL_OFF work on 4.17 at 4.19. Looks like
BPF_LL_OFF was just ignored in 4.17 but caused a problem on 4.19.

Thanks a lot.

BR,

> > Is this a known issue ?
> > 
> > Is there something that would allow a BPF file to work
> > independently of
> > the kernel version ?
> > 
> > >     __u32 ip = 0;
> > >     __u32 *value = NULL;
> > > #if 1
> > >     char fmtrei[] = "word load\n";
> > >     bpf_trace_printk(fmtrei, sizeof(fmtrei));
> > > #endif
> > >     ip = load_word(skb, nhoff + offsetof(struct iphdr, saddr));
> > > #if 1
> > >     char fmti[] = "work done\n";
> > >     bpf_trace_printk(fmti, sizeof(fmti));
> > > #endif
> > > In 4.18 and above this is not working but older kernel were ok.
> > > 
> > > Any suggestion will be appreciated.
> > > 
> > > Best regards,
> > 
> > BR,
> > --
> > Eric Leblond <eric@regit.org>
> > 
-- 
Eric Leblond <eric@regit.org>
