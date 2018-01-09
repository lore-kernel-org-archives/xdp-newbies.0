Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pg0-f54.google.com ([74.125.83.54]:39598 "EHLO
        mail-pg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752011AbeAIAMQ (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Mon, 8 Jan 2018 19:12:16 -0500
Received: by mail-pg0-f54.google.com with SMTP id z20so4460422pgv.6
        for <xdp-newbies@vger.kernel.org>; Mon, 08 Jan 2018 16:12:16 -0800 (PST)
Date: Mon, 8 Jan 2018 16:12:09 -0800
From: Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: Generic XDP and veth
Message-ID: <20180108161209.7b872c50@xeon-e3>
In-Reply-To: <CALDO+SbE7bgqV96PqJg=1UZ6CiEGFGyJxkT-Nv=w0EuTON57mQ@mail.gmail.com>
References: <88581FA1-DA7C-4329-8D62-185090FC820D@polito.it>
        <CALDO+SbMuv3shRwmo5o7AmKLoG13EboXsh5T1SBH+EsWyR_0QA@mail.gmail.com>
        <1b11a672-cfd2-ec22-3a1d-117bc1590241@iogearbox.net>
        <CALDO+SbE7bgqV96PqJg=1UZ6CiEGFGyJxkT-Nv=w0EuTON57mQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: William Tu <u9012063@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>, Matteo Bertrone <matteo.bertrone@polito.it>, Xdp <xdp-newbies@vger.kernel.org>

On Mon, 8 Jan 2018 14:48:29 -0800
William Tu <u9012063@gmail.com> wrote:

> On Mon, Jan 8, 2018 at 2:04 PM, Daniel Borkmann <daniel@iogearbox.net> wrote:
> > On 01/08/2018 08:19 PM, William Tu wrote:  
> >> Hi Matteo,
> >>
> >> On Mon, Jan 8, 2018 at 7:33 AM, Matteo Bertrone
> >> <matteo.bertrone@polito.it> wrote:  
> >>> Hello,
> >>>
> >>> while I was trying to forward packets using Generic XDP [1], I encountered the following problem:
> >>>
> >>> ARP and ICMP packets are forwarded correctly, and ping works fine.
> >>> It seems not all TCP packets are forwarded by XDP program, both netcat and iperf are not working for me.
> >>>
> >>> (Using same configuration as [1])
> >>> sudo ip netns exec ns2 nc -l 8080
> >>> sudo ip netns exec ns1 nc 10.1.1.22 8080
> >>>
> >>> sudo ip netns exec ns2 iperf3 -s
> >>> sudo ip netns exec ns1 iperf3 -c 10.1.1.22
> >>>
> >>> It seems such traffic is not processed by XDP program.
> >>> Using tcpdump on veth1 in root namespace I’m not able to see ARP and ICMP traffic (as expected) because forwarded by XDP program, but I’m able to see all the traffic it’s not forwarded.
> >>>
> >>> Is this behavior expected?
> >>> Did I miss something in veth configuration?
> >>>  
> >>
> >> I tested nc on my system and I saw the same issue. Using UDP (nc -u)
> >> works, but TCP doesn't.
> >> From the client side (ns1), tcpdump can see SYN packet at veth11 and
> >> veth1, but the packet didn't reach the BPF program attached at veth1.
> >> Somewhere in-between the SYN packet is dropped.  I guess it's related
> >> to some tcp offload settings? I will need to debug a bit on this.  
> >
> > See this one, which you're most likely hitting in TCP case:
> >
> > static u32 netif_receive_generic_xdp(struct sk_buff *skb,
> >                                      struct bpf_prog *xdp_prog)
> > {
> >         struct netdev_rx_queue *rxqueue;
> >         u32 metalen, act = XDP_DROP;
> >         struct xdp_buff xdp;
> >         void *orig_data;
> >         int hlen, off;
> >         u32 mac_len;
> >
> >         /* Reinjected packets coming from act_mirred or similar should
> >          * not get XDP generic processing.
> >          */
> >         if (skb_cloned(skb))
> >                 return XDP_PASS;
> >
> >         [...]
> > }  
> 
> Hi Daniel,
> 
> Thanks!
> Yes it is hitting this "if (skb_cloned(skb))" so the BPF program is
> not triggered.
> I don't quite understand why only TCP packets are cloned an others are
> not, is this behavior expected?
> 
> Thank you
> William

TCP keeps a clone to send retries.
