Return-Path: <xdp-newbies-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C9DAC63777
	for <xdp-newbies@archiver.kernel.org>; Wed, 18 Nov 2020 02:49:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4225624682
	for <xdp-newbies@archiver.kernel.org>; Wed, 18 Nov 2020 02:49:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="am7WFrQ9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbgKRCtJ (ORCPT <rfc822;xdp-newbies@archiver.kernel.org>);
        Tue, 17 Nov 2020 21:49:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726202AbgKRCtI (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 17 Nov 2020 21:49:08 -0500
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85E0AC0613D4;
        Tue, 17 Nov 2020 18:49:08 -0800 (PST)
Received: by mail-yb1-xb41.google.com with SMTP id w5so247665ybj.11;
        Tue, 17 Nov 2020 18:49:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4tGBegvm7wEk8utzbc4kW94oTcRZevqQjKSDFT/ItuY=;
        b=am7WFrQ9O+Ab/4h0E1qWRGnxglYQWrbDR4c9x3217xbY23inwLUs/F8+lNUfLlTkId
         HGCnT+AwXazVk1py+U6BWUyTJvsE4DyGQgM2tdiaz30VvX+L7HiNw4SKIE0gydRSqsDx
         Nw/vX31jWngubMVzILXN6Yr9fbYwWn4aU7c3LzT8BhHFAypelQtvKU3FyUl8erbmibuW
         MoJqY+mo8Ycl1CmK2RB7z7zC4MbKcNHa0MSS5FtwUIpZ+Dzzlpylx42jceILbQPgY3Ry
         SA7K7fB4Wj+OL/BK4EkMM5/DsEQmQuSLAx4QPz/BZnO98EVUe0GdqIKv6Y4ueiSRVhb0
         MN9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4tGBegvm7wEk8utzbc4kW94oTcRZevqQjKSDFT/ItuY=;
        b=Yd/G62ekg2EXhn1zR7FXHMoONJHS2xdXOu5+K3ahWqEU0+wgU//msZlrhpYdCIhujJ
         vs1WQc0B5bEYL315SZNcqStXuLSrE5K7Cl6a5jFiiaXpe9TLPPOiOKAG0iIEJ/0FrkzC
         bW6YdM7a2sEzKqCs/r/cd+nVW91Uw/wHiRtnssakonA082gnGlRmgCFbqxyCV+SLq0UV
         I+gOIyg6wTOSEqQfrYemh5YmJ/Q0q/vXTLA8avkSjOwXT4qNiRSNKLasW0FR6fHgXf3d
         Sbc5ypcDCAkCoJn9e5xuVXvqZID9qDokFzJrAmM5oI+yNVwJyMRUaPzruSvDwoviZIYE
         mZyQ==
X-Gm-Message-State: AOAM533Wx7vl+sUmI3VEyR/L9rjc5XrGX3sGvdwBmGDvUuu33KB7vX5x
        FQN4/2hy82TG7W4bwqdh+pSrxVXXVUq2Pc2J31A=
X-Google-Smtp-Source: ABdhPJzDl57OjC0DVpWbugcubJ/3p9Q0HMaf/+b/qra0isMpRNoz0LDWKQWa2wdvyZbDvuTkD6Y2FRkywkvBItn7eTo=
X-Received: by 2002:a25:df8e:: with SMTP id w136mr3502264ybg.230.1605667747855;
 Tue, 17 Nov 2020 18:49:07 -0800 (PST)
MIME-Version: 1.0
References: <20201117145644.1166255-1-danieltimlee@gmail.com> <20201117145644.1166255-10-danieltimlee@gmail.com>
In-Reply-To: <20201117145644.1166255-10-danieltimlee@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 17 Nov 2020 18:48:57 -0800
Message-ID: <CAEf4BzaOMOhX14zXGzkPmLxCHLj+e4a98d9YtT4RdJNNtrPnOQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 9/9] samples: bpf: remove bpf_load loader completely
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, brakmo <brakmo@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        David Ahern <dsa@cumulusnetworks.com>,
        Yonghong Song <yhs@fb.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Ira Weiny <ira.weiny@intel.com>, Thomas Graf <tgraf@suug.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Xdp <xdp-newbies@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <xdp-newbies.vger.kernel.org>
X-Mailing-List: xdp-newbies@vger.kernel.org

On Tue, Nov 17, 2020 at 6:58 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
>
> Numerous refactoring that rewrites BPF programs written with bpf_load
> to use the libbpf loader was finally completed, resulting in BPF
> programs using bpf_load within the kernel being completely no longer
> present.
>
> This commit removes bpf_load, an outdated bpf loader that is difficult
> to keep up with the latest kernel BPF and causes confusion.
>
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> ---

RIP, bpf_load().

Probably makes more sense to combine this patch with the previous patch.

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  samples/bpf/bpf_load.c          | 667 --------------------------------
>  samples/bpf/bpf_load.h          |  57 ---
>  samples/bpf/xdp2skb_meta_kern.c |   2 +-
>  3 files changed, 1 insertion(+), 725 deletions(-)
>  delete mode 100644 samples/bpf/bpf_load.c
>  delete mode 100644 samples/bpf/bpf_load.h
>

[...]
