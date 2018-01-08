Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-it0-f45.google.com ([209.85.214.45]:41522 "EHLO
        mail-it0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755739AbeAHTUS (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Mon, 8 Jan 2018 14:20:18 -0500
Received: by mail-it0-f45.google.com with SMTP id b77so5544749itd.0
        for <xdp-newbies@vger.kernel.org>; Mon, 08 Jan 2018 11:20:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <88581FA1-DA7C-4329-8D62-185090FC820D@polito.it>
References: <88581FA1-DA7C-4329-8D62-185090FC820D@polito.it>
From: William Tu <u9012063@gmail.com>
Date: Mon, 8 Jan 2018 11:19:37 -0800
Message-ID: <CALDO+SbMuv3shRwmo5o7AmKLoG13EboXsh5T1SBH+EsWyR_0QA@mail.gmail.com>
Subject: Re: Generic XDP and veth
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: Matteo Bertrone <matteo.bertrone@polito.it>
Cc: Xdp <xdp-newbies@vger.kernel.org>

Hi Matteo,

On Mon, Jan 8, 2018 at 7:33 AM, Matteo Bertrone
<matteo.bertrone@polito.it> wrote:
> Hello,
>
> while I was trying to forward packets using Generic XDP [1], I encountered the following problem:
>
> ARP and ICMP packets are forwarded correctly, and ping works fine.
> It seems not all TCP packets are forwarded by XDP program, both netcat and iperf are not working for me.
>
> (Using same configuration as [1])
> sudo ip netns exec ns2 nc -l 8080
> sudo ip netns exec ns1 nc 10.1.1.22 8080
>
> sudo ip netns exec ns2 iperf3 -s
> sudo ip netns exec ns1 iperf3 -c 10.1.1.22
>
> It seems such traffic is not processed by XDP program.
> Using tcpdump on veth1 in root namespace I’m not able to see ARP and ICMP traffic (as expected) because forwarded by XDP program, but I’m able to see all the traffic it’s not forwarded.
>
> Is this behavior expected?
> Did I miss something in veth configuration?
>

I tested nc on my system and I saw the same issue. Using UDP (nc -u)
works, but TCP doesn't.
From the client side (ns1), tcpdump can see SYN packet at veth11 and
veth1, but the packet didn't reach the BPF program attached at veth1.
Somewhere in-between the SYN packet is dropped.  I guess it's related
to some tcp offload settings? I will need to debug a bit on this.

Thanks
William

> [1] https://github.com/torvalds/linux/blob/master/tools/testing/selftests/bpf/test_xdp_redirect.sh
