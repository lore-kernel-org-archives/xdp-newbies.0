Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:34494 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726504AbgD0MIf (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 27 Apr 2020 08:08:35 -0400
Subject: Re: building eBPF
References: <20200425122225.GA455@gmail.com> <20200425145619.4405a50d@carbon>
 <20200427002027.GE488@gmail.com> <20200427120333.7e6cedfc@carbon>
 <20200427104938.GF488@gmail.com>
From: Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <20d8acad-c8d4-a67b-5bc8-03e9c5b729ed@iogearbox.net>
Date: Mon, 27 Apr 2020 14:08:31 +0200
MIME-Version: 1.0
In-Reply-To: <20200427104938.GF488@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Sowmini Varadhan <sowmini05@gmail.com>, Jesper Dangaard Brouer <brouer@redhat.com>
Cc: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>, =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>

On 4/27/20 12:49 PM, Sowmini Varadhan wrote:
> 
>> The iproute2 BPF-loader does not support BTF.  I think upstream agrees
>> that it would be too much work to add (and maintain) it, so the current
>> plan[1] is to convert iproute2 to use libbpf instead.

Not true, iproute2 does(did) support BTF, but afaik later versions of clang/
llvm broke it so it would need to be fixed again [0]. Emission of BTF can be
removed as a workaround w/ omitting -g.

   [0] https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=f823f36012fb5ab4ddfca6ed4ff56188730f281e

> So I updated my iproute2 because I was initially getting an error like
> 
> " Error fixing up map structure, incompatible struct bpf_elf_map used?
>    Error fetching ELF ancillary data!
>    Unable to load program
> "
> with the native iproute2 binaries, and thought it may be due to
> a header mismatch.
> 
>> Why do you want to use 'tc' to load XDP?
> 
> I was merely using the exsiting example in samples to try to understand
> this. If the existing example is misleading, it should be removed.
> 
>> I actually think this is only a warning, and the program is actually
>> loaded...
> 
> no I dont believe it is. if you insert a break in the script before
> it gets to cleanup, and try
> 
>     # ip netns exec ns2 bash
>     # tc filter show dev vens2
> 
> it will not show any loaded filters.

Check out https://cilium.readthedocs.io/en/latest/bpf/#iproute2 for XDP + iproute2
examples examples for where to check; but agree you might rather want to go with
libbpf's feature set overall.

> --Sowmini
> 
