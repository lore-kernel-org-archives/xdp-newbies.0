Return-Path: <xdp-newbies-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5017C3DA7A
	for <xdp-newbies@archiver.kernel.org>; Fri,  6 Jan 2023 03:02:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231777AbjAFDB7 (ORCPT <rfc822;xdp-newbies@archiver.kernel.org>);
        Thu, 5 Jan 2023 22:01:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231719AbjAFDBQ (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Thu, 5 Jan 2023 22:01:16 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D3741B9C2
        for <xdp-newbies@vger.kernel.org>; Thu,  5 Jan 2023 19:00:57 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id f20so320850lja.4
        for <xdp-newbies@vger.kernel.org>; Thu, 05 Jan 2023 19:00:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=e2J7DLVF2+bonPg5Z9tTgHFzcTk0M84FeJpMJsh7c3A=;
        b=fdhbGW1+XFlHK9BfqDC3jW0kGTuXBI1JkfQNRbhKq403V9/22K23+KDejp/cWD8X72
         lgLrruzfx8PuP7B5bBB4KCdTl8Fj4W/aNg6+II/mz+rtaHCo2MZPeU5uTAlMGfNfm+ip
         kg/cb/ufkwGGsZpngksumY479PDguRWaiqgUqm3ulWaennZo6VZXPHypaOKIXcUojX/q
         ekRlO4zqzC2g7ldegeeLkGNPHkOaGk8zatXaRO8LhCuVKCJSXHBf3db8WHE5m0BLSlTD
         aajJD53EW27M2r1BrRvoFDL69bCgxhSTCyoBQvUWefaGX/CeFNBOZr9l4h2feaTa9wjf
         i3fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=e2J7DLVF2+bonPg5Z9tTgHFzcTk0M84FeJpMJsh7c3A=;
        b=MoS4mf1nHfk8aL4v6C94Mpt3APd7RIhS/bmnBu4yLTXj+3mJEUGrA1l1hoUe4UFwNM
         3G8Wr4C548ulSzYe9cd/kEdsVSTAs/SpqZbYlRMTJJsVxVgE4ppnK86aAi79DwkWoyQE
         cX9en5bxnTmw3iGR+tSg/d/CJrh402oSi4SI6G3Vus+o1fxXGE4iFfTSdgxOBXranI2d
         M0VI6lDyD7KQb4IeEfPuOm5/Y8/+R3+Dr0D/1wYcM9nfe52MILpd25xwaWZdARdG5Tha
         DU+NIdfmnCE+MI32219JFEGjY4VrrlJEMqfKKEBuTvDyOW2A2p8BX5cQCKWFZNcTtktr
         qUCA==
X-Gm-Message-State: AFqh2kpSokKnPswYTJhu8h8KYCDpOFOzQ6MF2C0KS7cwry3CTXl9D6lp
        OmffctZhe6bn+V46sETmTkprBBelmTg1YQKpkZ3ytYFA
X-Google-Smtp-Source: AMrXdXt4IiNT2myqw1bHsfhnorpPYgm/uyST01L6uqkwvi9/Tsik0LLd5qpLaSK8TSzsEVC/LKaiUjAW5/7nSHHW5PI=
X-Received: by 2002:a2e:9805:0:b0:27f:c51a:a069 with SMTP id
 a5-20020a2e9805000000b0027fc51aa069mr2323599ljj.487.1672974056101; Thu, 05
 Jan 2023 19:00:56 -0800 (PST)
MIME-Version: 1.0
From:   team lnx <teamlnxi8@gmail.com>
Date:   Thu, 5 Jan 2023 19:00:44 -0800
Message-ID: <CAOLRUnCA-D-P4FQiHTGXypXRv+O+rRg2Pe4z=0Zz6hCDZkG=vw@mail.gmail.com>
Subject: Pause and unpause queue
To:     xdp-newbies@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <xdp-newbies.vger.kernel.org>
X-Mailing-List: xdp-newbies@vger.kernel.org

Hello everyone,

1. Is there a way to pause/unpause queue ?
2.  Is QoS (work in progress for XDP) ? Can we use work in progress
series if  there exists any ?

Thanks !
