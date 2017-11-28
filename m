Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48794 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752146AbdK1LCg (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 28 Nov 2017 06:02:36 -0500
Date: Tue, 28 Nov 2017 12:02:29 +0100
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: XDP on many-core NPU
Message-ID: <20171128120229.16c0009c@redhat.com>
In-Reply-To: <CAM7NYTgW1AnJ0C4H2YiXOegp0p3BHCtU5bB7WfbcDTvaYzHJmw@mail.gmail.com>
References: <CAM7NYTgW1AnJ0C4H2YiXOegp0p3BHCtU5bB7WfbcDTvaYzHJmw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: "MD I. Islam" <tamim@csebuet.org>
Cc: xdp-newbies@vger.kernel.org, brouer@redhat.com


On Mon, 27 Nov 2017 18:33:10 -0500 "MD I. Islam" <tamim@csebuet.org> wrote:

> I was wondering if XDP can scale to many-core NPU (such as NPS-400
> which has 256 cores)? I need to develop a XCP/RCP like application
> that can achieve bare-metal performance on each core. The application
> will run in a run-to-completion model. I see, DPDK can run userspace
> application on each core. I'm wondering if XDP has anything like that?
> Please let me know any suggestion.

Hi Tamim,

I think you are mixing up things a bit here...

You mention a specific NIC (NPS-400) which have many cores inside the
NIC.  You need to understand XDP is a software solution, where the
programming language is eBPF.  XDP does NOT run inside the NIC, instead
XDP runs as the earliest possible step in the Linux kernel network stack.

The only NIC that does hardware offloading of XDP is Netronome[1], see
their white papers[2].

[1] https://www.netronome.com/
[2] https://open-nfp.org/dataplanes-ebpf/technical-papers/

Regarding scaling: XDP scales perfect for each added CPU core.  XDP is
currently (footnote-1) loaded on for entire NIC, but the XDP/eBPF
program is executed separate/independent on each NIC RX-ring queue
(processing up-to 64 frames per NAPI poll cycle).

The XDP scaling depend on how well the NIC RSS distribute traffic
across RX-ring queues, which is also true for the normal kernel network
stack.  To address bad RSS distribution, I recently implement cpumap[3]
to allow XDP to scale delivery to the normal kernel network
stack.  See sample code[4][5] on how to use it.

[3] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/kernel/bpf/cpumap.c
[4] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/samples/bpf/xdp_redirect_cpu_kern.c
[5] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/samples/bpf/xdp_redirect_cpu_user.c


(footnote-1: there are debates regarding loading XDP/eBPF progs on
specific RX-queue numbers, so this might change.)
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
