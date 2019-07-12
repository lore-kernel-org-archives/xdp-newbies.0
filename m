Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qt1-f196.google.com ([209.85.160.196]:35061 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728102AbfGLAWI (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 11 Jul 2019 20:22:08 -0400
MIME-Version: 1.0
References: <20190708163121.18477-1-krzesimir@kinvolk.io> <20190708163121.18477-9-krzesimir@kinvolk.io>
In-Reply-To: <20190708163121.18477-9-krzesimir@kinvolk.io>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Thu, 11 Jul 2019 17:21:56 -0700
Message-ID: <CAEf4BzZ23_m-L6vob6BKn24yphRQUBMceAHqkSU+8C8EovmVFA@mail.gmail.com>
Subject: Re: [bpf-next v3 08/12] tools headers: Sync struct bpf_perf_event_data
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Krzesimir Nowak <krzesimir@kinvolk.io>
Cc: open list <linux-kernel@vger.kernel.org>, Alban Crequy <alban@kinvolk.io>, =?UTF-8?Q?Iago_L=C3=B3pez_Galeiras?= <iago@kinvolk.io>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, Stanislav Fomichev <sdf@google.com>, Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, xdp-newbies@vger.kernel.org

On Mon, Jul 8, 2019 at 3:42 PM Krzesimir Nowak <krzesimir@kinvolk.io> wrote:
>
> struct bpf_perf_event_data in kernel headers has the addr field, which
> is missing in the tools version of the struct. This will be important
> for the bpf prog test run implementation for perf events as it will
> expect data to be an instance of struct bpf_perf_event_data, so the
> size of the data needs to match sizeof(bpf_perf_event_data).
>
> Signed-off-by: Krzesimir Nowak <krzesimir@kinvolk.io>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/include/uapi/linux/bpf_perf_event.h | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/tools/include/uapi/linux/bpf_perf_event.h b/tools/include/uapi/linux/bpf_perf_event.h
> index 8f95303f9d80..eb1b9d21250c 100644
> --- a/tools/include/uapi/linux/bpf_perf_event.h
> +++ b/tools/include/uapi/linux/bpf_perf_event.h
> @@ -13,6 +13,7 @@
>  struct bpf_perf_event_data {
>         bpf_user_pt_regs_t regs;
>         __u64 sample_period;
> +       __u64 addr;
>  };
>
>  #endif /* _UAPI__LINUX_BPF_PERF_EVENT_H__ */
> --
> 2.20.1
>
