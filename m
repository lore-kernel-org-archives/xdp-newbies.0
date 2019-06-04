Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53130 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727358AbfFDL7T (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 4 Jun 2019 07:59:19 -0400
Date: Tue, 4 Jun 2019 13:58:57 +0200
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [PATCH][next][V2] bpf: remove redundant assignment to err
Message-ID: <20190604135857.3f0e6cdc@carbon>
In-Reply-To: <20190604082146.2049-1-colin.king@canonical.com>
References: <20190604082146.2049-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Colin King <colin.king@canonical.com>
Cc: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>, Magnus Karlsson <magnus.karlsson@intel.com>, netdev@vger.kernel.org, xdp-newbies@vger.kernel.org, bpf@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org, brouer@redhat.com

On Tue,  4 Jun 2019 09:21:46 +0100
Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> The variable err is assigned with the value -EINVAL that is never
> read and it is re-assigned a new value later on.  The assignment is
> redundant and can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> 
> ---
> 
> V2: reorder variables as recommended by Jakub Kicinski to keep in
>     the networking code style.

Thank you for following the networking coding style.

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
