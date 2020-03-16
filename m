Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:49439 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730048AbgCPIid (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 16 Mar 2020 04:38:33 -0400
Date: Mon, 16 Mar 2020 09:38:19 +0100
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: Why does my AF-XDP Socket lose packets whereas a generic linux
 socket doesn't?
Message-ID: <20200316093819.65c24cdd@carbon>
In-Reply-To: <27adfa9b069242a3a0d8e9ccd64e308a@hm.edu>
References: <27adfa9b069242a3a0d8e9ccd64e308a@hm.edu>
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: "Gaul, Maximilian" <maximilian.gaul@hm.edu>
Cc: brouer@redhat.com, Xdp <xdp-newbies@vger.kernel.org>, =?UTF-8?B?Qmo=?= =?UTF-8?B?w7ZybiBUw7ZwZWw=?= <bjorn.topel@intel.com>

On Sun, 15 Mar 2020 15:36:13 +0000
"Gaul, Maximilian" <maximilian.gaul@hm.edu> wrote:

> I am comparing AF-XDP sockets vs Linux Sockets in terms of how many
> packets they can process without packet-loss (packet-loss is defined
> as the RTP-sequence number of the current packet is not equal to the
> RTP-sequence number of the previous packet `+ 1`).
> 
> I noticed that my AF-XDP socket program (I can't determine if this
> problem is related to the kernel program or the user-space program)
> is losing around `~25` packets per second at around `390.000` packets
> per second whereas an equivalent program with generic linux sockets
> doesn't lose any packets.
> 
[...]

> Because I figured I don't need maximum latency for this application,
> I send the process to sleep for a specified time (around `1 - 2ms`)
> after which it loops through every AF-XDP socket (most of the time it
> is only one socket) and processes every received packet for that
> socket, verifying that no packets have been missed:
> 
> 	while(!global_exit) {
> 	    nanosleep(&spec, &remaining);
> 
> 		for(int i = 0; i < cfg.ip_addrs_len; i++) {
> 			struct xsk_socket_info *socket = xsk_sockets[i];
> 			if(atomic_exchange(&socket->stats_sync.lock, 1) == 0) {
> 				handle_receive_packets(socket);
> 				atomic_fetch_xor(&socket->stats_sync.lock, 1); /* release socket-lock */
> 			}
> 		}
> 	}

You say that you are sleeping for a specified time around 1 - 2ms.

Have you considered if in the time your programs sleeps, if the
RX-queue can be overflowed?

You say at 390,000 pps drops happen.  At this speed a packets arrive
every 2.564 usec (1/390000*10^9 = 2564 ns = 2.564 usec).

What NIC hardware/driver are you using?
And what is the RX-queue size? (ethtool -g)
On Intel's XL710 driver i40e, the default RX-ring size is 512.

The "good-queue" effect is that a queue functions as a shock absorber,
to handle that the OS/CPU is busy doing something else.  If I have 512
RX-queue slots, and packets arriving every 2.564 usec, then I must
return and empty the queue (and re-fill slots) every 1.3 ms
(512 * 2.564 usec = 1312.768 usec = 1.3127 ms).

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
