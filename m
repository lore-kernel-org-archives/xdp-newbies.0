Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:50736 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726449AbfGLNHd (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 12 Jul 2019 09:07:33 -0400
Subject: Re: [PATCH bpf] xdp: fix possible cq entry leak
References: <CGME20190704142509eucas1p268eb9ca87bcc0bffb60891f88f3f6642@eucas1p2.samsung.com>
 <20190704142503.23501-1-i.maximets@samsung.com>
From: Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <47c7cc21-6e4c-63a6-7649-5486fcd43607@iogearbox.net>
Date: Fri, 12 Jul 2019 15:07:18 +0200
MIME-Version: 1.0
In-Reply-To: <20190704142503.23501-1-i.maximets@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Ilya Maximets <i.maximets@samsung.com>, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, bpf@vger.kernel.org, xdp-newbies@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>, Magnus Karlsson <magnus.karlsson@intel.com>, Jonathan Lemon <jonathan.lemon@gmail.com>, Jakub Kicinski <jakub.kicinski@netronome.com>, Alexei Starovoitov <ast@kernel.org>

On 07/04/2019 04:25 PM, Ilya Maximets wrote:
> Completion queue address reservation could not be undone.
> In case of bad 'queue_id' or skb allocation failure, reserved entry
> will be leaked reducing the total capacity of completion queue.
> 
> Fix that by moving reservation to the point where failure is not
> possible. Additionally, 'queue_id' checking moved out from the loop
> since there is no point to check it there.
> 
> Fixes: 35fcde7f8deb ("xsk: support for Tx")
> Signed-off-by: Ilya Maximets <i.maximets@samsung.com>

Applied, thanks!
