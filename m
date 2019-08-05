Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([23.128.96.9]:60310 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728701AbfHESTH (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Mon, 5 Aug 2019 14:19:07 -0400
Date: Mon, 05 Aug 2019 11:19:06 -0700 (PDT)
Message-Id: <20190805.111906.1380210569649795922.davem@davemloft.net>
Subject: Re: [net v1 PATCH 0/4] net: fix regressions for generic-XDP
From: David Miller <davem@davemloft.net>
In-Reply-To: <156468229108.27559.2443904494495785131.stgit@firesoul>
References: <20190731211211.GA87084@multapplied.net>
        <156468229108.27559.2443904494495785131.stgit@firesoul>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: brouer@redhat.com
Cc: netdev@vger.kernel.org, xdp-newbies@vger.kernel.org, borkmann@iogearbox.net, brandon.cazander@multapplied.net, alexei.starovoitov@gmail.com

From: Jesper Dangaard Brouer <brouer@redhat.com>
Date: Thu, 01 Aug 2019 20:00:11 +0200

> Thanks to Brandon Cazander, who wrote a very detailed bug report that
> even used perf probe's on xdp-newbies mailing list, we discovered that
> generic-XDP contains some regressions when using bpf_xdp_adjust_head().
> 
> First issue were that my selftests script, that use bpf_xdp_adjust_head(),
> by mistake didn't use generic-XDP any-longer. That selftest should have
> caught the real regression introduced in commit 458bf2f224f0 ("net: core:
> support XDP generic on stacked devices.").
> 
> To verify this patchset fix the regressions, you can invoked manually via:
> 
>   cd tools/testing/selftests/bpf/
>   sudo ./test_xdp_vlan_mode_generic.sh
>   sudo ./test_xdp_vlan_mode_native.sh
> 
> Link: https://www.spinics.net/lists/xdp-newbies/msg01231.html
> Fixes: 458bf2f224f0 ("net: core: support XDP generic on stacked devices.")
> Reported by: Brandon Cazander <brandon.cazander@multapplied.net>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>

Series applied and queued up for -stable, thanks.
