Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pg1-f193.google.com ([209.85.215.193]:33970 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726801AbfEPXZ1 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 16 May 2019 19:25:27 -0400
Received: by mail-pg1-f193.google.com with SMTP id c13so2312262pgt.1
        for <xdp-newbies@vger.kernel.org>; Thu, 16 May 2019 16:25:27 -0700 (PDT)
Date: Thu, 16 May 2019 16:25:19 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH net 3/3] netdevice: clarify meaning of rx_handler_result
Message-ID: <20190516162519.06910fa9@hermes.lan>
In-Reply-To: <20190516152543.729c6cb0@cakuba.netronome.com>
References: <20190516215423.14185-1-sthemmin@microsoft.com>
        <20190516215423.14185-4-sthemmin@microsoft.com>
        <20190516152543.729c6cb0@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jakub Kicinski <jakub.kicinski@netronome.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, xdp-newbies@vger.kernel.org, bpf@vger.kernel.org, Stephen Hemminger <sthemmin@microsoft.com>

On Thu, 16 May 2019 15:25:43 -0700
Jakub Kicinski <jakub.kicinski@netronome.com> wrote:

> On Thu, 16 May 2019 14:54:23 -0700, Stephen Hemminger wrote:
> > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > index 44b47e9df94a..56f613561909 100644
> > --- a/include/linux/netdevice.h
> > +++ b/include/linux/netdevice.h
> > @@ -374,10 +374,10 @@ typedef enum gro_result gro_result_t;
> >  
> >  /*
> >   * enum rx_handler_result - Possible return values for rx_handlers.
> > - * @RX_HANDLER_CONSUMED: skb was consumed by rx_handler, do not process it
> > - * further.
> > - * @RX_HANDLER_ANOTHER: Do another round in receive path. This is indicated in
> > - * case skb->dev was changed by rx_handler.
> > + * @RX_HANDLER_CONSUMED: skb was consumed by rx_handler.
> > + *  Do not process it further.
> > + * @RX_HANDLER_ANOTHER: skb->dev was modified by rx_handler,
> > + *  Do another round in receive path. This is indicated in  
> 
> s/ This is indicated in//

Thanks, left over from previous version forgot to trim.
