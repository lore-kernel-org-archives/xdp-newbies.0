Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37122 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726172AbeKUV0L (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 21 Nov 2018 16:26:11 -0500
Date: Wed, 21 Nov 2018 11:52:09 +0100
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: qemu-kvm XDP forwarding with virtio_net
Message-ID: <20181121115209.4d186d7c@redhat.com>
In-Reply-To: <CAHOxX0yUuk5rR2iQwYwgWS7+HH-bzZ60VFHw1jo4eAGVkED4pg@mail.gmail.com>
References: <CAHOxX0xFn2RARhnQeJ3m-+8UWrtD-bN2dn8x_FygCfDKdD3oQQ@mail.gmail.com>
        <d69fbde9-c28a-d5be-a667-c54e3c4f52f3@gmail.com>
        <CAHOxX0zjkCczaav6NfPYLu=ivJYoLCJe_L+3krn3-vr+paNdDA@mail.gmail.com>
        <20181120191412.088c68fb@redhat.com>
        <CAHOxX0wxq6+ML1pZymG=EyBi15FQZSdASaJSaSfY4Kc+OvunDQ@mail.gmail.com>
        <CAHOxX0yUuk5rR2iQwYwgWS7+HH-bzZ60VFHw1jo4eAGVkED4pg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Pavel Popa <pashinho1990@gmail.com>
Cc: David Ahern <dsahern@gmail.com>, xdp-newbies@vger.kernel.org, jasowang@redhat.com, brouer@redhat.com, Daniel Borkmann <borkmann@iogearbox.net>

On Wed, 21 Nov 2018 11:01:45 +0100
Pavel Popa <pashinho1990@gmail.com> wrote:

> For what I see, the only way to return -EFAULT is in this case
> https://elixir.bootlin.com/linux/v4.18.10/source/net/core/filter.c#L3259.
> This may explain the "to_ifindex=0" thing, as 'fwd' is initialized
> NULL. But I don't understand the meaning of the
> "xdp_map_invalid(xdp_prog, map_owner)" condition. So, if that's really
> the case, what can be inferred from this?

Are you using BPF-tail calls?

Well that code got removed in kernel 4.19:

 Commit f6069b9aa993 ("bpf: fix redirect to map under tail calls")
 https://git.kernel.org/torvalds/c/f6069b9aa993

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

$ git describe --contains  f6069b9aa993
v4.19-rc1~86^2~6^2
