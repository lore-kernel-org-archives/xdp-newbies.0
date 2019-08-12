Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:40012 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbfHLQLq (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 12 Aug 2019 12:11:46 -0400
Date: Mon, 12 Aug 2019 13:11:37 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: Re: [PATCH v2 2/2] Documentation: sphinx: Don't parse socket() as
 identifier reference
Message-ID: <20190812131137.74a4ddf3@coco.lan>
In-Reply-To: <20190812160708.32172-2-j.neuschaefer@gmx.net>
References: <20190812160708.32172-1-j.neuschaefer@gmx.net>
        <20190812160708.32172-2-j.neuschaefer@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: Jonathan =?UTF-8?B?TmV1c2Now6RmZXI=?= <j.neuschaefer@gmx.net>
Cc: linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, xdp-newbies@vger.kernel.org, bpf@vger.kernel.org

Em Mon, 12 Aug 2019 18:07:05 +0200
Jonathan Neuschäfer <j.neuschaefer@gmx.net> escreveu:

> With the introduction of Documentation/sphinx/automarkup.py, socket() is
> parsed as a reference to the in-kernel definition of socket. Sphinx then
> decides that struct socket is a good match, which is usually not
> intended, when the syscall is meant instead. This was observed in
> Documentation/networking/af_xdp.rst.
> 
> Prevent socket() from being misinterpreted by adding it to the Skipfuncs
> list in automarkup.py.
> 
> Signed-off-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>
> ---
> 
> v2:
> - block socket() in Documentation/sphinx/automarkup.py, as suggested by
>   Jonathan Corbet
> 
> v1:
> - https://lore.kernel.org/lkml/20190810121738.19587-1-j.neuschaefer@gmx.net/
> ---
>  Documentation/sphinx/automarkup.py | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/sphinx/automarkup.py b/Documentation/sphinx/automarkup.py
> index a8798369e8f7..5b6119ff69f4 100644
> --- a/Documentation/sphinx/automarkup.py
> +++ b/Documentation/sphinx/automarkup.py
> @@ -26,7 +26,8 @@ RE_function = re.compile(r'([\w_][\w\d_]+\(\))')
>  # just don't even try with these names.
>  #
>  Skipfuncs = [ 'open', 'close', 'read', 'write', 'fcntl', 'mmap',
> -              'select', 'poll', 'fork', 'execve', 'clone', 'ioctl']
> +              'select', 'poll', 'fork', 'execve', 'clone', 'ioctl',
> +              'socket' ]

Both patches sound OK on my eyes. Yet, I would just fold them into
a single one.

In any case:

Reviewed-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> 
>  #
>  # Find all occurrences of function() and try to replace them with
> --
> 2.20.1
> 



Thanks,
Mauro
