Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qk0-f179.google.com ([209.85.220.179]:38068 "EHLO
        mail-qk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752384AbdK1ViK (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 28 Nov 2017 16:38:10 -0500
Received: by mail-qk0-f179.google.com with SMTP id z203so1829992qkb.5
        for <xdp-newbies@vger.kernel.org>; Tue, 28 Nov 2017 13:38:10 -0800 (PST)
Date: Tue, 28 Nov 2017 16:38:06 -0500
From: Andy Gospodarek <andy@greyhouse.net>
Subject: Re: XDP on many-core NPU
Message-ID: <20171128213806.GA3531@C02RW35GFVH8.dhcp.broadcom.net>
References: <CAM7NYTgW1AnJ0C4H2YiXOegp0p3BHCtU5bB7WfbcDTvaYzHJmw@mail.gmail.com>
 <20171128120229.16c0009c@redhat.com>
 <CAM7NYTiMU9JL0WxnAuaYhWsy4JebC06mLvC=NFVCB2r=ZFekLw@mail.gmail.com>
 <20171128213849.380ac926@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171128213849.380ac926@redhat.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: "MD I. Islam" <tamim@csebuet.org>, xdp-newbies@vger.kernel.org, Gilad Ben Yossef <giladby@mellanox.com>, Gilad Ben-Yossef <gilad@benyossef.com>

On Tue, Nov 28, 2017 at 09:38:49PM +0100, Jesper Dangaard Brouer wrote:
> 
> On Tue, 28 Nov 2017 15:00:04 -0500 "MD I. Islam" <tamim@csebuet.org> wrote:
> 
> > On Tue, Nov 28, 2017 at 6:02 AM, Jesper Dangaard Brouer
> > <brouer@redhat.com> wrote:
> > >
> > > On Mon, 27 Nov 2017 18:33:10 -0500 "MD I. Islam" <tamim@csebuet.org> wrote:
> > >  
> > >> I was wondering if XDP can scale to many-core NPU (such as NPS-400
> > >> which has 256 cores)? I need to develop a XCP/RCP like application
> > >> that can achieve bare-metal performance on each core. The application
> > >> will run in a run-to-completion model. I see, DPDK can run userspace
> > >> application on each core. I'm wondering if XDP has anything like that?
> > >> Please let me know any suggestion.  
> > >
> > > Hi Tamim,
> > >
> > > I think you are mixing up things a bit here...
> > >
> > > You mention a specific NIC (NPS-400) which have many cores inside the
> > > NIC.  You need to understand XDP is a software solution, where the
> > > programming language is eBPF.  XDP does NOT run inside the NIC, instead
> > > XDP runs as the earliest possible step in the Linux kernel network stack.
> > >
> > > The only NIC that does hardware offloading of XDP is Netronome[1], see
> > > their white papers[2].  
> > 
> > Hi Jesper
> > 
> > I was looking at
> > http://events.linuxfoundation.org/sites/events/files/slides/Massively_Multi-Core_LPC_2013.pdf.
> > It looks like the NPS-400 NIC also runs an embedded Linux itself. The
> > packets are processed by the embedded ARC processor. Packets
> > processing however is done at userspace. They also use DPDK-like
> > framework OpenNPU/NPS SDK to bypass the kernel. Is it possible to
> > achieve something similar to using XDP? Please let me know if I'm
> > getting anything wrong. I'm not sure if it is possible for me (a
> > third party developer/PhD student) to load a customized Linux on the
> > their NIC.
> 
> You should ask Gilad Ben-Yossef (Cc'ed), if he can help you getting XDP
> working on this NIC? ;-)
> 
> 
> > > [1] https://www.netronome.com/
> > > [2] https://open-nfp.org/dataplanes-ebpf/technical-papers/
> > >
> > > Regarding scaling: XDP scales perfect for each added CPU core.  XDP
> > > is currently (footnote-1) loaded on for entire NIC, but the XDP/eBPF
> > > program is executed separate/independent on each NIC RX-ring queue
> > > (processing up-to 64 frames per NAPI poll cycle).
> > >
> > > The XDP scaling depend on how well the NIC RSS distribute traffic
> > > across RX-ring queues, which is also true for the normal kernel
> > > network stack.  To address bad RSS distribution, I recently
> > > implement cpumap[3] to allow XDP to scale delivery to the normal
> > > kernel network stack.  See sample code[4][5] on how to use it.  
> > 
> > I was not looking to offload eBPF program from control plane. I would
> > rather like to program the dataplane by modifying the embedded Linux.
> 
> I know Broadcom is coming out with a smart-NIC, that actually just runs
> Linux, and they plan to support and use XDP to redirect packets into
> the machine that have the PCI NIC installed.  Is that what you are
> looking for?
> 

Did somebody say, Broadcom?  :-)

There are options that exist in the world for running a customized
version of Linux in a NIC that can control the traffic (if you like)
before the traffic arrives at the server.  Jesper is also correct that
standard XDP programs do run directly on this NIC as well.  Feel free to
email me directly if you want to know more and help determine if
hardware like this would be good for your research.

> 
> > I'm wondering if I can create kernel thread and pin them on each core
> > and having XDP to provide the thread with packets.
> 
> Well, what you describe above is exactly what cpumap does, it create
> kthread and pin them to specific CPUs. See below three links [3][4][5].
> 
> > > [3]
> > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/kernel/bpf/cpumap.c
> > > [4]
> > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/samples/bpf/xdp_redirect_cpu_kern.c
> > > [5]
> > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/samples/bpf/xdp_redirect_cpu_user.c
> > >
> > >
> > > (footnote-1: there are debates regarding loading XDP/eBPF progs on
> > > specific RX-queue numbers, so this might change.)
> > 
> > Many thanks
> > Tamim
> > PhD Candidate
> > Kent State University
> > http://web.cs.kent.edu/~mislam4/
> 
> -- 
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
