Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-ot1-f65.google.com ([209.85.210.65]:36623 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388207AbfHGSGK (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Wed, 7 Aug 2019 14:06:10 -0400
MIME-Version: 1.0
References: <156518133219.5636.728822418668658886.stgit@firesoul> <156518138817.5636.3626699603179533211.stgit@firesoul>
In-Reply-To: <156518138817.5636.3626699603179533211.stgit@firesoul>
From: Y Song <ys114321@gmail.com>
Date: Wed, 7 Aug 2019 11:05:33 -0700
Message-ID: <CAH3MdRV+LUuKpbUJFzqFrodEDbfm5aif+qmzWsUJYSFGQyCMow@mail.gmail.com>
Subject: Re: [bpf-next PATCH 3/3] samples/bpf: xdp_fwd explain bpf_fib_lookup
 return codes
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: netdev <netdev@vger.kernel.org>, Daniel Borkmann <borkmann@iogearbox.net>, Alexei Starovoitov <alexei.starovoitov@gmail.com>, Xdp <xdp-newbies@vger.kernel.org>, a.s.protopopov@gmail.com, David Ahern <dsahern@gmail.com>

On Wed, Aug 7, 2019 at 5:38 AM Jesper Dangaard Brouer <brouer@redhat.com> wrote:
>
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

Acked-by: Yonghong Song <yhs@fb.com>
