Return-Path: <SRS0=CsYz=C6=vger.kernel.org=xdp-newbies-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78320C43464
	for <xdp-newbies@archiver.kernel.org>; Mon, 21 Sep 2020 09:45:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23FB9218AC
	for <xdp-newbies@archiver.kernel.org>; Mon, 21 Sep 2020 09:45:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B6CK+fr8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbgIUJo6 (ORCPT <rfc822;xdp-newbies@archiver.kernel.org>);
        Mon, 21 Sep 2020 05:44:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47247 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726424AbgIUJo5 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 21 Sep 2020 05:44:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600681496;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sve+S4+lDv5/DFs/4bcWRRnLWnMaS/OHA68W5PrZkGc=;
        b=B6CK+fr8DCZEYmCzUsJeIYqaD5EgaFEsKO17XbSkcHQX306qyTy3zvdQ6eHQ90V1oXDZzi
        Z/VZryba3VAeoVMabwQ8uXEqnRc/YcfwR+oiuZIk1tMGKSR2Wx+ilK0lpsj6+rlJFPxnXo
        jc0D03bIC2wYnQQJIfuSspPvM9xPFts=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-242-hFilZe2vPBiJH9JI60BzVA-1; Mon, 21 Sep 2020 05:44:41 -0400
X-MC-Unique: hFilZe2vPBiJH9JI60BzVA-1
Received: by mail-ed1-f71.google.com with SMTP id m10so4431806edj.3
        for <xdp-newbies@vger.kernel.org>; Mon, 21 Sep 2020 02:44:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=sve+S4+lDv5/DFs/4bcWRRnLWnMaS/OHA68W5PrZkGc=;
        b=Np3VY0o9QKdGdQuHFxRMui+Ih5vJgfzeWTTEqPaCfRv/TGs7vtoL4Ti91oIUnNaknF
         zgWlcDSeolgSUnYZLT8DGA4H3PZ9KtpsnSaktXDn1BOp/L6HImqN3PfyUgg6Yc04BHkV
         0ejdrPLcy07a9SgcP+5l8jm/jsGIJ9MX0im3frXnFAq/xHboko2F/d0JMQDntgd9NaPu
         McBzSqcpTGvyDEMjg9nvutHBUGh2sWJlsFmuDTd7czTkER3BqU/jpA8rpBwhulOtfT/5
         3zlx7g3l8LHfKY/wp9rkbfk2Ki4mABTR2G68NZKYWsKA52J/tZe2s6BcJPlKTASZ+h3s
         OKRA==
X-Gm-Message-State: AOAM531KXXo1Getqb4viy/WLOW6gsugSPSNfDX7lL6PNlEA50edDjEWQ
        2F02PXdve6/7XpNo24OPp7yItwZFUqZOVzKlYfNxxyOs7dNFfRKu4Bbl18ybdV3vzgnbfdw9cjP
        t5UClCvOCrKxuaKQuk1orFfI=
X-Received: by 2002:a50:8d57:: with SMTP id t23mr51968528edt.308.1600681480227;
        Mon, 21 Sep 2020 02:44:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwPsgHPeSWDOtrLBtBp3V3dmbhM+/l8q68MBFR4Cq+VJ5/mW325caB7w0oVSPEZ9TMP28LFrw==
X-Received: by 2002:a50:8d57:: with SMTP id t23mr51968509edt.308.1600681479973;
        Mon, 21 Sep 2020 02:44:39 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id r27sm5269555edx.33.2020.09.21.02.44.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2020 02:44:39 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 0113F183A90; Mon, 21 Sep 2020 11:44:37 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Topi Wala <walatopi@gmail.com>, xdp-newbies@vger.kernel.org
Subject: Re: xdp-filter troubles
In-Reply-To: <CAOfgOfuNuRo_dNO=RJcz1XiK_=hZmdopG12XcUFB_s0No3vsRw@mail.gmail.com>
References: <CAOfgOfuNuRo_dNO=RJcz1XiK_=hZmdopG12XcUFB_s0No3vsRw@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 21 Sep 2020 11:44:37 +0200
Message-ID: <87blhzqxa2.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <xdp-newbies.vger.kernel.org>
X-Mailing-List: xdp-newbies@vger.kernel.org

[ adding a subject - please make sure to include one in the future ]

> I have a setup that has 2 namespaces, connected using a linux bridge,
> with veth pairs in each of the namespace.
>
> ns1=192.168.1.10/24
> ns2=192.168.1.11/24
> host-br=192.168.1.1/24
>
> I can ping between host, ns1, ns2 fine.
>
> I'm attaching an xdp filter program
> https://github.com/xdp-project/xdp-tools/blob/master/xdp-filter/xdpfilt_dny_ip.c
>
> I'm using bpftool to attach this to ns1-host end. I also attach a
> dummy xdp prog (that just returns XDP_PASS) to the end inside the ns1.
> I see all ping packets to this destination dropped. Dumping
> xdp_stats_map does show counters incremented for XDP_DROP
>
> However, when using bpftool to update the filter_ipv4 map to allow
> packets with destination to go through, it doesn't work.
>
> ./bpftool map update name filter_ipv4 key 192 168 1 10 value 2 0 0 0 0 0 0 0
>
> I've tried with pinned maps, and different combinations of key/value
> as well, to no avail. The lookup just doesn't seem to succeed. Any
> suggestions on how I might go about debugging this?

What kernel version are you using? And how are you attaching the program
- from your description I'm guessing you may be using generic XDP? Also,
why are you using bpftool to load the program instead of just using the
xdp-filter binary?

-Toke

