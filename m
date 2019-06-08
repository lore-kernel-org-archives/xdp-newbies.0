Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pf1-f181.google.com ([209.85.210.181]:34962 "EHLO
        mail-pf1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727539AbfFHVTz (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Sat, 8 Jun 2019 17:19:55 -0400
Received: by mail-pf1-f181.google.com with SMTP id d126so3102924pfd.2
        for <xdp-newbies@vger.kernel.org>; Sat, 08 Jun 2019 14:19:54 -0700 (PDT)
Date: Sat, 8 Jun 2019 14:19:48 -0700
From: Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: Re: AF_XDP with QoS support question
Message-ID: <20190608141948.65e77b75@cakuba.netronome.com>
In-Reply-To: <CALDO+SZ_y2crYSXGtFxQtk8zZz2X=Fr-rJTPr_zm6rbtD8h9iQ@mail.gmail.com>
References: <CALDO+SZ_y2crYSXGtFxQtk8zZz2X=Fr-rJTPr_zm6rbtD8h9iQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: William Tu <u9012063@gmail.com>
Cc: Xdp <xdp-newbies@vger.kernel.org>, "<dev@openvswitch.org>" <dev@openvswitch.org>

On Fri, 7 Jun 2019 19:55:34 -0700, William Tu wrote:
> Hi,
> 
> When using AF_XDP, the TC qdisc layer is by-passed and packets go to
> userspace directly. One problem is that there is no QoS support when
> using AF_XDP.
> 
> For egress shaping, I'm thinking about using tc-mqprio, which has
> hardware offload support. And for OVS, we can add tc-mqprio support.

What is your end game?  Once upon the time Simon was explaining the QoS
stuff in OvS to me, but IIRC it used CBQ and/or HTB.  The XDP TX queues
are not exposed to the stack, so we can't set per-queue QoS, setting a
root Qdisc (like mqprio) and expecting the XDP queues to have the same
settings would be very limiting (then again even with mqprio IDK how
you'd select the prio? by using the TX queue ID? hm..).

> For ingress policing, I don't know how to do it. Is there an hardware
> offload ingress policing support?

There is support for act_police in a couple drivers.  Although using it
per queue could be a challenge...  (At least we do have a real queue ID
on the RX, hopefully the mlx5 fake queues never get merged.)
