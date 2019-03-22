Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mga17.intel.com ([192.55.52.151]:59959 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726667AbfCVK3y (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 22 Mar 2019 06:29:54 -0400
Date: Fri, 22 Mar 2019 12:29:48 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: [PATCH v2] thunderbolt: xdomain: Fix to check return value of
 kmemdup
Message-ID: <20190322102948.GU3622@lahna.fi.intel.com>
References: <20190320164720.31264-1-pakki001@umn.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190320164720.31264-1-pakki001@umn.edu>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Aditya Pakki <pakki001@umn.edu>
Cc: kjlu@umn.edu, Andreas Noever <andreas.noever@gmail.com>, Michael Jamet <michael.jamet@intel.com>, Yehezkel Bernat <YehezkelShB@gmail.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, xdp-newbies@vger.kernel.org, bpf@vger.kernel.org

On Wed, Mar 20, 2019 at 11:47:20AM -0500, Aditya Pakki wrote:
> kmemdup can fail and return a NULL pointer. The patch modifies the
> signature of tb_xdp_schedule_request and passes the failure error upstream.
> 
> Signed-off-by: Aditya Pakki <pakki001@umn.edu>

Applied, thanks!
