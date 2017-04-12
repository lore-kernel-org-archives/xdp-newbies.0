Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35748 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751106AbdDLLva (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 12 Apr 2017 07:51:30 -0400
Message-ID: <1491997888.2855.1.camel@sipsolutions.net>
Subject: Re: [PATCH] Enable Netdev XDP tutorial for Ubuntu 17.04
From: Johannes Berg <johannes@sipsolutions.net>
Date: Wed, 12 Apr 2017 13:51:28 +0200
In-Reply-To: <20602.1491881713@famine> (sfid-20170411_053552_749185_2EF01FC0)
References: <20602.1491881713@famine> (sfid-20170411_053552_749185_2EF01FC0)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jay Vosburgh <jay.vosburgh@canonical.com>, xdp-newbies@vger.kernel.org
Cc: Jesper Dangaard Brouer <brouer@redhat.com>, Andy Gospodarek <andy@greyhouse.net>

On Mon, 2017-04-10 at 20:35 -0700, Jay Vosburgh wrote:
> 	This patch resolves build issues when compiling the samples on
> Ubuntu 17.04 with the distro 4.10 kernel and the linux-headers
> package
> installed.  This permits running the samples using distro packages
> without needing to rebuild the kernel from source.
> 
> 	Tested on a 17.04 VM using virtio_net.
> 
> Signed-off-by: Jay Vosburgh <jay.vosburgh@canonical.com>
> ---
> 
> 	I haven't tried the patched version of this on a built from
> source kernel yet, so it might break that.

I was able to build on a recent Debian testing by simply inserting the
following line into samples/bpf/Makefile to force it to use the
kernel's UAPI instead of the installed headers:

HOSTCFLAGS += -I$(srctree)/include/uapi/ -D__EXPORTED_HEADERS__

johannes
