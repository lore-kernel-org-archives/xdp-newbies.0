Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726447AbgERIvY (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 18 May 2020 04:51:24 -0400
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7181C061A0C
        for <xdp-newbies@vger.kernel.org>; Mon, 18 May 2020 01:51:23 -0700 (PDT)
Received: by mail-vs1-xe35.google.com with SMTP id o26so5058873vsr.10
        for <xdp-newbies@vger.kernel.org>; Mon, 18 May 2020 01:51:23 -0700 (PDT)
MIME-Version: 1.0
References: <ba88e0ff11b940fe8855a0dd43c947ae@hm.edu>
In-Reply-To: <ba88e0ff11b940fe8855a0dd43c947ae@hm.edu>
From: Magnus Karlsson <magnus.karlsson@gmail.com>
Date: Mon, 18 May 2020 10:51:11 +0200
Message-ID: <CAJ8uoz1wQcCN6N_NPQhG5OFOyBp-a2Mqwh+nqeTGYqOeL_dCLw@mail.gmail.com>
Subject: Re: How does the Kernel decide which Umem frame to choose for the
 next packet?
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
To: "Gaul, Maximilian" <maximilian.gaul@hm.edu>
Cc: Xdp <xdp-newbies@vger.kernel.org>

On Mon, May 18, 2020 at 10:39 AM Gaul, Maximilian
<maximilian.gaul@hm.edu> wrote:
>
> Hello,
>
> I read through the paper "The Path to DPDK Speeds for AF XDP" but I couldn't find information about how the Kernel choses the Umem frame for the next packet? Or in case of zero-copy, how the driver decides which Umem frame to chose.
> But maybe I just overlooked it.
>
> So how does this work?

User-space decides this by what frames it enters into the fill ring.
Kernel-space uses the frames in order from that ring.

/Magnus

> Best regards
>
> Max
