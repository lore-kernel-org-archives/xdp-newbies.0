Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-lj1-f195.google.com ([209.85.208.195]:42461 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727558AbfHNPJl (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 14 Aug 2019 11:09:41 -0400
Received: by mail-lj1-f195.google.com with SMTP id l14so2453432ljj.9
        for <xdp-newbies@vger.kernel.org>; Wed, 14 Aug 2019 08:09:39 -0700 (PDT)
Date: Wed, 14 Aug 2019 18:09:36 +0300
From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: Re: [PATCH v2 bpf-next] mm: mmap: increase sockets maximum memory
 size pgoff for 32bits
Message-ID: <20190814150934.GD4142@khorivan>
References: <20190812113429.2488-1-ivan.khoronzhuk@linaro.org>
 <20190812124326.32146-1-ivan.khoronzhuk@linaro.org>
 <20190812141924.32136e040904d0c5a819dcb1@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190812141924.32136e040904d0c5a819dcb1@linux-foundation.org>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: bjorn.topel@intel.com, linux-mm@kvack.org, xdp-newbies@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org, linux-kernel@vger.kernel.org, ast@kernel.org, magnus.karlsson@intel.com

On Mon, Aug 12, 2019 at 02:19:24PM -0700, Andrew Morton wrote:

Hi, Andrew

>On Mon, 12 Aug 2019 15:43:26 +0300 Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> wrote:
>
>> The AF_XDP sockets umem mapping interface uses XDP_UMEM_PGOFF_FILL_RING
>> and XDP_UMEM_PGOFF_COMPLETION_RING offsets. The offsets seems like are
>> established already and are part of configuration interface.
>>
>> But for 32-bit systems, while AF_XDP socket configuration, the values
>> are to large to pass maximum allowed file size verification.
>> The offsets can be tuned ofc, but instead of changing existent
>> interface - extend max allowed file size for sockets.
>
>
>What are the implications of this?  That all code in the kernel which
>handles mapped sockets needs to be audited (and tested) for correctly
>handling mappings larger than 4G on 32-bit machines?  Has that been

That's to allow only offset to be passed, mapping length is less than 4Gb.
I have verified all list of mmap for sockets and all of them contain dummy
cb sock_no_mmap() except the following:

xsk_mmap()
tcp_mmap()
packet_mmap()

xsk_mmap() - it's what this fix is needed for.
tcp_mmap() - doesn't have obvious issues with pgoff - no any references on it.
packet_mmap() - return -EINVAL if it's even set.


>done?  Are we confident that we aren't introducing user-visible buggy
>behaviour into unsuspecting legacy code?
>
>Also...  what are the user-visible runtime effects of this change?
>Please send along a paragraph which explains this, for the changelog.
>Does this patch fix some user-visible problem?  If so, should be code
>be backported into -stable kernels?
It should go to linux-next, no one has been using it till this patch
with 32 bits as w/o this fix af_xdp sockets can't be used at all.
It unblocks af_xdp socket usage for 32bit systems.


That's example of potential next commit message:
Subject: mm: mmap: increase sockets maximum memory size pgoff for 32bits

The AF_XDP sockets umem mapping interface uses XDP_UMEM_PGOFF_FILL_RING
and XDP_UMEM_PGOFF_COMPLETION_RING offsets.  These offsets are established
already and are part of the configuration interface.

But for 32-bit systems, using AF_XDP socket configuration, these values
are too large to pass the maximum allowed file size verification.  The
offsets can be tuned off, but instead of changing the existing interface,
let's extend the max allowed file size for sockets.

No one has been using it till this patch with 32 bits as w/o this fix
af_xdp sockets can't be used at all, so it unblocks af_xdp socket usage
for 32bit systems.

All list of mmap cbs for sockets were verified on side effects and
all of them contain dummy cb - sock_no_mmap() at this moment, except the
following:

xsk_mmap() - it's what this fix is needed for.
tcp_mmap() - doesn't have obvious issues with pgoff - no any references on it.
packet_mmap() - return -EINVAL if it's even set.




Is it ok to be replicated in PATCH v2 or this explanation is enough here
to use v1?

-- 
Regards,
Ivan Khoronzhuk
