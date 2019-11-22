Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:52507 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730803AbfKVK62 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 22 Nov 2019 05:58:28 -0500
Received: by mail-lf1-f70.google.com with SMTP id o140so1688508lff.18
        for <xdp-newbies@vger.kernel.org>; Fri, 22 Nov 2019 02:58:26 -0800 (PST)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <thoiland@redhat.com>
Subject: Re: Access Hardware Timestamp in eBPF Program
In-Reply-To: <20191121231636.GA5888@DEV.igk.intel.com>
References: <ce15150c-01e4-5621-0d13-ebe0f7cd2333@web.de> <20191121231636.GA5888@DEV.igk.intel.com>
Date: Fri, 22 Nov 2019 11:58:23 +0100
Message-ID: <87imnc5ga8.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: Piotr Raczynski <piotr.raczynski@intel.com>, Christoph Kuhr <christoph.kuhr@web.de>
Cc: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>

Piotr Raczynski <piotr.raczynski@intel.com> writes:

>> Is there a way to access such timestamps in a XDP eBPF program?
>
> Unfortunately, as of now there is no universal way for XDP programs,
> even in native mode, to access information taken from hardware,
> e.g. from Rx descriptor. Technically it would be possible, but there
> are no interfaces now that would allow common scheme for different
> drivers.

Adding this is on the TODO list, though:
https://github.com/xdp-project/xdp-project/blob/master/xdp-project.org#metadata-available-to-programs

-Toke
