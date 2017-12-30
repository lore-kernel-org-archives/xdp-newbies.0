Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:46454 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750841AbdL3KrZ (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Sat, 30 Dec 2017 05:47:25 -0500
Message-ID: <1514630841.12303.5.camel@regit.org>
Subject: Re: Running samples/bpf/xdp1 as root gives me EPERM !?
From: Eric Leblond <eric@regit.org>
Date: Sat, 30 Dec 2017 11:47:21 +0100
In-Reply-To: <CAFg6RxseDm=-ofyYmvuOYwY01d8XAuw92tO4MHqGHcekC1Q2Tw@mail.gmail.com>
References: <CAFg6RxseDm=-ofyYmvuOYwY01d8XAuw92tO4MHqGHcekC1Q2Tw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Rob Sherwood <rob.sherwood@gmail.com>, xdp-newbies@vger.kernel.org

Hi,

On Sat, 2017-12-30 at 03:34 -0500, Rob Sherwood wrote:
> Hi,
> 
> I'm running stock Ubuntu 17.10 on two roughly identical boxes (4.13.0
> kernel) and am trying to verify that my setup works by running the
> xdp1 example code that ships with the default kernel code
> (./samples/bpf/xdp1_{user,kern}.c).
> 
> On one box (a bare metal server), the code works as expected.  But on
> the other box (a virtual machine), any of the bpf system calls return
> EPERM even though I'm running as root:

...

> 
> I've even made sure that I can use promiscuous mode on the virtual
> machine (this requires extra permissions from the hypervisor), so
> that's not the problem.  The problem persists even if I try to attach
> the xdp code to a pure virtual interface (e.g., a veth pair).
> 
> Any one have any guess what the problem could be?

Could it be a memlock limit issue ? Can you try something like
ulimit  -l 100000000 to see if it fixes the problem ?

BR,
-- 
Eric Leblond <eric@regit.org>
Blog: https://home.regit.org/
