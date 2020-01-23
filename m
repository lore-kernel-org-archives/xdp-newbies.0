Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:55323 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726232AbgAWNLc (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 23 Jan 2020 08:11:32 -0500
Date: Thu, 23 Jan 2020 14:11:22 +0100
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: Measuring/Debugging XDP Performance
Message-ID: <20200123141122.3783e298@carbon>
In-Reply-To: <6c3dc8ff-e2bd-a06e-d9f0-c5be0103d266@gflclan.com>
References: <6c3dc8ff-e2bd-a06e-d9f0-c5be0103d266@gflclan.com>
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: Christian Deacon <gamemann@gflclan.com>
Cc: brouer@redhat.com, xdp-newbies@vger.kernel.org

On Wed, 22 Jan 2020 12:02:23 -0600
Christian Deacon <gamemann@gflclan.com> wrote:

> Hey everyone,
> 
> I am new to XDP + AF_XDP (along with C programming in general), but I am 
> very interested in it and I've been learning a lot recently. I own an 
> Anycast network and our POP servers are running custom software our 
> developer created that processes packets using XDP. This software 
> basically forwards specific traffic to another machine via an IPIP 
> tunnel.

Why are you using AF_XDP to implement a simple IPIP tunnel header?

You can easily implement it in BPF.
Example here:
 https://github.com/torvalds/linux/blob/master/samples/bpf/xdp_tx_iptunnel_kern.c#L110-L112
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
