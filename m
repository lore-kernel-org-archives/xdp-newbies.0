Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:25909 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730181AbgEVPwP (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 22 May 2020 11:52:15 -0400
Date: Fri, 22 May 2020 17:51:36 +0200
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: AF_XDP Side Of Project Breaking With XDP-Native
Message-ID: <20200522175136.5a6fdc55@carbon>
In-Reply-To: <50fe1ab5-55e7-980b-54d4-cd1d5e864865@gflclan.com>
References: <50fe1ab5-55e7-980b-54d4-cd1d5e864865@gflclan.com>
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: Christian Deacon <gamemann@gflclan.com>
Cc: brouer@redhat.com, xdp-newbies@vger.kernel.org

On Fri, 22 May 2020 10:22:10 -0500
Christian Deacon <gamemann@gflclan.com> wrote:

> If I'm not doing anything wrong here, is it possible there's a bug with 
> the NIC's driver? Unfortunately, I'm not sure which driver the cluster's 
> NIC is using. 

Please run:
 ethtool -i ens3

And provide output.  As it will tell you that NIC driver you are using.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
