Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-yw1-f68.google.com ([209.85.161.68]:35279 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726320AbfFZCRo (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 25 Jun 2019 22:17:44 -0400
Received: by mail-yw1-f68.google.com with SMTP id k128so325987ywf.2
        for <xdp-newbies@vger.kernel.org>; Tue, 25 Jun 2019 19:17:44 -0700 (PDT)
Received: from mail-yw1-f53.google.com (mail-yw1-f53.google.com. [209.85.161.53])
        by smtp.gmail.com with ESMTPSA id v192sm4163431ywv.40.2019.06.25.19.17.41
        for <xdp-newbies@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jun 2019 19:17:41 -0700 (PDT)
Received: by mail-yw1-f53.google.com with SMTP id y185so308037ywy.8
        for <xdp-newbies@vger.kernel.org>; Tue, 25 Jun 2019 19:17:41 -0700 (PDT)
MIME-Version: 1.0
References: <20190625175948.24771-1-ivan.khoronzhuk@linaro.org> <20190625175948.24771-4-ivan.khoronzhuk@linaro.org>
In-Reply-To: <20190625175948.24771-4-ivan.khoronzhuk@linaro.org>
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Tue, 25 Jun 2019 22:17:03 -0400
Message-ID: <CA+FuTScQ2WdEqQpsCdM_KZK9e+Zq7v5B+x=HLthxLAyOhYu-zQ@mail.gmail.com>
Subject: Re: [PATCH v4 net-next 3/4] net: ethernet: ti: davinci_cpdma: return
 handler status
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc: David Miller <davem@davemloft.net>, grygorii.strashko@ti.com, hawk@kernel.org, brouer@redhat.com, saeedm@mellanox.com, leon@kernel.org, Alexei Starovoitov <ast@kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-omap@vger.kernel.org, xdp-newbies@vger.kernel.org, ilias.apalodimas@linaro.org, Network Development <netdev@vger.kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, jakub.kicinski@netronome.com, John Fastabend <john.fastabend@gmail.com>

On Tue, Jun 25, 2019 at 2:00 PM Ivan Khoronzhuk
<ivan.khoronzhuk@linaro.org> wrote:
>
> This change is needed to return flush status of rx handler for
> flushing redirected xdp frames after processing channel packets.
> Do it as separate patch for simplicity.
>
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>

> @@ -602,7 +605,8 @@ static int cpsw_tx_mq_poll(struct napi_struct *napi_tx, int budget)
>                 else
>                         cur_budget = txv->budget;
>
> -               num_tx += cpdma_chan_process(txv->ch, cur_budget);
> +               cpdma_chan_process(txv->ch, &cur_budget);
> +               num_tx += cur_budget;

Less code change to add a new argument int *flush to communicate the
new state and leave the existing argument and return values as is?
