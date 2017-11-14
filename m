Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:43826 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752704AbdKNMLv (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 14 Nov 2017 07:11:51 -0500
Subject: Re: Packet forwarding in XDP
References: <bb1feffe7bf1e420b484e3963526748d@cse.iitd.ac.in>
 <20171112130024.3e18d0b2@redhat.com>
 <065d37ce81c88c2cc0f9377805766858@cse.iitd.ac.in>
 <20171114.153726.1131148784908217955.davem@davemloft.net>
 <23d23047171988b519f5c64565a3394d@cse.iitd.ac.in>
From: Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <f14071ff-6756-e431-0db0-4ce37cb7b5aa@iogearbox.net>
Date: Tue, 14 Nov 2017 13:11:44 +0100
MIME-Version: 1.0
In-Reply-To: <23d23047171988b519f5c64565a3394d@cse.iitd.ac.in>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: anmol07.visitor@cse.iitd.ac.in, David Miller <davem@davemloft.net>
Cc: Xdp <xdp-newbies@vger.kernel.org>

On 11/14/2017 07:57 AM, Anmol Panda wrote:
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
>    Thank you for your response. We have downloaded the latest stable version of the Linux kernel (4.13.12) and we compiled it with these flags enabled as per the directions here: http://cilium.readthedocs.io/en/stable/bpf/  .
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
>    We also enabled bpf_jit_enable and after the new kernel installation, we verified the setup using the ./test_verifier script int eh tools/testing/selftests/bpf/ folder and the all 506 tests were passed. When we tried the xdp1 program in the sample/tests/ we got the error:
> 
> No bpf syscall, kernel headers too old?
> 
>    Is there anything we are missing here? Please guide us.

Yes, please make sure that you have a reasonably recent iproute2, if not,
just compile it from the git master branch from:

https://git.kernel.org/pub/scm/linux/kernel/git/shemminger/iproute2.git/

You kernel headers installed on your machine seem too old, that is why
__NR_bpf is not defined and the iproute2 loader throws this error message
on bpf syscall.

Two options:

1) Install recent kernel headers, for example in your kernel source tree,
   run: make headers_install INSTALL_HDR_PATH=/usr/

or

2) Apply the iproute2 patch with fallback definitions for the syscall
   number manually: https://patchwork.ozlabs.org/patch/776015/ and then
   compile iproute2 again (patch is not in upstream iproute2).

Hope that helps,
Daniel
