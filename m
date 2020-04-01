Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:41762 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726335AbgDAJz2 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 1 Apr 2020 05:55:28 -0400
Date: Wed, 1 Apr 2020 11:55:12 +0200
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: Using AF_XDP To Modify Outgoing Packets
Message-ID: <20200401115512.4b28f975@carbon>
In-Reply-To: <8013b38c-696c-cadd-a4cd-756eca658215@gflclan.com>
References: <7902d2f1-1c21-f3e8-5035-352bba130d50@gflclan.com>
        <20200330111048.1167e6f4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <dd0d11d8-29ff-18c5-85b2-d566d2bba2ea@gflclan.com>
        <87sghoj2jf.fsf@toke.dk>
        <8013b38c-696c-cadd-a4cd-756eca658215@gflclan.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Christian Deacon <gamemann@gflclan.com>
Cc: brouer@redhat.com, Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>, xdp-newbies@vger.kernel.org

On Tue, 31 Mar 2020 18:22:53 -0500
Christian Deacon <gamemann@gflclan.com> wrote:

> After looking into the TC Hook, it looks like this will work for my 
> case. I'll try to get a program made in the next few days or so.

If you want code examples of TC egress hook with BPF look at[1]:
 [1] https://github.com/xdp-project/xdp-cpumap-tc/

Notice that map pinning with libbpf have gotten easier (thanks to
Toke). This example does work (runs in production), it shares and reuse
maps between XDP and TC-bpf.  The example uses the old way to define
maps, and I recommend switching to the new BTF-based syntax instead
(requires LLVM 10), which defines ".maps" SEC, see example[2], and
notice "pinning" option, which obsoletes a lot of the map code in[1].

Attaching TC-bpf progs are different that XDP.  I've hidden the detail
in C-code function tc_egress_attach_bpf() (see[3]), which actually just
calls the "tc" command.  I was hoping that this would be replaced with a
libbpf call, like we have for XDP, but that have not happened.


[2] https://github.com/xdp-project/xdp-tools/blob/master/xdp-filter/xdpfilt_prog.h#L124-L131
[3] https://github.com/xdp-project/xdp-cpumap-tc/blob/master/src/common_user.c#L386
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

google keywords: tc qdisc clsact cls_bpf egress filter
