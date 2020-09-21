Return-Path: <SRS0=CsYz=C6=vger.kernel.org=xdp-newbies-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D7A6C43466
	for <xdp-newbies@archiver.kernel.org>; Mon, 21 Sep 2020 15:04:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB91E20758
	for <xdp-newbies@archiver.kernel.org>; Mon, 21 Sep 2020 15:04:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sOEC7xmm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726592AbgIUPEN (ORCPT <rfc822;xdp-newbies@archiver.kernel.org>);
        Mon, 21 Sep 2020 11:04:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726419AbgIUPEM (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 21 Sep 2020 11:04:12 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04EBAC061755
        for <xdp-newbies@vger.kernel.org>; Mon, 21 Sep 2020 08:04:12 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id q13so18186032ejo.9
        for <xdp-newbies@vger.kernel.org>; Mon, 21 Sep 2020 08:04:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=SQoO+qzzuql1MBrYsDu7d9j0el8kRjS9c455wz2UEsE=;
        b=sOEC7xmmL5ieRFDnRvN4yhHXkN1mZtWCI8RCxa3fITz2aQ8B2VAccZn4RSsEd1iJ+c
         7Lk9N9i6a7wgSD/m6ULOSoJl55UKsfVvF2OudyKHwC+W6W1OeTfw4CapUXNAK7Z1kCm5
         VrzLhMc+tJDwqzCmqXgAFa7+oIPZygQST3lGTVkwbxtwtavqJSlTDULdU1hxyDcXonGh
         JE8hSRqDUaR2QEwcP2s4QPaLu97N6Ql43Pb6ZbvT38UHCkwqK+U1V2It8tKrt0fG1KYX
         A1arXj+L5uoZxEJQhu03frxJ4APqv9CamJW+FwEgq7VGV04BHYppW0hBxVwvfkE6eOxT
         MAoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=SQoO+qzzuql1MBrYsDu7d9j0el8kRjS9c455wz2UEsE=;
        b=rKlx2F0brRFs1rxQShY5rL5g1bmjltwL97zG217qUKht2JC3DSzC4X1YxlfIVGIWpr
         JbAoEwaIRVV1TpgXFudz7NQFEyYSjEHS8eV5uM1Zy7aXbggKT6uvTxsxat7Yv1eTLyJs
         /FYRcAhxHwZuxUliEF6qx7t79hG11Lcb1+cUa5WT1PIKwIqfi6jlaSOFokoILCgVipnm
         dxENhW8yDGRFzWtBWuqP9qn/+H4o0ItnqeFagZ65pZgXq2QwfPqnyNGH6IXIuSeBD8J9
         X82O08xpuHxr/ClKe6wUVyHqU5CBIMJBhzIRfXt6v09hWK2mnxyVO1zaJ7iBVLt9fHLv
         mTgQ==
X-Gm-Message-State: AOAM531zEvbBzCKPaKKvN+yRV/fKXznzcMuN0xVQOL+up2YkWX2RXUJt
        bLMfpSt04I87KNPA9asvVwKkwq696tL60Z3OwxonNeJQMk2IDw==
X-Google-Smtp-Source: ABdhPJxNzQFI/7oh5NsrG7yXtgsrRH52/mj6IYW3mN9scPisv61vi9eH/Fb0lcukJONPxWgeuv/xsdeyLJM2G20mAxw=
X-Received: by 2002:a17:906:bcfc:: with SMTP id op28mr45419633ejb.248.1600700650455;
 Mon, 21 Sep 2020 08:04:10 -0700 (PDT)
MIME-Version: 1.0
From:   Tugce Ozturk <tugceozturk.5@gmail.com>
Date:   Mon, 21 Sep 2020 18:03:59 +0300
Message-ID: <CAAL8+sW1=kjnPJ1UEDZsxbe1QfSwL5YszNYipT7kBgYOBOAC6Q@mail.gmail.com>
Subject: XDP program unloads by itself
To:     xdp-newbies@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <xdp-newbies.vger.kernel.org>
X-Mailing-List: xdp-newbies@vger.kernel.org

Hello,

I am trying to run the XDP router program from xdp-tutorials. I
successfully load the program with xdp_loader provided, and I can
verify that the program is loaded with ip command. However, after a
few seconds (this duration is random) the xdp program unloads by
itself without any error. It just disappears.

I tried with different XDP programs, different XDP modes and different
interfaces as well. But the same issue persists. So, could you suggest
me a way to troubleshoot this issue? for e.g. where can I find some
related logs or how can I monitor the behaviour of an XDP program?
Have you ever come across such a problem?

My kernel is 5.4.0-47-generic. NIC driver i40e (tried with ixgbe too).

Best regards,
Tugce O.
