Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:43267 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727126AbfCTKvK (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 20 Mar 2019 06:51:10 -0400
Date: Wed, 20 Mar 2019 12:51:04 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: [PATCH] thunderbolt: xdomain: Fix to check return value of
 kmemdup
Message-ID: <20190320105104.GS3622@lahna.fi.intel.com>
References: <20190318225508.7886-1-pakki001@umn.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190318225508.7886-1-pakki001@umn.edu>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Aditya Pakki <pakki001@umn.edu>
Cc: kjlu@umn.edu, Andreas Noever <andreas.noever@gmail.com>, Michael Jamet <michael.jamet@intel.com>, Yehezkel Bernat <YehezkelShB@gmail.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, xdp-newbies@vger.kernel.org, bpf@vger.kernel.org

On Mon, Mar 18, 2019 at 05:55:08PM -0500, Aditya Pakki wrote:
> @@ -1417,8 +1420,7 @@ bool tb_xdomain_handle_request(struct tb *tb, enum tb_cfg_pkg_type type,
>  	 */
>  	if (uuid_equal(&hdr->uuid, &tb_xdp_uuid)) {
>  		if (type == TB_CFG_PKG_XDOMAIN_REQ) {
> -			tb_xdp_schedule_request(tb, hdr, size);
> -			return true;
> +			return tb_xdp_schedule_request(tb, hdr, size);

Please remove parens as well that there is only a single statement
following the if-block.

Otherwise looks fine.
