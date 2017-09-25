Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53900 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932404AbdIYJZM (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 25 Sep 2017 05:25:12 -0400
Date: Mon, 25 Sep 2017 11:25:02 +0200
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: libbpf missing set_link_xdp_fd ?
Message-ID: <20170925112502.1879734a@redhat.com>
In-Reply-To: <1506276431.21618.2.camel@regit.org>
References: <1506276431.21618.2.camel@regit.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Eric Leblond <eric@regit.org>
Cc: xdp-newbies@vger.kernel.org, brouer@redhat.com, wangnan0@huawei.com, Daniel Borkmann <borkmann@iogearbox.net>, Alexei Starovoitov <alexei.starovoitov@gmail.com>

On Sun, 24 Sep 2017 20:07:11 +0200
Eric Leblond <eric@regit.org> wrote:

> Hello,
> 
> bpf_load is implementing the set_link_xdp_fd() function and it seems
> this function is not available in libbpf.

I also ran into this problem, when I wanted to switch my XDP programs
into using tools/lib/bpf/.

E.g.: https://github.com/netoptimizer/prototype-kernel/commit/5397e596c30416763

> Should it be the case or should it be part of another library ?

I'm not sure... maybe Alexei, Daniel or Wang have an opinion?

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
