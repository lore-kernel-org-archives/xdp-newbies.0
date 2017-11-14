Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from smtp2.iitd.ac.in ([103.27.10.44]:33376 "EHLO smtp2.iitd.ac.in"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753105AbdKNHJK (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 14 Nov 2017 02:09:10 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Tue, 14 Nov 2017 12:38:44 +0530
From: Anmol Panda <anmol07.visitor@cse.iitd.ac.in>
Subject: Re: Packet forwarding in XDP
Reply-To: anmol07.visitor@cse.iitd.ac.in
In-Reply-To: <23d23047171988b519f5c64565a3394d@cse.iitd.ac.in>
References: <bb1feffe7bf1e420b484e3963526748d@cse.iitd.ac.in>
 <20171112130024.3e18d0b2@redhat.com>
 <065d37ce81c88c2cc0f9377805766858@cse.iitd.ac.in>
 <20171114.153726.1131148784908217955.davem@davemloft.net>
 <23d23047171988b519f5c64565a3394d@cse.iitd.ac.in>
Message-ID: <9b5a69b5605cc217eb6ca911ee09cf34@cse.iitd.ac.in>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: David Miller <davem@davemloft.net>, Xdp <xdp-newbies@vger.kernel.org>

On 14.11.2017 12:27, Anmol Panda wrote:
> On 14.11.2017 12:07, David Miller wrote:
>> From: Anmol Panda <anmol07.visitor@cse.iitd.ac.in>
>> Date: Tue, 14 Nov 2017 12:03:23 +0530
>> 
>>> No bpf syscall, kernel headers too old?
>> 
>> Please enable CONFIG_BPF_SYSCALL in your kernel config.
> 
> Hello David,
> 
>    Thank you for your response. We have downloaded the latest stable
> version of the Linux kernel (4.13.12) and we compiled it with these
> flags enabled as per the directions here:
> http://cilium.readthedocs.io/en/stable/bpf/  .
> 
> CONFIG_CGROUP_BPF=y
> CONFIG_BPF=y
> CONFIG_BPF_SYSCALL=y
> CONFIG_NET_SCH_INGRESS=m
> CONFIG_NET_CLS_BPF=m
> CONFIG_NET_CLS_ACT=y
> CONFIG_BPF_JIT=y
> CONFIG_LWTUNNEL_BPF=y
> CONFIG_HAVE_EBPF_JIT=y
> CONFIG_BPF_EVENTS=y
> CONFIG_TEST_BPF=m
> 
>    We also enabled bpf_jit_enable and after the new kernel
> installation, we verified the setup using the ./test_verifier script
> int eh tools/testing/selftests/bpf/ folder and the all 506 tests were
> passed. When we tried the xdp1 program in the sample/tests/ we got the
> error:
> 
> No bpf syscall, kernel headers too old?
> 
> 
>    Is there anything we are missing here? Please guide us.
> 
> Thank you,
> Sincerely,

Sorry, once correction. The error encountered was in the 
tc_redirect_l2.sh script and not the xdp1.

Sincerely,
