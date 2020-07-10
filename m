Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:59659 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726820AbgGJLze (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 10 Jul 2020 07:55:34 -0400
Received: by mail-pj1-f69.google.com with SMTP id gp8so3960000pjb.9
        for <xdp-newbies@vger.kernel.org>; Fri, 10 Jul 2020 04:55:31 -0700 (PDT)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: TCP Payload
In-Reply-To: <449BEAB8-F4ED-489D-BF59-8993637268DB@gmail.com>
References: <449BEAB8-F4ED-489D-BF59-8993637268DB@gmail.com>
Date: Fri, 10 Jul 2020 13:55:23 +0200
Message-ID: <87o8onk2j8.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Cameron Boness <xdevps3@gmail.com>, xdp-newbies@vger.kernel.org

Cameron Boness <xdevps3@gmail.com> writes:

> Hi,
>
> I want to be able to read the data being sent in TCP payloads using
> XDP (in c), but so far all I can read is a number of headers
> (eth->iph->tcp->dns). Is it possible to get the TCP payload (i.e.
> client sent data) from xdp_md at all? Been looking online for hours,
> doesn't seem like anyone who's done XDP that's posted about it has
> ever parsed such data, hoping it's possible :(

Could you please be a bit more specific about your problem? What,
exactly, have you tried, and what is the reason why it doesn't work?
Posting code samples and error messages may be helpful...

-Toke
