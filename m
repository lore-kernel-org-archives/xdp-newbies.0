Return-Path: <xdp-newbies-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F9ADC433ED
	for <xdp-newbies@archiver.kernel.org>; Thu, 29 Apr 2021 09:27:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E323761445
	for <xdp-newbies@archiver.kernel.org>; Thu, 29 Apr 2021 09:27:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237363AbhD2J2Q (ORCPT <rfc822;xdp-newbies@archiver.kernel.org>);
        Thu, 29 Apr 2021 05:28:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40844 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233046AbhD2J2P (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 29 Apr 2021 05:28:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619688448;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xf4XcdY2iBSN5n+BPAhMyCf5+oEM4bl+rsnTJXoRk04=;
        b=Kw9Qln9Qo0P0ey6O5OTM0MJ5qIqfediior7EPS8IiU48vKJfKXux2i9QzKWnz6Pgs44xxP
        ELOzdawNlncT+O8dJ8S9sG+Ie8w53u6Q5her11zy4UgouOZhSOqA/lK+cfHyS3EfBCplbW
        DWMuoKYpSE0cNiuTX8fA9FLMKWl4HsY=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-512-D3tMUhUtOUmwEjaQIP90uw-1; Thu, 29 Apr 2021 05:27:26 -0400
X-MC-Unique: D3tMUhUtOUmwEjaQIP90uw-1
Received: by mail-ed1-f72.google.com with SMTP id k10-20020a50cb8a0000b0290387e0173bf7so4391083edi.8
        for <xdp-newbies@vger.kernel.org>; Thu, 29 Apr 2021 02:27:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=xf4XcdY2iBSN5n+BPAhMyCf5+oEM4bl+rsnTJXoRk04=;
        b=i6lpFP3UCGZO+Sa06Dl3uGUzblI0di6pClZnpNu6yXE+6s94QVvAsV+QcYwiNq+eVz
         Br8xzi/IzrSnO6DDK0M2psipOGrXI7vBRdfqtv7P+8hnJUraAdWHYxMYbzjKFg8kswiG
         MNHxRNSHfb14Lx1UeRJtsEe9GgJi+IKBIZAbQtjsLId82tTPeFMJv0V0v10voBpbMkSo
         pDkdM9yBkkbjEtCWgHkVRirssAsnklfs+fzoYHYn/D9jERXft9r3ij+YLUemF3Vt59IK
         1YPuwhzV93dL71L7KYkxSfwAcSajBqqtW3i+N0neiBdwqEnauN7zaPuFUZivh5540sNm
         6LFg==
X-Gm-Message-State: AOAM532EpsGG5DtS3GReHQRgsd6z0rQolBYBiiwIRFfmJqL/qJP85fTC
        zsGKjwHfArMdwUqbJ3xOBZORZu9pVn74ibgcYSBB9ikpl04tQLo4dbSU6cHf18S7yhU8fZqZvyu
        J2VirAbmTyx0vwflCNqYCiW8=
X-Received: by 2002:a17:906:b191:: with SMTP id w17mr34045284ejy.200.1619688445488;
        Thu, 29 Apr 2021 02:27:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwQZjBhQoHFqAaw05LsC9HysLJuukCuvzbYk/XXbqunv3psuiczsXMwR32Cl0qI5xPuN8YSIQ==
X-Received: by 2002:a17:906:b191:: with SMTP id w17mr34045258ejy.200.1619688445096;
        Thu, 29 Apr 2021 02:27:25 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id d12sm1464502ejd.8.2021.04.29.02.27.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Apr 2021 02:27:24 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B872D1802D6; Thu, 29 Apr 2021 11:27:23 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Christian Deacon <gamemann@gflclan.com>,
        xdp-newbies@vger.kernel.org
Subject: Re: Sending A Separate Packet Out The TX Path In XDP
In-Reply-To: <389750c6-6a31-fe80-7fa2-56fbec888534@gflclan.com>
References: <d153ed73-3a46-cbf9-c9b7-947926083027@gflclan.com>
 <87wnsn8oxr.fsf@toke.dk>
 <389750c6-6a31-fe80-7fa2-56fbec888534@gflclan.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 29 Apr 2021 11:27:23 +0200
Message-ID: <875z058mpw.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <xdp-newbies.vger.kernel.org>
X-Mailing-List: xdp-newbies@vger.kernel.org

Christian Deacon <gamemann@gflclan.com> writes:

> Hey Toke,
>
>
> That makes sense! I'm going to look into using AF_XDP sockets to achieve 
> this.
>
>
> As always, thank you for all your help!

You're welcome! :)

-Toke

