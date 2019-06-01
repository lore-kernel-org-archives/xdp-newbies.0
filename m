Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from fllv0015.ext.ti.com ([198.47.19.141]:36738 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbfFAKuJ (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Sat, 1 Jun 2019 06:50:09 -0400
Subject: Re: [PATCH v2 net-next 3/7] net: ethernet: ti: cpsw: use cpsw as drv
 data
References: <20190530182039.4945-1-ivan.khoronzhuk@linaro.org>
 <20190530182039.4945-4-ivan.khoronzhuk@linaro.org>
From: grygorii <grygorii.strashko@ti.com>
Message-ID: <976fc52a-2f9c-d597-09b4-93d37a510f13@ti.com>
Date: Sat, 1 Jun 2019 13:49:35 +0300
MIME-Version: 1.0
In-Reply-To: <20190530182039.4945-4-ivan.khoronzhuk@linaro.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>, hawk@kernel.org, davem@davemloft.net
Cc: ast@kernel.org, linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org, xdp-newbies@vger.kernel.org, ilias.apalodimas@linaro.org, netdev@vger.kernel.org, daniel@iogearbox.net, jakub.kicinski@netronome.com, john.fastabend@gmail.com



On 30/05/2019 21:20, Ivan Khoronzhuk wrote:
> No need to set ndev for drvdata when mainly cpsw reference is needed,
> so correct this legacy decision.
> 
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
> ---
>   drivers/net/ethernet/ti/cpsw.c | 16 +++++++---------
>   1 file changed, 7 insertions(+), 9 deletions(-)


Thank you.
Reviewed-by: Grygorii Strashko <grygorii.strashko@ti.com>

-- 
Best regards,
grygorii
