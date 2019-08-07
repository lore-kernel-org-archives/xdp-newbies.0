Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pl1-f193.google.com ([209.85.214.193]:44068 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388204AbfHGRwr (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Wed, 7 Aug 2019 13:52:47 -0400
Subject: Re: [bpf-next PATCH 2/3] samples/bpf: make xdp_fwd more practically
 usable via devmap lookup
References: <156518133219.5636.728822418668658886.stgit@firesoul>
 <156518138310.5636.13064696265479533742.stgit@firesoul>
From: David Ahern <dsahern@gmail.com>
Message-ID: <2162ceb3-9c2d-1294-7083-ef80b8df139c@gmail.com>
Date: Wed, 7 Aug 2019 11:52:44 -0600
MIME-Version: 1.0
In-Reply-To: <156518138310.5636.13064696265479533742.stgit@firesoul>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org, Daniel Borkmann <borkmann@iogearbox.net>, Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: xdp-newbies@vger.kernel.org, a.s.protopopov@gmail.com

On 8/7/19 6:36 AM, Jesper Dangaard Brouer wrote:
> This address the TODO in samples/bpf/xdp_fwd_kern.c, which points out
> that the chosen egress index should be checked for existence in the
> devmap. This can now be done via taking advantage of Toke's work in
> commit 0cdbb4b09a06 ("devmap: Allow map lookups from eBPF").
> 
> This change makes xdp_fwd more practically usable, as this allows for
> a mixed environment, where IP-forwarding fallback to network stack, if
> the egress device isn't configured to use XDP.
> 
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>  samples/bpf/xdp_fwd_kern.c |   20 ++++++++++++++------
>  samples/bpf/xdp_fwd_user.c |   36 +++++++++++++++++++++++++-----------
>  2 files changed, 39 insertions(+), 17 deletions(-)
> 
Reviewed-by: David Ahern <dsahern@gmail.com>
