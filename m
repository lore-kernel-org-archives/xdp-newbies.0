Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:55908 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726160AbgFBJBx (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 2 Jun 2020 05:01:53 -0400
Received: by mail-ej1-f70.google.com with SMTP id e14so3837396ejt.16
        for <xdp-newbies@vger.kernel.org>; Tue, 02 Jun 2020 02:01:50 -0700 (PDT)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: XDP_REDIRECT with xsks_map and dev_map
In-Reply-To: <CA+Jwd2y5Pjh+QMrH9vjBtHhvG2EC1MCfm-A2Pq2hjRPEvJ1J1Q@mail.gmail.com>
References: <CA+Jwd2y5Pjh+QMrH9vjBtHhvG2EC1MCfm-A2Pq2hjRPEvJ1J1Q@mail.gmail.com>
Date: Tue, 02 Jun 2020 11:01:47 +0200
Message-ID: <87d06hzvr8.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: maharishi bhargava <bhargavamaharishi@gmail.com>, xdp-newbies@vger.kernel.org

maharishi bhargava <bhargavamaharishi@gmail.com> writes:

> Hi, in my XDP program, I want to redirect some packets using AF_XDP
> and redirect other packets directly from driver space.
> Redirection through AF_XDP works fine, but redirection through dev map
> stops after some packets are processed.

Do you mean it stops even if you are *only* redirecting to a devmap, or
if you are first redirecting a few packets to AF_XDP, then to devmap?

Also, which driver(s) are the physical NICs you're redirecting to/from
using, and which kernel version are you on?

-Toke
