Return-Path: <xdp-newbies-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBB05C433E0
	for <xdp-newbies@archiver.kernel.org>; Wed, 10 Feb 2021 04:31:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7571F64E4B
	for <xdp-newbies@archiver.kernel.org>; Wed, 10 Feb 2021 04:31:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbhBJEbX (ORCPT <rfc822;xdp-newbies@archiver.kernel.org>);
        Tue, 9 Feb 2021 23:31:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbhBJEbX (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Tue, 9 Feb 2021 23:31:23 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF952C06174A
        for <xdp-newbies@vger.kernel.org>; Tue,  9 Feb 2021 20:30:42 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id v193so656096oie.8
        for <xdp-newbies@vger.kernel.org>; Tue, 09 Feb 2021 20:30:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+3y0hiaUP3iaWMXLDpYaaVA7gDXtjxLdw0RtYQQ9Bj0=;
        b=V+imHLV03rk5zLLI8fDfu/hVwVz5YJMTbNoHQImWxNIU84SLyZFRaZqMYmhN/QCaal
         bleCc+/JlkZZLRTenp7xnyYVlbf3ET8LI2cxDGmqX/2JMy3CJWbrXWQhWuQs2JUiPCz1
         RgcJUa0d5vB4GaEGYYQ2FCOFYss+ZWxuToc92GFE0P23ryd+j2T/+8YeGSrK8jWQ5HSb
         +PpHzFavgZYP9jSoLao01mIZDjCRpua3Nk4hgxDCbcMTIXLAMqp7HEWetTshzv9Ww+bE
         vw29MUs9ej70nJINwDi/CBqvh9zmpSrIeOrpuizRUpEU8m8QNqQ0JQAAm4/xTp2xIGEd
         ZahA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+3y0hiaUP3iaWMXLDpYaaVA7gDXtjxLdw0RtYQQ9Bj0=;
        b=dCqAkynUVEyFbpUa8qaPwuAvmzTILKn49xVfH1YTQRrP38PvJa6u1wUBYCkLLpSKmz
         ukr7uER6zgDR9FAcU7A/g5dIfr7k0KUXA9hFEJ62OMSSQlHytIDOPzEkwvW6LuUirDfq
         b1wBrJm1VWMIVd6//LuD3xMcc+CoFS3H6spTNZp/LZweDHmTBPPale5rxZJEaGD1xFTK
         SrbdkEOSUFLc7+7Q23ScgB15h/PnD/PN+ukkKWdnlOj7WAHZ7uZQqv6DRApF7Q9C7w/l
         oPrF5o51p2sm/EurTfAQLwV8zwlx3JShSLNMsSLXv9U6LArMEubetClyVSVLfss6xxnl
         P5gw==
X-Gm-Message-State: AOAM531bfuwyPgmOiKuWV4JBG9v0EPi6F5eeB0p1hFDTZHVEsGdivLse
        YDavdjwVeSxAEaWlBfxxDXY=
X-Google-Smtp-Source: ABdhPJxFIXipZKq3K1DP/IGoJoOSulMjkMwDuq4s2aPjFPDBonzyU4m91moBna5n8zF1EXjgz6WJ5w==
X-Received: by 2002:a05:6808:a96:: with SMTP id q22mr818643oij.112.1612931442194;
        Tue, 09 Feb 2021 20:30:42 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.33])
        by smtp.googlemail.com with ESMTPSA id g3sm189628ooi.28.2021.02.09.20.30.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Feb 2021 20:30:41 -0800 (PST)
Subject: Re: Redirect from NIC to TAP
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Radu Stoenescu <radu.stoe@gmail.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>,
        simon.horman@netronome.com
References: <CAM-scZPPeu44FeCPGO=Qz=03CrhhfB1GdJ8FNEpPqP_G27c6mQ@mail.gmail.com>
 <20210209102118.476f507d@carbon>
 <CAM-scZNLN5cgJBEdVFSSrLJi3zW-5THzbY=diESdKiiisCT9MQ@mail.gmail.com>
 <20210209094137.GA14290@ranger.igk.intel.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <bf2fc6a2-726f-f020-f676-f71aab603790@gmail.com>
Date:   Tue, 9 Feb 2021 21:30:39 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210209094137.GA14290@ranger.igk.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <xdp-newbies.vger.kernel.org>
X-Mailing-List: xdp-newbies@vger.kernel.org

On 2/9/21 2:41 AM, Maciej Fijalkowski wrote:
> On Tue, Feb 09, 2021 at 11:26:06AM +0200, Radu Stoenescu wrote:
>> Hello
>>
>> My physical NIC is a Netronome (I can come back with exact model type
>> and driver version).
>>
>> Redirect NIC to TAP doesn't work when XDP is attached in driver mode.
>> It works when they are both in generic mode. I haven't tried other
>> combinations of attachment modes (one driver, other generic etc.).
> 

If the driver supports XDP_REDIRECT, it does work.

Take a look at this slide deck for gotcha's with this use case:

https://netdevconf.info/0x14/pub/slides/24/netdev-0x14-XDP-and-the-cloud.pdf
