Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:34476 "EHLO
        mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932348AbdLOQ4b (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 15 Dec 2017 11:56:31 -0500
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (1.0)
Subject: Re: ixgbe tuning reset when XDP is setup
From: Peter Manev <petermanev@gmail.com>
In-Reply-To: <CAKgT0UeFUnYdvNZZAzFibYm6JXccyv+9q3=5j1AsAe9Z9bGhjw@mail.gmail.com>
Date: Fri, 15 Dec 2017 17:56:27 +0100
Message-Id: <F765740A-B847-4EE5-8BFD-3130F64E6116@gmail.com>
References: <1513333486.28703.9.camel@regit.org> <20171215.105338.2092740911243038177.davem@davemloft.net> <c677440b-46c5-e32b-5038-21a760ba738b@gmail.com> <CAKgT0UeFUnYdvNZZAzFibYm6JXccyv+9q3=5j1AsAe9Z9bGhjw@mail.gmail.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: Alexander Duyck <alexander.duyck@gmail.com>
Cc: John Fastabend <john.fastabend@gmail.com>, David Miller <davem@davemloft.net>, eric@regit.org, Netdev <netdev@vger.kernel.org>, xdp-newbies@vger.kernel.org, Emil Tantilov <emil.s.tantilov@intel.com>


> On 15 Dec 2017, at 17:51, Alexander Duyck <alexander.duyck@gmail.com> wrote:
> 
> On Fri, Dec 15, 2017 at 8:03 AM, John Fastabend
> <john.fastabend@gmail.com> wrote:
>> On 12/15/2017 07:53 AM, David Miller wrote:
>>> From: Eric Leblond <eric@regit.org>
>>> Date: Fri, 15 Dec 2017 11:24:46 +0100
>>> 
>>>> Hello,
>>>> 
>>>> When using an ixgbe card with Suricata we are using the following
>>>> commands to get a symmetric hash on RSS load balancing:
>>>> 
>>>> ./set_irq_affinity 0-15 eth3
>>>> ethtool -X eth3 hkey 6D:5A:6D:5A:6D:5A:6D:5A:6D:5A:6D:5A:6D:5A:6D:5A:6D:5A:6D:5A:6D:5A:6D:5A:6D:5A:6D:5A:6D:5A:6D:5A:6D:5A:6D:5A:6D:5A:6D:5A equal 16
>>>> ethtool -x eth3
>>>> ethtool -n eth3
>>>> 
>>>> Then we start Suricata.
>>>> 
>>>> In my current experiment on XDP, I have Suricata that inject the eBPF
>>>> program when starting. The consequence of that when using an ixgbe card
>>>> is that the load balancing get reset and all interrupts are reaching
>>>> the first core.
>>> 
>>> This definitely should _not_ be a side effect of enabling XDP on a device.
>>> 
>> 
>> Agreed, CC Emil and Alex we should restore these settings after the
>> reconfiguration done to support a queue per core.
>> 
>> .John
> 
> So the interrupt configuration has to get reset since we have to
> assign 2 Tx queues for every Rx queue instead of the 1-1 that was
> previously there. That is a natural consequence of rearranging the
> queues as currently happens. The issue is the q_vectors themselves
> have to be reallocated. The only way to not make that happen would be
> to pre-allocate the Tx queues for XDP always.
> 
> Also just to be clear we are talking about the interrupts being reset,
> not the RSS key right? I just want to make sure that is what we are
> talking about.
> 

Yes.
From the tests we did I only observed the IRQs being all reset to the first CPU after Suricata started.



> Thanks.
> 
> - Alex
