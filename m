Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qk1-f194.google.com ([209.85.222.194]:33883 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728582AbfGLAUC (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 11 Jul 2019 20:20:02 -0400
MIME-Version: 1.0
References: <20190708163121.18477-1-krzesimir@kinvolk.io> <20190708163121.18477-8-krzesimir@kinvolk.io>
In-Reply-To: <20190708163121.18477-8-krzesimir@kinvolk.io>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Thu, 11 Jul 2019 17:19:50 -0700
Message-ID: <CAEf4BzZSApnfQ7Z527WqM3ejz5C3BQS9eWdrgJ=k=hqhWADynw@mail.gmail.com>
Subject: Re: [bpf-next v3 07/12] tools headers: Adopt compiletime_assert from
 kernel sources
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Krzesimir Nowak <krzesimir@kinvolk.io>
Cc: open list <linux-kernel@vger.kernel.org>, Alban Crequy <alban@kinvolk.io>, =?UTF-8?Q?Iago_L=C3=B3pez_Galeiras?= <iago@kinvolk.io>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, Stanislav Fomichev <sdf@google.com>, Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, xdp-newbies@vger.kernel.org

On Mon, Jul 8, 2019 at 3:42 PM Krzesimir Nowak <krzesimir@kinvolk.io> wrote:
>
> This will come in handy to verify that the hardcoded size of the
> context data in bpf_test struct is high enough to hold some struct.
>
> Signed-off-by: Krzesimir Nowak <krzesimir@kinvolk.io>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>


>  tools/include/linux/compiler.h | 28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
>
> diff --git a/tools/include/linux/compiler.h b/tools/include/linux/compiler.h
> index 1827c2f973f9..b4e97751000a 100644
> --- a/tools/include/linux/compiler.h
> +++ b/tools/include/linux/compiler.h

[...]
