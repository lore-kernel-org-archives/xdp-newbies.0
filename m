Return-Path: <SRS0=CsYz=C6=vger.kernel.org=xdp-newbies-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 199F8C43463
	for <xdp-newbies@archiver.kernel.org>; Mon, 21 Sep 2020 05:05:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE05520735
	for <xdp-newbies@archiver.kernel.org>; Mon, 21 Sep 2020 05:05:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X7xtXGXa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbgIUFFe (ORCPT <rfc822;xdp-newbies@archiver.kernel.org>);
        Mon, 21 Sep 2020 01:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726228AbgIUFFe (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 21 Sep 2020 01:05:34 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9AA4C061755
        for <xdp-newbies@vger.kernel.org>; Sun, 20 Sep 2020 22:05:33 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id o20so8227938pfp.11
        for <xdp-newbies@vger.kernel.org>; Sun, 20 Sep 2020 22:05:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=J2AboHUHvwMct3f9rNsQ3BzKZ3JxYpUIlcBNty+wXZw=;
        b=X7xtXGXa1v9N80fej33mnjoFo2ko9OTmIwTnQuAjhSLRiiDIOXOuS6qtva6/NNT8T9
         Z8sHJmJOoI61RrNooy2CJzWM9JTot0cOlUQ233REjpQvcWjWBSklNL9vIoh4UMFbiUP7
         Y6FnuNHjCC+4HnQLmJB9DYsKd23RzYzQ3+wvdMDd/7nyWKZDiGzTPS0SFsoYBXLKtolr
         orxsbPDu5gP7CmZH7UI8UgB8cHNYwG0mO9ud7EQasfU9BohAyTs38pW1q5yR7V/rmsV6
         3z7xIzacyVmdKQ/9shgTt0emWA1AdNvEg5pfPXcaT3/jj/tqCIOswi1UbNhmL6a8bcG3
         aWMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=J2AboHUHvwMct3f9rNsQ3BzKZ3JxYpUIlcBNty+wXZw=;
        b=bj7OukhTfFM8cpKHMCpKGiV+JCVAH9QNiqZujB19bN0d35dUTg9XG9kxMRmo2YdWRl
         p33EsteOQULYfeFbKwoeqa13jIa6P/pk/Nk9wO2pg4Qq4iGbQSxiWrCKUL1zMHuJf3pT
         URl9hqRjS8s8gcK2WIVTKQy4Sq2rdqG2tqAGxL4V+sLPNgfrVU1eLlSkyZfsa9c3DB6X
         PfFVJLpY0VB0uBk7oBqpgy4XQqFVEuYSJDZtOq2kL8tO18hjFHg3VjPxcqtR4HVKg+xf
         zYZ+VhtAm3sHR8XkJbRmFmAKCihLxMg9RMB8WZUorkkwjJJZTGVDUNlf4wNnjfHGYuq8
         8CnQ==
X-Gm-Message-State: AOAM532xfaUnASrk4thlLlQ16SfY8m0Uj+qupfz9dyN1yViIpsmF34eB
        Oz13eHoNeTGWYc0Crwa1dzVXuESFpFVxNxnXFNdGxmfweg8=
X-Google-Smtp-Source: ABdhPJwjYPVk/57Zb7UQgNvlV//aKfcmJXLDk9OnQ8i5V/ZDhrpg1Iscn78tGeqkCKWY6GFtktg7yu42KNIKMj9W5rY=
X-Received: by 2002:a63:2845:: with SMTP id o66mr6540401pgo.77.1600664733199;
 Sun, 20 Sep 2020 22:05:33 -0700 (PDT)
MIME-Version: 1.0
From:   Topi Wala <walatopi@gmail.com>
Date:   Sun, 20 Sep 2020 22:05:22 -0700
Message-ID: <CAOfgOfuNuRo_dNO=RJcz1XiK_=hZmdopG12XcUFB_s0No3vsRw@mail.gmail.com>
Subject: 
To:     xdp-newbies@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <xdp-newbies.vger.kernel.org>
X-Mailing-List: xdp-newbies@vger.kernel.org

I have a setup that has 2 namespaces, connected using a linux bridge,
with veth pairs in each of the namespace.

ns1=192.168.1.10/24
ns2=192.168.1.11/24
host-br=192.168.1.1/24

I can ping between host, ns1, ns2 fine.

I'm attaching an xdp filter program
https://github.com/xdp-project/xdp-tools/blob/master/xdp-filter/xdpfilt_dny_ip.c

I'm using bpftool to attach this to ns1-host end. I also attach a
dummy xdp prog (that just returns XDP_PASS) to the end inside the ns1.
I see all ping packets to this destination dropped. Dumping
xdp_stats_map does show counters incremented for XDP_DROP

However, when using bpftool to update the filter_ipv4 map to allow
packets with destination to go through, it doesn't work.

./bpftool map update name filter_ipv4 key 192 168 1 10 value 2 0 0 0 0 0 0 0

I've tried with pinned maps, and different combinations of key/value
as well, to no avail. The lookup just doesn't seem to succeed. Any
suggestions on how I might go about debugging this?

--------

Update:

I did try with bpf_printk to see what was going on, and there seems to
be some really weird issue that happens after the bpf map is updated.

So, to keep things simple, I attached the xdp filter program to my
host bridge interface. Pinging the bridge address from either
namespace drops the packet, AND my printk message is logged and I can
read it from /sys/kernel/debug/tracing/trace_pipe

I insert entries into the map, and then when I try to do the same, not
only does it not work, there is no printk message either. Removing
these entries still does not get the printk message back.

How do I go about debugging this? Are there any known issues with
using maps that are not pinned (I have tried with pinning them, but
didn't debug that setup deeply).

Thanks.
Topi
