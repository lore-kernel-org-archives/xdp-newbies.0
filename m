Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-ot1-f66.google.com ([209.85.210.66]:42493 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729278AbfHGRwy (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Wed, 7 Aug 2019 13:52:54 -0400
MIME-Version: 1.0
References: <156518133219.5636.728822418668658886.stgit@firesoul> <156518137803.5636.11766023213864836956.stgit@firesoul>
In-Reply-To: <156518137803.5636.11766023213864836956.stgit@firesoul>
From: Y Song <ys114321@gmail.com>
Date: Wed, 7 Aug 2019 10:52:17 -0700
Message-ID: <CAH3MdRVXYjfTHcCrhTYmt1hjN21bdL=OquOtfuw-+5cvaJ4_Rw@mail.gmail.com>
Subject: Re: [bpf-next PATCH 1/3] samples/bpf: xdp_fwd rename devmap name to
 be xdp_tx_ports
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: netdev <netdev@vger.kernel.org>, Daniel Borkmann <borkmann@iogearbox.net>, Alexei Starovoitov <alexei.starovoitov@gmail.com>, Xdp <xdp-newbies@vger.kernel.org>, a.s.protopopov@gmail.com, David Ahern <dsahern@gmail.com>

On Wed, Aug 7, 2019 at 5:37 AM Jesper Dangaard Brouer <brouer@redhat.com> wrote:
>
> The devmap name 'tx_port' came from a copy-paste from xdp_redirect_map
> which only have a single TX port. Change name to xdp_tx_ports
> to make it more descriptive.
>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>

Acked-by: Yonghong Song <yhs@fb.com>
