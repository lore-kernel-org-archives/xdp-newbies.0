Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:38684 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727105AbgD1KY0 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 28 Apr 2020 06:24:26 -0400
Received: by mail-lf1-f71.google.com with SMTP id g5so8746614lfh.9
        for <xdp-newbies@vger.kernel.org>; Tue, 28 Apr 2020 03:24:18 -0700 (PDT)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: Difference in TCP throughput in comparison to OVS
In-Reply-To: <BF562847-15D5-471F-8A50-FC38BE92D505@futurewei.com>
References: <BF562847-15D5-471F-8A50-FC38BE92D505@futurewei.com>
Date: Tue, 28 Apr 2020 12:24:14 +0200
Message-ID: <87ees7x60h.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: Phu Tran <phu.tran@futurewei.com>, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>

Phu Tran <phu.tran@futurewei.com> writes:

> Hi,
>
> Following the XDP tutorial on GitHub, we ran some tests comparing the setup from
> the “redirecting packets” section and a basic OVS setup.
> (Specifically packet03-redirecting/Assignment3: Extend to a bidirectional router)
>
> In our test, we collected the numbers below.
> For the OVS setup. we saw TCP throughput at around 90 Gbits/sec.
> For the XDP setup, we saw TCP throughput at around 9 Gbits/sec.
>
> On the OVS side we had the following
> - Two veth devices each assigned to their own unique network namespace.
> - Both veth devices added to an ovs-bridge.
> - iperf2 between the two veth devices.
>
> Similarly, for the XDP setup, we followed the instructions from packet03-redirecting/Assignment3.
> Differences highlighted below:
> - We had to disable rx and tx checksumming to get TCP to work.
> - ethtool --offload veth0 rx off tx off
> - We disabled BPF tracing.
> - iperf2 between the two veth devices.
>
> Questions:
> 1. Why is there a TCP throughput difference between these two setups?

Likely because of the lack of HW checksumming (as you've already
noticed), and TSO (XDP doesn't support superpackets). There's ongoing
work to fix this, though. For large packets, the first step is this
series: https://lore.kernel.org/bpf/87eesd3rvu.fsf@toke.dk/T/ - but a
few more bits are needed before we get all the way to TSO.

> 2. Why do we need to disable rx and tx checksumming?

Because XDP doesn't support it :)

Again, 'yet'. We do want to support this eventually; it's noted here:
https://xdp-project.net/#Metadata-from-hardware

-Toke
