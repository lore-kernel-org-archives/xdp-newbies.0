Return-Path: <xdp-newbies-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8C23C433ED
	for <xdp-newbies@archiver.kernel.org>; Fri, 30 Apr 2021 17:24:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D1CC613E8
	for <xdp-newbies@archiver.kernel.org>; Fri, 30 Apr 2021 17:24:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbhD3RZC (ORCPT <rfc822;xdp-newbies@archiver.kernel.org>);
        Fri, 30 Apr 2021 13:25:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbhD3RZC (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 30 Apr 2021 13:25:02 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D5AAC06174A
        for <xdp-newbies@vger.kernel.org>; Fri, 30 Apr 2021 10:24:13 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id 1so52159998qtb.0
        for <xdp-newbies@vger.kernel.org>; Fri, 30 Apr 2021 10:24:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=coverfire.com; s=google;
        h=message-id:subject:from:to:date:user-agent:mime-version
         :content-transfer-encoding;
        bh=NbAFfKd0lzh0heXgjqlnyOrpmK+wOWghvGuT+zk5PW4=;
        b=GKiE0c7P7n8TtajllgNO4reMqA7KHCTduXvTQD6xH5GzTgrHry5ZarX0HmrOlw7Ig9
         y5anE3tj35pMZmoyUl1Aq+X/RQq20fSX4Y0uFFnGE1k/sRlHyqrnqfX1v3Z9utp6f3i6
         LyFRujmi4dsQFd+7/vidC5aqDA576JQSnWq4qbu7nC9n0RkUwCBpqCMpvv79Imjsb5RR
         iR8IOtHfcFSt4bKBgw9Sm27KBIEf0SgbstyoF6YlxS6wDIBiTAcFf7X+PZqbvB9KizwQ
         TQEmiz1MOWCLggBL4MfyKzZgBMpMaHJEyvZRpI4BFGKSeH9XrUvOVT84vO/BVous/JyS
         ZO9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:date:user-agent
         :mime-version:content-transfer-encoding;
        bh=NbAFfKd0lzh0heXgjqlnyOrpmK+wOWghvGuT+zk5PW4=;
        b=IWW/D4m1WIBR4bP9Zi1sJ4m/WfKpGPP+geMRuAfFSgXRe0rxqJi/eltlinTR6J92GX
         S75//Ujs95Em++0B2bAi9RvqzZMZhEMnrNy1piTX88HPb9emrNu1FmEIFwYABBAOtYp7
         3x77/hte0tTAO2MDVgZIsB1xgAuv6V05oALZUfK0h4LGPQWmgN3mPeP0n3AqLQNS5yc5
         FamFNl0F5xtnlln3hqEZx/PwNsO9WxBcbVvV7LqSZtwZlzLs+H8j/eZ1wnNr/ezm3EL5
         zE1aUAoKI5gDLq404jFWAtMy16aYqYxXswY24mlknEHLAuBZodPrveD2RdAQQDIyX/Eo
         cMDQ==
X-Gm-Message-State: AOAM530Lcdy/DmWv6dk/KXwgvWPMUA1r9mBIUvP5PuekH+mW+N0dBjJZ
        Nixh1N9i1X1mrPXRGANoQrf+Zb3koCvvGA==
X-Google-Smtp-Source: ABdhPJxmBX2lVYljVXcRvRO2qBQORDvrrwvXS8VyW0c5J59S1SWrAKq4spEvyrYNrixyhdNLMVg6gA==
X-Received: by 2002:ac8:5546:: with SMTP id o6mr1447158qtr.212.1619803452370;
        Fri, 30 Apr 2021 10:24:12 -0700 (PDT)
Received: from ?IPv6:2607:f2c0:e56e:28c:e4de:d9eb:cc0b:f46a? ([2607:f2c0:e56e:28c:e4de:d9eb:cc0b:f46a])
        by smtp.gmail.com with ESMTPSA id h24sm2639345qtm.19.2021.04.30.10.24.11
        for <xdp-newbies@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Apr 2021 10:24:12 -0700 (PDT)
Message-ID: <0b0ebcc691f6dfeb560c2faf1e329e059cbecc2d.camel@coverfire.com>
Subject: AF_XDP Rx and overload
From:   Dan Siemon <dan@coverfire.com>
To:     Xdp <xdp-newbies@vger.kernel.org>
Date:   Fri, 30 Apr 2021 13:24:11 -0400
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.0 (3.40.0-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <xdp-newbies.vger.kernel.org>
X-Mailing-List: xdp-newbies@vger.kernel.org

When an AF_XDP based application is overloaded, it is preferable for
the application to:
* Service the Rx ring as fast as it can and drop in the application if
required?
* Let the Rx ring fill up and let the NIC drop?

This is mostly a performance/PPS question. Obviously the application
loses the ability to directly count the drops if the NIC drops among
other limitations.

If it makes a difference, the use case is only i40e right now.

