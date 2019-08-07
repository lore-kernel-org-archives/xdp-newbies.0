Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pl1-f196.google.com ([209.85.214.196]:34214 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387952AbfHGRw7 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Wed, 7 Aug 2019 13:52:59 -0400
Subject: Re: [bpf-next PATCH 3/3] samples/bpf: xdp_fwd explain bpf_fib_lookup
 return codes
References: <156518133219.5636.728822418668658886.stgit@firesoul>
 <156518138817.5636.3626699603179533211.stgit@firesoul>
From: David Ahern <dsahern@gmail.com>
Message-ID: <aae3554f-2d55-d2d1-8cd8-2481ca923469@gmail.com>
Date: Wed, 7 Aug 2019 11:52:56 -0600
MIME-Version: 1.0
In-Reply-To: <156518138817.5636.3626699603179533211.stgit@firesoul>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org, Daniel Borkmann <borkmann@iogearbox.net>, Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: xdp-newbies@vger.kernel.org, a.s.protopopov@gmail.com

On 8/7/19 6:36 AM, Jesper Dangaard Brouer wrote:
> Make it clear that this XDP program depend on the network
> stack to do the ARP resolution.  This is connected with the
> BPF_FIB_LKUP_RET_NO_NEIGH return code from bpf_fib_lookup().
> 
> Another common mistake (seen via XDP-tutorial) is that users
> don't realize that sysctl net.ipv{4,6}.conf.all.forwarding
> setting is honored by bpf_fib_lookup.
> 
> Reported-by: Anton Protopopov <a.s.protopopov@gmail.com>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>  samples/bpf/xdp_fwd_kern.c |   19 +++++++++++++++++--
>  1 file changed, 17 insertions(+), 2 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>
