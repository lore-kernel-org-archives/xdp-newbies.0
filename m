Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from ms.lwn.net ([45.79.88.28]:54206 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726024AbfHJO6Y (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Sat, 10 Aug 2019 10:58:24 -0400
Date: Sat, 10 Aug 2019 08:58:21 -0600
From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] Documentation/networking/af_xdp: Inhibit reference to
 struct socket
Message-ID: <20190810085821.11cee8b0@lwn.net>
In-Reply-To: <20190810121738.19587-1-j.neuschaefer@gmx.net>
References: <20190810121738.19587-1-j.neuschaefer@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jonathan =?UTF-8?B?TmV1c2Now6RmZXI=?= <j.neuschaefer@gmx.net>
Cc: linux-doc@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, netdev@vger.kernel.org, xdp-newbies@vger.kernel.org, bpf@vger.kernel.org, linux-kernel@vger.kernel.org

On Sat, 10 Aug 2019 14:17:37 +0200
Jonathan Neuschäfer <j.neuschaefer@gmx.net> wrote:

> With the recent change to auto-detect function names, Sphinx parses
> socket() as a reference to the in-kernel definition of socket. It then
> decides that struct socket is a good match, which was obviously not
> intended in this case, because the text speaks about the syscall with
> the same name.
> 
> Prevent socket() from being misinterpreted by wrapping it in ``inline
> literal`` quotes.
> 
> Signed-off-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>

Thanks for looking at that.  The better fix, though, would be to add
socket() to the Skipfuncs array in Documentation/sphinx/automarkup.py.
Then it will do the right thing everywhere without the need to add markup
to the RST files.

Thanks,

jon
