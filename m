Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([23.128.96.9]:35638 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726845AbfG2Qjo (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 29 Jul 2019 12:39:44 -0400
Date: Mon, 29 Jul 2019 09:39:42 -0700 (PDT)
Message-Id: <20190729.093942.444986138886341871.davem@davemloft.net>
Subject: Re: [PATCH net-next] MAINTAINERS: Remove mailing-list entry for
 XDP (eXpress Data Path)
From: David Miller <davem@davemloft.net>
In-Reply-To: <156440259790.6123.1563221733550893420.stgit@carbon>
References: <156440259790.6123.1563221733550893420.stgit@carbon>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: brouer@redhat.com
Cc: xdp-newbies@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net, jakub.kicinski@netronome.com, john.fastabend@gmail.com

From: Jesper Dangaard Brouer <brouer@redhat.com>
Date: Mon, 29 Jul 2019 14:16:37 +0200

> This removes the mailing list xdp-newbies@vger.kernel.org from the XDP
> kernel maintainers entry.
> 
> Being in the kernel MAINTAINERS file successfully caused the list to
> receive kbuild bot warnings, syzbot reports and sometimes developer
> patches. The level of details in these messages, doesn't match the
> target audience of the XDP-newbies list. This is based on a survey on
> the mailing list, where 73% voted for removal from MAINTAINERS file.
> 
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>

I'll apply this to 'net', thanks Jesper.
