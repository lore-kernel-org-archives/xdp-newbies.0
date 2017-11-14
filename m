Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from smtp2.iitd.ac.in ([103.27.10.44]:45010 "EHLO smtp2.iitd.ac.in"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752681AbdKNGd3 (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 14 Nov 2017 01:33:29 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Tue, 14 Nov 2017 12:03:23 +0530
From: Anmol Panda <anmol07.visitor@cse.iitd.ac.in>
Subject: Re: Packet forwarding in XDP
Reply-To: anmol07.visitor@cse.iitd.ac.in
In-Reply-To: <20171112130024.3e18d0b2@redhat.com>
References: <bb1feffe7bf1e420b484e3963526748d@cse.iitd.ac.in>
 <20171112130024.3e18d0b2@redhat.com>
Message-ID: <065d37ce81c88c2cc0f9377805766858@cse.iitd.ac.in>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Xdp <xdp-newbies@vger.kernel.org>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>

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

Hello,
    Thank you Jesper for your quick response.
    We are trying to run the programs ~/linux-4.13.12/samples/bpf/ and we 
get the following error (also attached as a snapshot):

'
root@compute5:~/workspace/XDP/kernel/linux-4.13.12/samples/bpf# 
./tc_l2_redirect.sh
l2_to_ipip ingress: Note: 8 bytes struct bpf_elf_map fixup performed due 
to size mismatch!
No bpf syscall, kernel headers too old?
No bpf syscall, kernel headers too old?
Map object 'tun_iface' rejected: Function not implemented (38)!
  - Type:         2
  - Identifier:   0
  - Pinning:      2
  - Size key:     4
  - Size value:   4
  - Max elems:    1
  - Flags:        0

Error loading maps into kernel!
Error fetching ELF ancillary data!
'
     We are now using the Intel x520 dual port NICs (total 40 Gbps b/w). 
Please guide us regarding the error above.

Thanks,
Sincerely,
