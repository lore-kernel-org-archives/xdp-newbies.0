Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from fm1nodo5.polito.it ([130.192.180.18]:36475 "EHLO
        fm1nodo5.polito.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbeJaE3H (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 31 Oct 2018 00:29:07 -0400
From: Mauricio Vasquez <mauricio.vasquez@polito.it>
Subject: Re: New to xdp Cant find initial syn packet?
References: <CAKS0-=qXKuTVt+KuXZ08_1VU1reJkCf=v=oNiASbxVaKfcr3oA@mail.gmail.com>
Message-ID: <00aa9bf7-6253-5f0e-6056-e67fccba6756@polito.it>
Date: Tue, 30 Oct 2018 14:07:12 -0500
MIME-Version: 1.0
In-Reply-To: <CAKS0-=qXKuTVt+KuXZ08_1VU1reJkCf=v=oNiASbxVaKfcr3oA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Matthew Tejo <matthew.tejo@gmail.com>, xdp-newbies@vger.kernel.org


On 10/26/18 2:13 PM, Matthew Tejo wrote:
> Hey,
> I started trying out xdp programs recently and I was comparing what
> comes out of tcp dump and my test program. It seems like the first syn
> in the packet never appears in my logged out put, the rest of the
> packets do.
>
> I am using a vm and using the loopback interface and a virtual one
> created by docker, both will only start from the second outgoing
> packet.
>
> Tcpdump shows syn -> syn,ack -> ack. But the xdp program only starts
> from syn,ack then ack. Im logging using bpf_trace_printk and put the
> statement at the beginning of the section being loaded so something
> should at least print every time?
>
> Is there something Im over looking?
>
> Thanks and let me know if I can clarify anything.
> Matt
>
Hello Matthew,

If you are using generic XDP [1] you are probably hitting a known issue 
with TCP traffic [2].

AFAIK there is not a solution for that issue yet, Linux kernel v4.19 has 
a native XDP driver for veth [3], this probably solves this issue 
(please somebody correct me if I am wrong).

I hope this helps,

Mauricio.


[1] https://lwn.net/Articles/720072/

[2] https://www.spinics.net/lists/xdp-newbies/msg00440.html

[3] 
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=948d4f214fde43743c57aae0c708bff44f6345f2
