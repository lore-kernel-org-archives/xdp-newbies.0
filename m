Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-yw0-f169.google.com ([209.85.161.169]:34418 "EHLO
        mail-yw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751976AbdHVSC2 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 22 Aug 2017 14:02:28 -0400
Received: by mail-yw0-f169.google.com with SMTP id s143so112595928ywg.1
        for <xdp-newbies@vger.kernel.org>; Tue, 22 Aug 2017 11:02:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170821212506.1cb0d5d6@redhat.com>
References: <20170821212506.1cb0d5d6@redhat.com>
From: Michael Chan <michael.chan@broadcom.com>
Date: Tue, 22 Aug 2017 11:02:27 -0700
Message-ID: <CACKFLimAF9OYwz8EqG=1-N40hWuA-8C8k8ut0oFKYdduvZOxHA@mail.gmail.com>
Subject: Re: XDP redirect measurements, gotchas and tracepoints
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, John Fastabend <john.fastabend@gmail.com>, Daniel Borkmann <borkmann@iogearbox.net>, Andy Gospodarek <andy@greyhouse.net>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, =?UTF-8?Q?Pawe=C5=82_Staszewski?= <pstaszewski@itcare.pl>

On Mon, Aug 21, 2017 at 12:25 PM, Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
> I'be been playing with the latest XDP_REDIRECT feature, that was
> accepted in net-next (for ixgbe), see merge commit[1].
>  [1] https://git.kernel.org/davem/net-next/c/6093ec2dc31
>

Just catching on XDP_REDIRECT and I have a very basic question.  The
ingress device passes the XDP buffer to the egress device for XDP
redirect transmission.  When the egress device has transmitted the
packet, is it supposed to just free the buffer?  Or is it supposed to
be recycled?

In XDP_TX, the buffer is recycled back to the rx ring.
