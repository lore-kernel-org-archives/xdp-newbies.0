Return-Path: <xdp-newbies-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F702C433E0
	for <xdp-newbies@archiver.kernel.org>; Wed, 10 Feb 2021 11:39:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E2B464E3B
	for <xdp-newbies@archiver.kernel.org>; Wed, 10 Feb 2021 11:39:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbhBJLjG (ORCPT <rfc822;xdp-newbies@archiver.kernel.org>);
        Wed, 10 Feb 2021 06:39:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38628 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229600AbhBJLhR (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 10 Feb 2021 06:37:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612956931;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oq0JixAirNArsG1yV0fjf+moucNqw66OwOlbHrqrb38=;
        b=JUB3NDK/6u5AGk8Ywut1hXTS+FPq1ylN2/ln4it07+ck1Aae7yL9wmviU9mk8pb8n3nKUB
        W/QOVnzIEUynKH4scG80v1rEOFVbepoMSnY8rVs2pyKja/HBcBRmBWvX69ohkDLG0Yn9Vx
        +St9zNJiCwOFzRfI1TUbzmPPWeNCENE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-105-pukLqfHeN02oy9RfhH1o7A-1; Wed, 10 Feb 2021 06:35:29 -0500
X-MC-Unique: pukLqfHeN02oy9RfhH1o7A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 53D281966322;
        Wed, 10 Feb 2021 11:35:28 +0000 (UTC)
Received: from carbon (unknown [10.36.110.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1059360C62;
        Wed, 10 Feb 2021 11:35:22 +0000 (UTC)
Date:   Wed, 10 Feb 2021 12:35:21 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Radu Stoenescu <radu.stoe@gmail.com>,
        "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>,
        brouer@redhat.com, Jakub Kicinski <kuba@kernel.org>
Subject: Re: Redirect from NIC to TAP
Message-ID: <20210210123521.1ea112bc@carbon>
In-Reply-To: <fe13ccc1-9ccf-8f58-b8a8-45300f970ac2@redhat.com>
References: <CAM-scZPPeu44FeCPGO=Qz=03CrhhfB1GdJ8FNEpPqP_G27c6mQ@mail.gmail.com>
        <20210209102118.476f507d@carbon>
        <CAM-scZNLN5cgJBEdVFSSrLJi3zW-5THzbY=diESdKiiisCT9MQ@mail.gmail.com>
        <fe13ccc1-9ccf-8f58-b8a8-45300f970ac2@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <xdp-newbies.vger.kernel.org>
X-Mailing-List: xdp-newbies@vger.kernel.org

On Wed, 10 Feb 2021 11:42:10 +0800
Jason Wang <jasowang@redhat.com> wrote:

> On 2021/2/9 =E4=B8=8B=E5=8D=885:26, Radu Stoenescu wrote:
> > Hello
> >
> > My physical NIC is a Netronome (I can come back with exact model type
> > and driver version).
> >
> > Redirect NIC to TAP doesn't work when XDP is attached in driver mode.
> > It works when they are both in generic mode. I haven't tried other
> > combinations of attachment modes (one driver, other generic etc.). =20
>=20
>=20
> It should work. I tested with i40e/ixgbe/mlx4 in the past.
>=20
> What eBPF program did you use? (Is it the one in samples/bpf?)
>=20
> I would test it by myself.
>=20
> (It's near to spring festival, so I can only check after the holiday).

As Maciej Fijalkowski pointed out:
 "Looks like Netronome driver still doesn't support XDP_REDIRECT in native
mode."

So, that is likely the problem.
--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

