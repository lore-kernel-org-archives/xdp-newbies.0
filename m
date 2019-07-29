Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pl1-f196.google.com ([209.85.214.196]:46993 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbfG2QhL (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 29 Jul 2019 12:37:11 -0400
Received: by mail-pl1-f196.google.com with SMTP id c2so27695100plz.13
        for <xdp-newbies@vger.kernel.org>; Mon, 29 Jul 2019 09:37:11 -0700 (PDT)
Date: Mon, 29 Jul 2019 09:37:00 -0700
From: Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: Re: [PATCH net-next] MAINTAINERS: Remove mailing-list entry for XDP
 (eXpress Data Path)
Message-ID: <20190729093341.2bdb04dd@cakuba.netronome.com>
In-Reply-To: <156440259790.6123.1563221733550893420.stgit@carbon>
References: <156440259790.6123.1563221733550893420.stgit@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: xdp-newbies@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net, john.fastabend@gmail.com

On Mon, 29 Jul 2019 14:16:37 +0200, Jesper Dangaard Brouer wrote:
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

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
