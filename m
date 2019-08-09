Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:59688 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406171AbfHIQMe (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Fri, 9 Aug 2019 12:12:34 -0400
Subject: Re: [PATCH v2 bpf-next] xdp: xdp_umem: fix umem pages mapping for
 32bits systems
References: <20190808093803.4918-1-ivan.khoronzhuk@linaro.org>
From: Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <0854fff0-4e21-c78e-b2a6-7f76364a70d2@iogearbox.net>
Date: Fri, 9 Aug 2019 18:12:23 +0200
MIME-Version: 1.0
In-Reply-To: <20190808093803.4918-1-ivan.khoronzhuk@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>, bjorn.topel@intel.com, magnus.karlsson@intel.com
Cc: davem@davemloft.net, ast@kernel.org, john.fastabend@gmail.com, hawk@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org, xdp-newbies@vger.kernel.org, linux-kernel@vger.kernel.org

On 8/8/19 11:38 AM, Ivan Khoronzhuk wrote:
> Use kmap instead of page_address as it's not always in low memory.
> 
> Acked-by: Björn Töpel <bjorn.topel@intel.com>
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>

Applied, thanks!
