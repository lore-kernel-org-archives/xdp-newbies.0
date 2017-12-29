Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:44625 "EHLO
        mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754164AbdL2Eec (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 28 Dec 2017 23:34:32 -0500
Received: by mail-pf0-f172.google.com with SMTP id m26so21726052pfj.11
        for <xdp-newbies@vger.kernel.org>; Thu, 28 Dec 2017 20:34:31 -0800 (PST)
Subject: Re: IP forwarding and eBPF
References: <CAM7NYTiM2CtPPm4u3Rr9G0zRZrpmZq_3Rcb0H3dyS1xFZ+LzMA@mail.gmail.com>
From: David Ahern <dsahern@gmail.com>
Message-ID: <cc903869-4a06-6038-d17d-42daf3362969@gmail.com>
Date: Thu, 28 Dec 2017 22:34:24 -0600
MIME-Version: 1.0
In-Reply-To: <CAM7NYTiM2CtPPm4u3Rr9G0zRZrpmZq_3Rcb0H3dyS1xFZ+LzMA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: "MD I. Islam" <tamim@csebuet.org>, xdp-newbies@vger.kernel.org

On 12/28/17 9:37 PM, MD I. Islam wrote:
> Hi
> 
> Is XDP designed for implementing packet forwarding? Is there an
> example of ipv4 forwarding the kernel? I don't find any example in
> samples/bpf/ directory.

samples/bpf/xdp_router_ipv4_*.c

I have a POC on using new helpers that allow BPF programs to leverage
kernel FIB and neighbor tables:
   https://github.com/dsahern/linux/commits/bpf/xdp-fwding-wip

It shows a 400% increase in forwarding. A lot of issues need to be
addressed, but it shows the intent.
