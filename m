Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45224 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726174AbfFQK5O (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 17 Jun 2019 06:57:14 -0400
Received: by mail-wr1-f65.google.com with SMTP id f9so9383503wre.12
        for <xdp-newbies@vger.kernel.org>; Mon, 17 Jun 2019 03:57:12 -0700 (PDT)
Date: Mon, 17 Jun 2019 13:57:09 +0300
From: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: Re: AF_XDP and packet timestamp
Message-ID: <20190617105709.GA7734@apalos>
References: <86f135475a7820adadb05e7ac9a05c71846bebd6.camel@regit.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86f135475a7820adadb05e7ac9a05c71846bebd6.camel@regit.org>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Eric Leblond <eric@regit.org>
Cc: xdp-newbies@vger.kernel.org

Hi Eric, 

> Hello,
> 
> I did start to work on AF_XDP support for Suricata. API was really easy
> to use via libbpf.
> 
> From Suricata point of view, the current system with default
> configuration is lacking an important information. I don't have access
> to the timestamp of the packet. I'm in particular interested by the
> hardware timestamp as it would allow to do reordering in some capture
> cases.
There's no timestamp available to my knowledge
> 
> Is there a way to get the information via AF_XDP. I've seen the
> discussion on hardware hints but there was no code example I was able
> to find. 
This is an awful hack i did when i needed similar information [1]
Essentially i am copying a software 'timestamp' (in my case rdtsc() since i
needed to measure packet timings from AF_XDP -> userspace), into the meta_data
of XDP.
The way i did it is obviously wrong since it has to be added per driver.
> 
> BR,
> -- 
> Eric Leblond <eric@regit.org>
> 

[1] https://github.com/xdp-project/xdp-project/blob/master/areas/arm64/xdp_for_tsn.org

Cheers
/Ilias
