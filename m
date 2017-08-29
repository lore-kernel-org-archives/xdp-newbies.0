Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:42274 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751272AbdH2XhY (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 29 Aug 2017 19:37:24 -0400
Message-ID: <59A5FAAE.1050507@iogearbox.net>
Date: Wed, 30 Aug 2017 01:37:18 +0200
From: Daniel Borkmann <daniel@iogearbox.net>
MIME-Version: 1.0
Subject: Re: What library to use ?
References: <1503234237.13034.9.camel@regit.org>                <599A11B8.9030906@iogearbox.net> <20170821101600.4e769785@redhat.com>    <599B5757.9050107@iogearbox.net> <1503686114.19844.5.camel@regit.org>
In-Reply-To: <1503686114.19844.5.camel@regit.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Eric Leblond <eric@regit.org>, Jesper Dangaard Brouer <brouer@redhat.com>
Cc: xdp-newbies@vger.kernel.org, pavel.odintsov@gmail.com

On 08/25/2017 08:35 PM, Eric Leblond wrote:
[...]
> OK, this looks like what we were already doing in Suricata so it should
> be ok. If I get correctly the design, we will have a per CPU load
> balancing. The CPU reading the packet will send data to his own ring
> buffer via the bpf_perf_event_output that don't take any CPU related
> parameters. As we are really early in the processing, this means that

Yeah, if you look at __bpf_perf_event_output(), it's basically
the event->oncpu != cpu which would otherwise let it bail out,
but needed iiuc to ensure the RB can be written w/o having to
take locks. The CPU related 'parameter' is basically set up by
the 'orchestrator'. You have the perf event map, and given at
which index you place the corresponding perf fd, you can either
use BPF_F_CURRENT_CPU if the mapping is 1:1 (cpu -> perf fd set
up for this cpu) or a custom index if you have a use case where
you need to demux to one of multiple perf RBs for that CPU.

> the per-CPU load balancing will be done by the card.

Right given you need to have the replies steered into the same
perf RB 'channel' for further processing.
