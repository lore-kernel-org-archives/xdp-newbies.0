Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from smtp2.iitd.ac.in ([103.27.10.44]:44194 "EHLO smtp2.iitd.ac.in"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751030AbdKNGaj (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 14 Nov 2017 01:30:39 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp2.iitd.ac.in (Postfix) with ESMTP id 7ACB740D15
        for <xdp-newbies@vger.kernel.org>; Tue, 14 Nov 2017 12:00:37 +0530 (IST)
Received: from smtp2.iitd.ac.in ([127.0.0.1])
        by localhost (smtp2.iitd.ac.in [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 9GFXwPxfNMm7 for <xdp-newbies@vger.kernel.org>;
        Tue, 14 Nov 2017 12:00:33 +0530 (IST)
Received: from webmail.iitd.ac.in (webmail.iitd.ac.in [10.7.172.189])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: anmol07.visitor)
        by smtp2.iitd.ac.in (Postfix) with ESMTPSA id 1E17640D05
        for <xdp-newbies@vger.kernel.org>; Tue, 14 Nov 2017 12:00:33 +0530 (IST)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Tue, 14 Nov 2017 12:00:32 +0530
From: Anmol Panda <anmol07.visitor@cse.iitd.ac.in>
Subject: Re: Packet forwarding in XDP
Reply-To: anmol07.visitor@cse.iitd.ac.in
In-Reply-To: <20171112130024.3e18d0b2@redhat.com>
References: <bb1feffe7bf1e420b484e3963526748d@cse.iitd.ac.in>
 <20171112130024.3e18d0b2@redhat.com>
Message-ID: <8924b0a188eec9784db4e77a8d537e56@cse.iitd.ac.in>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Xdp <xdp-newbies@vger.kernel.org>

On 12.11.2017 17:30, Jesper Dangaard Brouer wrote:
> On Sun, 12 Nov 2017 14:27:25 +0530
> Anmol Panda <anmol07.visitor@cse.iitd.ac.in> wrote:
> 
>> Dear all,
>>      We are trying to write a program that receives a packet from a
>> client and is supposed to return the packet to the source. We tried to
>> swap the source and dest and send it using the XDP_TX action. But it
>> doesn't work.
>> 
>>     We have compiled a new kernel and bound the NIC to xdp 
>> successfully.
>> After binding, the system stops responding to ping and other packet
>> generating scripts (like sendip). We are using kernel  4.13.12 (Ubuntu
>> 17.10) from the main linux kernel tree and binding with Intel I217-LM
>> NIC. This NIC is using e1000e driver. Can xdp / eBPF be used for this
>> NIC? Moreover, do we need to patch the driver for additional support?
> 
> Not all drivers have "native' XDP support. See slide 11 of [1]
> 
> [1]
> http://people.netfilter.org/hawk/presentations/driving-IT2017/driving-IT-2017_XDP_eBPF_technology_Jesper_Brouer.pdf
> 
> There is something called "Generic" XDP (v4.12) for ease of
> development. It allow you to attach an XDP program any net_device. I
> call it --skb-mode in my sample programs. See [2]
> 
> [2]
> https://prototype-kernel.readthedocs.io/en/latest/blogposts/xdp25_eval_generic_xdp_tx.html
> 
>>      Our aim is to benchmark various forwarding applications (L2 , L3,
>> etc.) run using xdp. Please point to some code samples to achieve 
>> this.
>> We will be truly grateful.
> 
> Kernel have directory: samples/bpf/
> 
> I maintain some more example programs here:
>  
> https://github.com/netoptimizer/prototype-kernel/tree/master/kernel/samples/bpf
> 
> 
> Do notice that e1000e is only 1Gbit/s (which is very slow).  The normal
> Linux kernel can handle 1Gbit/s without any issues... I hope you are
> planning to use something faster, else it does not make sense to use 
> XDP.
