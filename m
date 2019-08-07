Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pl1-f194.google.com ([209.85.214.194]:40382 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729278AbfHGRwh (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Wed, 7 Aug 2019 13:52:37 -0400
Subject: Re: [bpf-next PATCH 1/3] samples/bpf: xdp_fwd rename devmap name to
 be xdp_tx_ports
References: <156518133219.5636.728822418668658886.stgit@firesoul>
 <156518137803.5636.11766023213864836956.stgit@firesoul>
From: David Ahern <dsahern@gmail.com>
Message-ID: <3d687330-8689-2974-8ed0-7bcb61038c80@gmail.com>
Date: Wed, 7 Aug 2019 11:52:33 -0600
MIME-Version: 1.0
In-Reply-To: <156518137803.5636.11766023213864836956.stgit@firesoul>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org, Daniel Borkmann <borkmann@iogearbox.net>, Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: xdp-newbies@vger.kernel.org, a.s.protopopov@gmail.com

On 8/7/19 6:36 AM, Jesper Dangaard Brouer wrote:
> The devmap name 'tx_port' came from a copy-paste from xdp_redirect_map
> which only have a single TX port. Change name to xdp_tx_ports
> to make it more descriptive.
> 
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>  samples/bpf/xdp_fwd_kern.c |    5 +++--
>  samples/bpf/xdp_fwd_user.c |    2 +-
>  2 files changed, 4 insertions(+), 3 deletions(-)
> 
Reviewed-by: David Ahern <dsahern@gmail.com>
