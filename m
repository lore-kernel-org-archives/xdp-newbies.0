Return-Path: <xdp-newbies-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA46CC433C1
	for <xdp-newbies@archiver.kernel.org>; Thu, 25 Mar 2021 06:25:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A222619C2
	for <xdp-newbies@archiver.kernel.org>; Thu, 25 Mar 2021 06:25:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbhCYGYt (ORCPT <rfc822;xdp-newbies@archiver.kernel.org>);
        Thu, 25 Mar 2021 02:24:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbhCYGY2 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 25 Mar 2021 02:24:28 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA8EEC06174A
        for <xdp-newbies@vger.kernel.org>; Wed, 24 Mar 2021 23:24:27 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id l4so1025516ejc.10
        for <xdp-newbies@vger.kernel.org>; Wed, 24 Mar 2021 23:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=jdyHPIz2w75nCPywWSUHCirfchvNXc2i3LY62/QCCfI=;
        b=hurlfXuTMp131Wcqhy7rrP155qLqtmJTGbVyVZg3jSo6P06jOdbvuT5FiY4mhsN9Dh
         78YqT/kR8yYg/2rI3yGBhbvvGAprXGQEjBKMj8IJqQfjTRVQGDomC5RMOh7X+CGFrEjS
         dk4OPA70j40T0TuBa0HpUFGFLHiLK2OHkzvNYbYk+Zy3u7eY4Ci+2HhvTo6ddvvt4jlt
         m0gAwhriySArg+dDAxy14HASvMJWkVSRir/dYCA+L6hL1CUWq5ZQjF0x/8x7mp8kIcmW
         HlE51uo/YfEn33aGd7loOvU08eXgnT8UEO13uSr6Hq6pkxVSivygR/6kW335xp+UlWn1
         F9hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=jdyHPIz2w75nCPywWSUHCirfchvNXc2i3LY62/QCCfI=;
        b=jmo6uS74A82fxd3cfG3bed9vvcjOs5OWtU4aPtrAi1VuNTX3PvYtNw6vuJbtAEMd9w
         D5nNcD46m24Ymd/JXLypAAjGRfEoFlkwCbGtEqBu2ppZIQSpfkoyHrO+9Xf5lFOdmle5
         osWveheIe7KMYWl7D7IiyDfPrXn5UZJ4jV5mjHDSWCsUGe7Ou0W/tjuNxKFMhlSCEF4Y
         0sOZCw16grfkFwGjzbMz1yLibsoACehy8VeeAWqrTtOvA+6Il7X89no/i3mp/U7kA1v7
         WFgBDkp13Iyn/bAfWdYm/kdX9F2qb91L/8gawbu/aCLD8od+O/ey8jPNZHWnezrEGbYZ
         195A==
X-Gm-Message-State: AOAM5318C0/oSmSTQEpkJcuCsIu2q7q540bbG9ikMRD9hJ+zkFsVgMR0
        UOZzlJToxteZimfN8R7iKBZ5WAdCU8eEN1flc0v8FJqDVrmG8w==
X-Google-Smtp-Source: ABdhPJwRzES40UgwJWCIBTHpC85TNzRkBeBihblVg8+6d/w79xX3q41VWiR/39pi7qhJLaW9iXVq7yG18dMgCfbesu0=
X-Received: by 2002:a17:906:9386:: with SMTP id l6mr7503432ejx.455.1616653466324;
 Wed, 24 Mar 2021 23:24:26 -0700 (PDT)
MIME-Version: 1.0
From:   Konstantinos Kaffes <kkaffes@gmail.com>
Date:   Wed, 24 Mar 2021 23:24:15 -0700
Message-ID: <CAHAzn3peP-j-oL76FxmyRgHg=QbMfeykA4rQdoDRA-0c6iQ4mg@mail.gmail.com>
Subject: AF_XDP sockets across multiple NIC queues
To:     xdp-newbies@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <xdp-newbies.vger.kernel.org>
X-Mailing-List: xdp-newbies@vger.kernel.org

Hello everyone,

I want to write a multi-threaded AF_XDP server where all N threads can
read from all N NIC queues. In my design, each thread creates N AF_XDP
sockets, each associated with a different queue. I have the following
questions:

1. Do sockets associated with the same queue need to share their UMEM
area and fill and completion rings?
2. Will there be a single XSKMAP holding all N^2 sockets? If yes, what
happens if my XDP program redirects a packet to a socket that is
associated with a different NIC queue than the one in which the packet
arrived?

I must mention that I am using the XDP skb mode with copies.

Thank you in advance,
Kostis
