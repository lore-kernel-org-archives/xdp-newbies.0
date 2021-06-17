Return-Path: <xdp-newbies-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF719C2B9F4
	for <xdp-newbies@archiver.kernel.org>; Thu, 17 Jun 2021 18:03:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C3E461241
	for <xdp-newbies@archiver.kernel.org>; Thu, 17 Jun 2021 18:03:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbhFQSGD (ORCPT <rfc822;xdp-newbies@archiver.kernel.org>);
        Thu, 17 Jun 2021 14:06:03 -0400
Received: from telegrapho.inexo.com.br ([187.17.38.24]:38154 "EHLO
        telegrapho.inexo.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbhFQSGD (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 17 Jun 2021 14:06:03 -0400
X-Greylist: delayed 382 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Jun 2021 14:06:03 EDT
Received: by telegrapho.inexo.com.br (Postfix, from userid 1001)
        id A021E6690A1B; Thu, 17 Jun 2021 14:57:31 -0300 (-03)
DKIM-Filter: OpenDKIM Filter v2.11.0 telegrapho.inexo.com.br A021E6690A1B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=inexo.com.br;
        s=mail; t=1623952651;
        bh=AYCFgPxMCr1Wjvu4cxo4LQCoUn9LoEV2sM5mHf2eDXI=;
        h=Date:From:To:Subject:From;
        b=GVl16wGHb/Ee1y2Gte6RBUcCZe+lr3xZPQjYZKQ9EN06dLc1f1Wc4fUgNAydGGAaB
         0JxDS3INE4rHTW84DEucEdUkU7HtwNg5t/3DIFeN9Jv13g1DUmpRzQcfs/HkqidOGO
         yNXQHBBz1/5B2MtI15NZAa7THF4vNF98w4xR7swV+AHJF5uHAQRlQ9dcMdc+LyRBdY
         A3njfSoJn2rxOZRTibUeB0xg5uxKquteZE5gOY33aIY0EvXWRTLZezqklFWAePOL0I
         qwLZOAl81DUdWh7k8R8HgaFFQLar+Z+hxM8OMOp5+VTkEj7j9AvzP/YeiuSuPgYf0s
         hZWg0Hjc/tgrA==
Received: from babalu (unknown [187.17.36.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by telegrapho.inexo.com.br (Postfix) with ESMTPSA id 6E7756690A17
        for <xdp-newbies@vger.kernel.org>; Thu, 17 Jun 2021 14:57:31 -0300 (-03)
DKIM-Filter: OpenDKIM Filter v2.11.0 telegrapho.inexo.com.br 6E7756690A17
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=inexo.com.br;
        s=mail; t=1623952651;
        bh=AYCFgPxMCr1Wjvu4cxo4LQCoUn9LoEV2sM5mHf2eDXI=;
        h=Date:From:To:Subject:From;
        b=GVl16wGHb/Ee1y2Gte6RBUcCZe+lr3xZPQjYZKQ9EN06dLc1f1Wc4fUgNAydGGAaB
         0JxDS3INE4rHTW84DEucEdUkU7HtwNg5t/3DIFeN9Jv13g1DUmpRzQcfs/HkqidOGO
         yNXQHBBz1/5B2MtI15NZAa7THF4vNF98w4xR7swV+AHJF5uHAQRlQ9dcMdc+LyRBdY
         A3njfSoJn2rxOZRTibUeB0xg5uxKquteZE5gOY33aIY0EvXWRTLZezqklFWAePOL0I
         qwLZOAl81DUdWh7k8R8HgaFFQLar+Z+hxM8OMOp5+VTkEj7j9AvzP/YeiuSuPgYf0s
         hZWg0Hjc/tgrA==
Date:   Thu, 17 Jun 2021 14:57:31 -0300
From:   "Ethy H. Brito" <ethy.brito@inexo.com.br>
To:     xdp-newbies@vger.kernel.org
Subject: Traffic shaping at 10~300mbps at a 10Gbps link
Message-ID: <20210617145731.7b9df6c7@babalu>
Organization: InterNexo Ltda.
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <xdp-newbies.vger.kernel.org>
X-Mailing-List: xdp-newbies@vger.kernel.org


Hi.

I'm having trouble to shape traffic for a few thousand users.
Every time the interface bandwidth reaches around 4~4.5gbps, CPU load goes from 10~20% to 90~100% when using HTB. For HFSC this occurs around 2gbps.

I googled the problem and bumped into this topic (xdp-project) and Mr. Brouer told me about this list.

Please tell me which info I can feed you to help me with this issue.
I made a lots of experiences with no luck.

I am not a top level expert but I learn quick.

Regards

Ethy
