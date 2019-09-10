Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38182 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730779AbfIJOVv (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 10 Sep 2019 10:21:51 -0400
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 769B789AC2
        for <xdp-newbies@vger.kernel.org>; Tue, 10 Sep 2019 14:21:51 +0000 (UTC)
Received: by mail-ed1-f69.google.com with SMTP id p55so10519765edc.5
        for <xdp-newbies@vger.kernel.org>; Tue, 10 Sep 2019 07:21:51 -0700 (PDT)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: bidirectional: => AF_XDP , <= XDP_REDIRECT
In-Reply-To: <d52b5b48-06cf-42dc-180d-896601cf3efb@yandex.ru>
References: <d52b5b48-06cf-42dc-180d-896601cf3efb@yandex.ru>
Date: Tue, 10 Sep 2019 15:21:46 +0100
Message-ID: <87imq0ut8l.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Ilya Goslhtein <ilejn@yandex.ru>, xdp-newbies@vger.kernel.org

Ilya Goslhtein <ilejn@yandex.ru> writes:

> Hello,
>
> I am trying to use a network interface to
> (1) send packets via AF_XDP
> (2) receive packets and redirect to another interface via xdp_redirect_map
>
> Basically, I am making xdpbridge https://github.com/ilejn/xdpbridge.
>   bidirectional. My goal is to process packets in one direction in 
> kernelspace (xdp_redirect_map) and to pass packets in opposite direction 
> via userspace (recieve via AF_XDP then send via AF_XDP, rings are not 
> shared, so I perform memcpy).
>
> For test purposes I ran two applications: my xdpbridge and 
> xdp_redirect_map bpf sample.
>
> It does not work. Only few packets are received, then the thing stops. 
> Redirecting works until xdpbridge does 'bind' against the interface.

This is because the AF_XDP application loads another XDP program on the
interface that redirects the traffic into the socket. It is possible to
write an XDP program that can do both (i.e., for each packet, decide
whether to redirect it into the AF_XDP socket, or to another interface),
but obviously none of the example programs know how to do this, so they
end up stepping on each other's toes...

-Toke
