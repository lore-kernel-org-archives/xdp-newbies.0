Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49968 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751131AbdKLMAh (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Sun, 12 Nov 2017 07:00:37 -0500
Date: Sun, 12 Nov 2017 13:00:24 +0100
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: Packet forwarding in XDP
Message-ID: <20171112130024.3e18d0b2@redhat.com>
In-Reply-To: <bb1feffe7bf1e420b484e3963526748d@cse.iitd.ac.in>
References: <bb1feffe7bf1e420b484e3963526748d@cse.iitd.ac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Anmol Panda <anmol07.visitor@cse.iitd.ac.in>
Cc: Xdp <xdp-newbies@vger.kernel.org>, brouer@redhat.com

On Sun, 12 Nov 2017 14:27:25 +0530
Anmol Panda <anmol07.visitor@cse.iitd.ac.in> wrote:

> Dear all,
>      We are trying to write a program that receives a packet from a 
> client and is supposed to return the packet to the source. We tried to 
> swap the source and dest and send it using the XDP_TX action. But it 
> doesn't work.
> 
>     We have compiled a new kernel and bound the NIC to xdp successfully. 
> After binding, the system stops responding to ping and other packet 
> generating scripts (like sendip). We are using kernel  4.13.12 (Ubuntu 
> 17.10) from the main linux kernel tree and binding with Intel I217-LM 
> NIC. This NIC is using e1000e driver. Can xdp / eBPF be used for this 
> NIC? Moreover, do we need to patch the driver for additional support?

Not all drivers have "native' XDP support. See slide 11 of [1]

[1] http://people.netfilter.org/hawk/presentations/driving-IT2017/driving-IT-2017_XDP_eBPF_technology_Jesper_Brouer.pdf

There is something called "Generic" XDP (v4.12) for ease of
development. It allow you to attach an XDP program any net_device. I
call it --skb-mode in my sample programs. See [2]

[2] https://prototype-kernel.readthedocs.io/en/latest/blogposts/xdp25_eval_generic_xdp_tx.html

>      Our aim is to benchmark various forwarding applications (L2 , L3, 
> etc.) run using xdp. Please point to some code samples to achieve this. 
> We will be truly grateful.

Kernel have directory: samples/bpf/

I maintain some more example programs here:
 https://github.com/netoptimizer/prototype-kernel/tree/master/kernel/samples/bpf


Do notice that e1000e is only 1Gbit/s (which is very slow).  The normal
Linux kernel can handle 1Gbit/s without any issues... I hope you are
planning to use something faster, else it does not make sense to use XDP.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
