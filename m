Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([23.128.96.9]:56520 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbfE3SMg (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 30 May 2019 14:12:36 -0400
Date: Thu, 30 May 2019 11:12:34 -0700 (PDT)
Message-Id: <20190530.111234.228447416363288012.davem@davemloft.net>
Subject: Re: [PATCH PATCH v4 0/2] XDP generic fixes
From: David Miller <davem@davemloft.net>
In-Reply-To: <20190528184731.7464-1-sthemmin@microsoft.com>
References: <20190528184731.7464-1-sthemmin@microsoft.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: stephen@networkplumber.org
Cc: saeedm@mellanox.com, jasowang@redhat.com, brouer@redhat.com, netdev@vger.kernel.org, xdp-newbies@vger.kernel.org, sthemmin@microsoft.com

From: Stephen Hemminger <stephen@networkplumber.org>
Date: Tue, 28 May 2019 11:47:29 -0700

> This set of patches came about while investigating XDP
> generic on Azure. The split brain nature of the accelerated
> networking exposed issues with the stack device model.

Series applied.
