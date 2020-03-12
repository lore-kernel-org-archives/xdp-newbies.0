Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from postout1.mail.lrz.de ([129.187.255.137]:58151 "EHLO
        postout1.mail.lrz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbgCLI1p (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 12 Mar 2020 04:27:45 -0400
From: "Gaul, Maximilian" <maximilian.gaul@hm.edu>
Subject: AW: Shared Umem between processes
Date: Thu, 12 Mar 2020 08:20:23 +0000
Message-ID: <a80ec2c07cb9493eafabb9decf479c60@hm.edu>
References: <fd5e40efd5c1426cb4a5942682407ea2@hm.edu>,<CAJ+HfNghFctg3L=3QdeoWyqDdj4wP4EKWjYyF01=SmCO5+=32g@mail.gmail.com>
In-Reply-To: <CAJ+HfNghFctg3L=3QdeoWyqDdj4wP4EKWjYyF01=SmCO5+=32g@mail.gmail.com>
Content-Language: de-DE
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>, Xdp <xdp-newbies@vger.kernel.org>
Cc: "bpf@vger.kernel.org" <bpf@vger.kernel.org>

I don't know if this reply works but I will try.

On Thu, 12 Mar 2020 at 08:55, Björn Töpel <bjorn.topel@gmail.com> wrote:
>>
>> Hello everyone,
>>
>
> Hi! I'm moving this to the XDP newbies list, which is a more proper
> place for these kind of discussions!
>
Sure, no problem. Thank you.
>>
>> I am not sure if this is the correct address for my question / problem but I was forwarded to this e-mail from the libbpf github-issue section, so this is my excuse.
>>
>>
>> Just a few information at the start of this e-mail: My program is largely based on:  https://github.com/xdp-project/xdp-tutorial/tree/master/advanced03-AF_XDP and I am using libbpf: https://github.com/libbpf/libbpf
>>
>>
>> I am currently trying to build an application that enables me to process multiple udp-multicast streams at once in parallel (each with up to several ten-thousands of packets per second).
>>
>>
>> My first solution was to steer each multicast-stream on a separate RX-Queue on my NIC via `ethtool -N <if> flow-type udp4 ...` and to spawn as much user-space processes (each with a separate AF-XDP socket connected to one of the RX-Queues) as there are streams  to process.
>>
>>
>> But because this solution is limited to the amount of RX-Queues the NIC has and I wanted to build something hardware-independent, I looked around a bit and found a feature called `XDP_SHARED_UMEM`.
>>

> Let's start with defining what shared-umem is: The idea is to share
> the same umem, fill ring, and completion ring for multiple
> sockets. The sockets sharing that umem/fr/cr are tied (bound) to one
> hardware ring. It's a mechanism to load-balance a HW queue over
> multiple sockets.
> 
> If I'm reading you correctly, you'd like a solution:
> 
>            hw_q0,
> xsk_q0_0, xsk_q0_1, xsk_q0_2,
> 
> instead of:
> 
> hw_q0,    hw_q1,    hw_q2,
> xsk_q0_0, xsk_q1_0, xsk_q2_0,
>
> In the first case you'll need to mux the flows in the XDP program
> using an XSKMAP.
> 
> Is this what you're trying to do?
>
Yes it is. But I had the problem that I couldn't create multiple sockets (no sharing, everyone with its own umem and rx/tx queues) tied to the same RX-Queue. Maybe I did something wrong. But is this possible?
>>
>>
>> As far as I understand (please correct me if I am wrong), at the moment libbpf only supports shared umem between threads of a process but not between processes - right?
>>
>
> Yes, that is correct, and for a reason! :-) Note that if you'd like to
> do a multi-*process* setup with shared umem, you: need to have a
> control process that manages the fill/completion rings, and
> synchronize between the processes, OR re-mmap the fill/completetion
> ring from the socket owning the umem in multiple processes *and*
> synchronize the access to them. Neither is pleasant.
> 
> Honestly, not a setup I'd recommend.
>
This indeed sounds very unpleasent. So instead, if I understand correctly, you would go with the version above (the XDP program distributing the packets on the sockets via a XSKMAP). Is there something I have to watch out for? As I said, I wasn't able to create multiple sockets for the same RX-Queue.
>> I ran unto the problem, that `struct xsk_umem` is hidden in `xsk.c`. This prevents me from copying the content from the original socket / umem into shared memory. I am not sure, what information the sub-process (the one which is using the umem from another  process) needs so I figured the simplest solution would be to just copy the whole umem struct.
>>
>
> Just for completeness; To setup shared umem:
> 
> 1. create socket 0 and register the umem to this.
> 2. mmap the fr/cr using socket 0
> 3. create socket 1, 2, n and refer to socket 0 for the umem.
>
> So, in a multiprocess solution step 3 would be done in separate
> processes, and step 2 depending on your application. You'd need to
> pass socket 0 to the other processes *and* share the umem memory from
> the process where socket 0 was created. This is pretty much a threaded
> solution, given all the shared state.
>
> I advice not taking this path.
>
I am not entirely sure what you mean with *passing socket 0* is this just the fd of the socket? What's about the `struct xsk_umem`? Do I need that? I guess so because `xsk_socket__create()` has a parameter `struct xsk_umem`.
>>
>>
>> So I went with the "quick-fix" to just move the definition of `struct xsk_umem` into `xsk.h` and to copy the umem-information from the original process into a shared memory. This process then calls `fork()` thus spawning a sub-process. This sub-process then  reads the previously written umem-information from shared memory and passes it into `xsk_configure_socket` (af_xdp_user.c) which then eventually calls `xsk_socket__create` in `xsk.c`. This function then checks for `umem->refcount` and sets the flags for shared  umem accordingly.
>>
>>
>>
>> After returning from `xsk_socket__create` (we are still in `xsk_configure_socket` in af_xdp_user.c), `bpf_get_link_xdp_id` is called (I don't know if that's necessary). But after that call I exit the function `xsk_socket__create` in the sub-process because  I figured it is probably bad to configure the umem a second time by calling `xsk_ring_prod__reserve` after that:
>>
>>
>>
>>
>> static struct xsk_socket_info *xsk_configure_socket(struct config *cfg, struct xsk_umem_info *umem) {
>>
>> struct xsk_socket_config xsk_cfg;
>> struct xsk_socket_info *xsk_info;
>> uint32_t idx;
>> uint32_t prog_id = 0;
>> int i;
>> int ret;
>>
>> xsk_info = calloc(1, sizeof(*xsk_info));
>> if (!xsk_info)
>> return NULL;
>>
>> xsk_info->umem = umem;
>> xsk_cfg.rx_size = XSK_RING_CONS__DEFAULT_NUM_DESCS;
>> xsk_cfg.tx_size = XSK_RING_PROD__DEFAULT_NUM_DESCS;
>> xsk_cfg.libbpf_flags = 0;
>> xsk_cfg.xdp_flags = cfg->xdp_flags;
>> xsk_cfg.bind_flags = cfg->xsk_bind_flags;
>> ret = xsk_socket__create(&xsk_info->xsk, cfg->ifname, cfg->xsk_if_queue, umem->umem, &xsk_info->rx, &xsk_info->tx, &xsk_cfg);
>>
>> if (ret) {
>> fprintf(stderr, "FAIL 1\n");
>> goto error_exit;
>> }
>>
>> ret = bpf_get_link_xdp_id(cfg->ifindex, &prog_id, cfg->xdp_flags);
>> if (ret) {
>> fprintf(stderr, "FAIL 2\n");
>> goto error_exit;
>> }
>>
>> /* Initialize umem frame allocation */
>> for (i = 0; i < NUM_FRAMES; i++)
>> xsk_info->umem_frame_addr[i] = i * FRAME_SIZE;
>>
>> xsk_info->umem_frame_free = NUM_FRAMES;
>>
>> if(cfg->use_shrd_umem) {
>> return xsk_info;
>> }
>>         ...
>> }
>>
>> Somehow what I am doing doesn't work because my sub-process dies in `xsk_configure_socket`. I am not able to debug it properly with GDB though. Another point I don't understand is the statement:
>>
>> However, note that you need to supply the XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD libbpf_flag with the xsk_socket__create calls and load your own XDP program as there is no built in one in libbpf that will route the traffic for you.
>>
>> from  https://www.kernel.org/doc/html/latest/networking/af_xdp.html#xdp-shared-umem-bind-flag
>>
>> I didn't know that libbpf loads a XDP-program? Why would it do that? I am using my own af-xdp program which filters for udp-packets. If I set `xsk_cfg.libbpf_flags = XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD;` in `xsk_configure_socket`, the af-xdp-socket fd is  not put into the kernel `xsks-map` which basically means that I don't receive any packets.
>>
>> As you probably already noticed, I am overstrained with the concept of Shared Umem and I have to say, there is no documentation about it besides the two sentences in  https://www.kernel.org/doc/html/latest/networking/af_xdp.html#xdp-shared-umem-bind-flag and a mail in a linux mailbox from Nov. 2019 stating that this feature is now implemented.
>>
>> Can you please help?
>>
>
> XDP sockets always use an XDP program, it just that a default one is
> provided if the use doesn't explicitly add one. Have a look at
> tools/lib/bpf/xsk.c:xsk_load_xdp_prog. So, for shared umem you need to
> explicitly have a program that muxes over the sockets. A naïve variant
> can be found in samples/bpf/xdpsock_kern.c
> 
> 
> Cheers,
> Björn
> 
>> Best regards
>>
>> Max
    
