Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:24716 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731181AbgERSCQ (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 18 May 2020 14:02:16 -0400
Received: by mail-lf1-f71.google.com with SMTP id r143so3906721lff.13
        for <xdp-newbies@vger.kernel.org>; Mon, 18 May 2020 11:02:11 -0700 (PDT)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: XDP_PASS and XDP_REDIRECT
In-Reply-To: <DM6PR18MB2475DD12FB5A8D747CA6ABEF9CB80@DM6PR18MB2475.namprd18.prod.outlook.com>
References: <DM6PR18MB2475DD12FB5A8D747CA6ABEF9CB80@DM6PR18MB2475.namprd18.prod.outlook.com>
Date: Mon, 18 May 2020 20:02:08 +0200
Message-ID: <87eerhnmu7.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: "Main, George" <mainge@rose-hulman.edu>, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>

"Main, George" <mainge@rose-hulman.edu> writes:

> Hello All,
>
> I am working on an XDP Content Based Router project. The basic concept
> is that a machine running an XDP program acts as a gateway and accepts
> TCP connections from outside machines. Upon receiving a message it
> converts the packet to UDP and uses bpf_redirect_map to send the
> packet out through another interface.
>
> The problem I am encountering is that I want to be able to pass the
> message to userspace (where the TCP server resides) using XDP_PASS in
> addition to the redirect. I'm somewhat looking for a way to emulate
> the functionality of bpf_clone_redirect, but with support for XDP
> driver mode.
>
> Is this even possible right now? Are there any workarounds?

I am not sure I quite understand what it is you're trying to do, but no,
there is currently no way to get more than a single action for the same
packet.

-Toke
