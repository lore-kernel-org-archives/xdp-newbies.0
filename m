Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([23.128.96.9]:57644 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726668AbfFFU4D (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Thu, 6 Jun 2019 16:56:03 -0400
Date: Thu, 06 Jun 2019 13:56:01 -0700 (PDT)
Message-Id: <20190606.135601.1164776763745750423.davem@davemloft.net>
Subject: Re: [PATCH v3 net-next 0/7] net: ethernet: ti: cpsw: Add XDP
 support
From: David Miller <davem@davemloft.net>
In-Reply-To: <20190606100850.72a48a43@carbon>
References: <20190605132009.10734-1-ivan.khoronzhuk@linaro.org>
        <20190605.121450.2198491088032558315.davem@davemloft.net>
        <20190606100850.72a48a43@carbon>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: brouer@redhat.com
Cc: ivan.khoronzhuk@linaro.org, grygorii.strashko@ti.com, hawk@kernel.org, ast@kernel.org, linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org, xdp-newbies@vger.kernel.org, ilias.apalodimas@linaro.org, netdev@vger.kernel.org, daniel@iogearbox.net, jakub.kicinski@netronome.com, john.fastabend@gmail.com

From: Jesper Dangaard Brouer <brouer@redhat.com>
Date: Thu, 6 Jun 2019 10:08:50 +0200

> I do have a working prototype, that fixes these two bugs.  I guess, I'm
> under pressure to send this to the list soon...

So I'm going to mark this CPSW patchset as "deferred" while these bugs are
worked out.
