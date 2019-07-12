Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:50806 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727414AbfGLNHy (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 12 Jul 2019 09:07:54 -0400
Subject: Re: [PATCH bpf] xdp: fix potential deadlock on socket mutex
References: <CGME20190708110350eucas1p16357da1f812ff8309b1edc98d4cdacc1@eucas1p1.samsung.com>
 <20190708110344.23278-1-i.maximets@samsung.com>
From: Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <93462d9f-dc37-fa5a-ae28-d5cad5aa2060@iogearbox.net>
Date: Fri, 12 Jul 2019 15:07:51 +0200
MIME-Version: 1.0
In-Reply-To: <20190708110344.23278-1-i.maximets@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Ilya Maximets <i.maximets@samsung.com>, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, bpf@vger.kernel.org, xdp-newbies@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>, Magnus Karlsson <magnus.karlsson@intel.com>, Jonathan Lemon <jonathan.lemon@gmail.com>, Jakub Kicinski <jakub.kicinski@netronome.com>, Alexei Starovoitov <ast@kernel.org>

On 07/08/2019 01:03 PM, Ilya Maximets wrote:
> There are 2 call chains:
> 
>   a) xsk_bind --> xdp_umem_assign_dev
>   b) unregister_netdevice_queue --> xsk_notifier
> 
> with the following locking order:
> 
>   a) xs->mutex --> rtnl_lock
>   b) rtnl_lock --> xdp.lock --> xs->mutex
> 
> Different order of taking 'xs->mutex' and 'rtnl_lock' could produce a
> deadlock here. Fix that by moving the 'rtnl_lock' before 'xs->lock' in
> the bind call chain (a).
> 
> Reported-by: syzbot+bf64ec93de836d7f4c2c@syzkaller.appspotmail.com
> Fixes: 455302d1c9ae ("xdp: fix hang while unregistering device bound to xdp socket")
> Signed-off-by: Ilya Maximets <i.maximets@samsung.com>

Applied, thanks!
