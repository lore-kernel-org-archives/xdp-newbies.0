Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:56112 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727771AbfFDPEr (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Tue, 4 Jun 2019 11:04:47 -0400
Subject: Re: [PATCH][next][V2] bpf: remove redundant assignment to err
References: <20190604082146.2049-1-colin.king@canonical.com>
From: Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <4e971d2b-1143-dd1a-6d2a-a2b75dec815b@iogearbox.net>
Date: Tue, 4 Jun 2019 17:04:37 +0200
MIME-Version: 1.0
In-Reply-To: <20190604082146.2049-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Colin King <colin.king@canonical.com>, Alexei Starovoitov <ast@kernel.org>, "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>, Magnus Karlsson <magnus.karlsson@intel.com>, netdev@vger.kernel.org, xdp-newbies@vger.kernel.org, bpf@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org

On 06/04/2019 10:21 AM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The variable err is assigned with the value -EINVAL that is never
> read and it is re-assigned a new value later on.  The assignment is
> redundant and can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied, thanks!
