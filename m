Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-ed1-f65.google.com ([209.85.208.65]:36666 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726164AbfFQLDR (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 17 Jun 2019 07:03:17 -0400
Received: by mail-ed1-f65.google.com with SMTP id k21so15579057edq.3
        for <xdp-newbies@vger.kernel.org>; Mon, 17 Jun 2019 04:03:16 -0700 (PDT)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: AF_XDP and packet timestamp
In-Reply-To: <86f135475a7820adadb05e7ac9a05c71846bebd6.camel@regit.org>
References: <86f135475a7820adadb05e7ac9a05c71846bebd6.camel@regit.org>
Date: Mon, 17 Jun 2019 13:03:14 +0200
Message-ID: <87d0jca2z1.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Eric Leblond <eric@regit.org>, xdp-newbies@vger.kernel.org

Eric Leblond <eric@regit.org> writes:

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
>
> Is there a way to get the information via AF_XDP. I've seen the
> discussion on hardware hints but there was no code example I was able
> to find.

Making more information from the hardware available to XDP is currently
on our list of things we plan to enable in the future:
https://github.com/xdp-project/xdp-project/blob/master/xdp-project.org#metadata-available-to-programs

I just added timestamps as a field we want in there (so we don't
forget).

I.e., no, there is no way to get this information from XDP (and thus not
from AF_XDP either) yet...

-Toke
