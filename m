Return-Path: <xdp-newbies-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CCC9C433FE
	for <xdp-newbies@archiver.kernel.org>; Wed, 30 Nov 2022 08:54:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233842AbiK3Iyl (ORCPT <rfc822;xdp-newbies@archiver.kernel.org>);
        Wed, 30 Nov 2022 03:54:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234449AbiK3Iyk (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 30 Nov 2022 03:54:40 -0500
Received: from umail2.aei.mpg.de (umail2.aei.mpg.de [194.94.224.8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 461D42D1D5
        for <xdp-newbies@vger.kernel.org>; Wed, 30 Nov 2022 00:54:39 -0800 (PST)
Received: from mephisto.aei.uni-hannover.de (p5dccef84.dip0.t-ipconnect.de [93.204.239.132])
        by umail2.aei.mpg.de (Postfix) with ESMTPSA id B881B22A47D0
        for <xdp-newbies@vger.kernel.org>; Wed, 30 Nov 2022 09:54:36 +0100 (CET)
Date:   Wed, 30 Nov 2022 09:54:35 +0100
From:   Henning Fehrmann <henning.fehrmann@aei.mpg.de>
To:     "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>
Subject: Re: make XDP program aware of multi buffer
Message-ID: <Y4caS5Bh7M9SDJf9@mephisto.aei.uni-hannover.de>
References: <Y4X3u39irCVmVxZx@mephisto.aei.uni-hannover.de>
 <87cz95zyen.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87cz95zyen.fsf@toke.dk>
Precedence: bulk
List-ID: <xdp-newbies.vger.kernel.org>
X-Mailing-List: xdp-newbies@vger.kernel.org

> You just replace:
> 
> SEC("xdp")
> 
> with
> 
> SEC("xdp.frags")
> 
> in your source file and, assuming your libbpf version is up-to-date,
> that should be it as far as the kernel is concerned.

Nice. It loads now. I appreciate the work done for multi buffer packets.

> 
> However, you obviously also need to make sure there are no semantic
> issues in your program before doing this. I.e., data_end is no longer
> the end of your packet, so if you are using data_end-data to calculate
> the packet len, that will no longer be accurate. If you need to access
> data beyond the first frag you'll need to use the
> xdp_{load,store}_bytes() helpers.

I guess, this is not the case or does bpf_redirect needs it if I have
multi frame packets?
I realized that redirection actually doesn't happen if the packets
exceed the page size.

Thank you,
Henning
