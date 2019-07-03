Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:53904 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726675AbfGCPFa (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Wed, 3 Jul 2019 11:05:30 -0400
Subject: Re: [PATCH bpf v6 0/2] xdp: fix hang while unregistering device bound
 to xdp socket
References: <CGME20190628080413eucas1p13f3400f657b4827414737af42f02a57b@eucas1p1.samsung.com>
 <20190628080407.30354-1-i.maximets@samsung.com>
From: Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <ae128ab7-0983-921e-7e56-7f42cb419113@iogearbox.net>
Date: Wed, 3 Jul 2019 17:05:08 +0200
MIME-Version: 1.0
In-Reply-To: <20190628080407.30354-1-i.maximets@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Ilya Maximets <i.maximets@samsung.com>, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, bpf@vger.kernel.org, xdp-newbies@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>, Magnus Karlsson <magnus.karlsson@intel.com>, Jonathan Lemon <jonathan.lemon@gmail.com>, Jakub Kicinski <jakub.kicinski@netronome.com>

On 06/28/2019 10:04 AM, Ilya Maximets wrote:
> Version 6:
> 
>     * Better names for socket state.
> 
> Version 5:
> 
>     * Fixed incorrect handling of rtnl_lock.
> 
> Version 4:
> 
>     * 'xdp_umem_clear_dev' exposed to be used while unregistering.
>     * Added XDP socket state to track if resources already unbinded.
>     * Splitted in two fixes.
> 
> Version 3:
> 
>     * Declaration lines ordered from longest to shortest.
>     * Checking of event type moved to the top to avoid unnecessary
>       locking.
> 
> Version 2:
> 
>     * Completely re-implemented using netdev event handler.
> 
> Ilya Maximets (2):
>   xdp: hold device for umem regardless of zero-copy mode
>   xdp: fix hang while unregistering device bound to xdp socket
> 
>  include/net/xdp_sock.h |  5 +++
>  net/xdp/xdp_umem.c     | 21 +++++-----
>  net/xdp/xdp_umem.h     |  1 +
>  net/xdp/xsk.c          | 87 ++++++++++++++++++++++++++++++++++++------
>  4 files changed, 93 insertions(+), 21 deletions(-)
> 

Applied, thanks!
