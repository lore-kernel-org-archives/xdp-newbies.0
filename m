Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726507AbgD0Ktr (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 27 Apr 2020 06:49:47 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5759FC0610D5
        for <xdp-newbies@vger.kernel.org>; Mon, 27 Apr 2020 03:49:46 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id q7so5344329qkf.3
        for <xdp-newbies@vger.kernel.org>; Mon, 27 Apr 2020 03:49:46 -0700 (PDT)
Date: Mon, 27 Apr 2020 06:49:38 -0400
From: Sowmini Varadhan <sowmini05@gmail.com>
Subject: Re: building eBPF
Message-ID: <20200427104938.GF488@gmail.com>
References: <20200425122225.GA455@gmail.com>
 <20200425145619.4405a50d@carbon>
 <20200427002027.GE488@gmail.com>
 <20200427120333.7e6cedfc@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200427120333.7e6cedfc@carbon>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>, Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>



> The iproute2 BPF-loader does not support BTF.  I think upstream agrees
> that it would be too much work to add (and maintain) it, so the current
> plan[1] is to convert iproute2 to use libbpf instead.

So I updated my iproute2 because I was initially getting an error like

" Error fixing up map structure, incompatible struct bpf_elf_map used?
  Error fetching ELF ancillary data!
  Unable to load program
"
with the native iproute2 binaries, and thought it may be due to
a header mismatch.

> Why do you want to use 'tc' to load XDP?

I was merely using the exsiting example in samples to try to understand
this. If the existing example is misleading, it should be removed.

> I actually think this is only a warning, and the program is actually
> loaded...

no I dont believe it is. if you insert a break in the script before
it gets to cleanup, and try

   # ip netns exec ns2 bash
   # tc filter show dev vens2

it will not show any loaded filters.

--Sowmini
