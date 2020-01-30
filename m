Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:58531 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726397AbgA3IC3 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 30 Jan 2020 03:02:29 -0500
Date: Thu, 30 Jan 2020 09:02:03 +0100
From: Jesper Dangaard Brouer <jbrouer@redhat.com>
Subject: Re: xdpsock ... -N -z and AF_XDP XDP_ZEROCOPY not working:
 RESOLVED!
Message-ID: <20200130090203.71b475a0@carbon>
In-Reply-To: <c45f64a7-ffff-a123-818c-4dc127cd3ff4@gmail.com>
References: <CAMyc9bVpR9thvVsa-LWNg6BPwkqNcL-W-FuEXdfXgGxCUUn3jA@mail.gmail.com>
        <c45f64a7-ffff-a123-818c-4dc127cd3ff4@gmail.com>
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: David Ahern <dsahern@gmail.com>
Cc: Cameron Elliott <cameron@cameronelliott.com>, Xdp <xdp-newbies@vger.kernel.org>, Magnus Karlsson <magnus.karlsson@gmail.com>

On Wed, 29 Jan 2020 21:41:57 -0700
David Ahern <dsahern@gmail.com> wrote:

> On 1/29/20 6:02 PM, Cameron Elliott wrote:
> > With this command:
> > git clone git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git
> > More info: https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/
> > 
> > I built the kernel using these directions:
> > https://wiki.ubuntu.com/KernelTeam/GitKernelBuild
> > 
> > And after rebooting and running on the 5.5 bpf-next kernel, -z and
> > XDP_ZEROCOPY were working fine!  
> 
> since this is literally bleeding edge, is there a wiki/doc/other for
> kernel versions and supported features? Something similar to what MLX
> does for switchdev [1] would be really helpful.
> 
> [1] https://github.com/Mellanox/mlxsw/wiki

The IOvisor BCC project tries to keep track of kernel version and BPF +
XDP features, here[2]:

[2] https://github.com/iovisor/bcc/blob/master/docs/kernel-versions.md 

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
