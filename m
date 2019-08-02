Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qt1-f193.google.com ([209.85.160.193]:34888 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732712AbfHBAoZ (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Thu, 1 Aug 2019 20:44:25 -0400
Received: by mail-qt1-f193.google.com with SMTP id d23so72296356qto.2
        for <xdp-newbies@vger.kernel.org>; Thu, 01 Aug 2019 17:44:24 -0700 (PDT)
Date: Thu, 1 Aug 2019 17:44:06 -0700
From: Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: Re: [net v1 PATCH 4/4] net: fix bpf_xdp_adjust_head regression for
 generic-XDP
Message-ID: <20190801174406.0b554bb9@cakuba.netronome.com>
In-Reply-To: <156468243184.27559.7002090473019021952.stgit@firesoul>
References: <156468229108.27559.2443904494495785131.stgit@firesoul>
        <156468243184.27559.7002090473019021952.stgit@firesoul>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, xdp-newbies@vger.kernel.org, Daniel Borkmann <borkmann@iogearbox.net>, brandon.cazander@multapplied.net, Alexei Starovoitov <alexei.starovoitov@gmail.com>

On Thu, 01 Aug 2019 20:00:31 +0200, Jesper Dangaard Brouer wrote:
> When generic-XDP was moved to a later processing step by commit
> 458bf2f224f0 ("net: core: support XDP generic on stacked devices.")
> a regression was introduced when using bpf_xdp_adjust_head.
> 
> The issue is that after this commit the skb->network_header is now
> changed prior to calling generic XDP and not after. Thus, if the header
> is changed by XDP (via bpf_xdp_adjust_head), then skb->network_header
> also need to be updated again.  Fix by calling skb_reset_network_header().
> 
> Fixes: 458bf2f224f0 ("net: core: support XDP generic on stacked devices.")
> Reported-by: Brandon Cazander <brandon.cazander@multapplied.net>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>

Out of curiosity what was your conclusion regarding resetting the
transport header as well?
