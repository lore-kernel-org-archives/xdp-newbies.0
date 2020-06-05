Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728314AbgFEXe4 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Fri, 5 Jun 2020 19:34:56 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE742C08C5C2
        for <xdp-newbies@vger.kernel.org>; Fri,  5 Jun 2020 16:34:56 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id g62so6496903qtd.5
        for <xdp-newbies@vger.kernel.org>; Fri, 05 Jun 2020 16:34:56 -0700 (PDT)
Subject: Re: Lightweight packet timestamping
References: <DB7PR08MB3130BDD01387627E7FAD775F9E890@DB7PR08MB3130.eurprd08.prod.outlook.com>
 <DB7PR08MB3130C02AB04133E07146F40D9E890@DB7PR08MB3130.eurprd08.prod.outlook.com>
 <DB7PR08MB3130BA2C0F90E0819577C5289E890@DB7PR08MB3130.eurprd08.prod.outlook.com>
From: David Ahern <dsahern@gmail.com>
Message-ID: <b712de09-fd35-1d5e-1842-31bb3b2e163d@gmail.com>
Date: Fri, 5 Jun 2020 17:34:53 -0600
MIME-Version: 1.0
In-Reply-To: <DB7PR08MB3130BA2C0F90E0819577C5289E890@DB7PR08MB3130.eurprd08.prod.outlook.com>
Content-Language: en-US
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Federico Parola <fede.parola@hotmail.it>, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>

On 6/4/20 7:30 AM, Federico Parola wrote:
> Hello everybody,
> I'm implementing a token bucket algorithm to apply rate limit to traffic and I need the timestamp of packets to update the bucket. To get this information I'm using the bpf_ktime_get_ns() helper but I've discovered it has a non negligible impact on performance. I've seen there is work in progress to make hardware timestamps available to XDP programs, but I don't know if this feature is already available. Is there a faster way to retrieve this information?
> Thanks for your attention.
> 

bpf_ktime_get_ns should be fairly light. What kind of performance loss
are you seeing with it?

XDP does not support access to h/w timestamps at the moment.
