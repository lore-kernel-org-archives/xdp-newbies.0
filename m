Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:47342 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753377AbdHTWs1 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Sun, 20 Aug 2017 18:48:27 -0400
Message-ID: <599A11B8.9030906@iogearbox.net>
Date: Mon, 21 Aug 2017 00:48:24 +0200
From: Daniel Borkmann <daniel@iogearbox.net>
MIME-Version: 1.0
Subject: Re: What library to use ?
References: <1503234237.13034.9.camel@regit.org>
In-Reply-To: <1503234237.13034.9.camel@regit.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Eric Leblond <eric@regit.org>
Cc: xdp-newbies@vger.kernel.org

On 08/20/2017 03:03 PM, Eric Leblond wrote:
[...]
> I've just started to work again on eBPF and XDP. My target it to work
> on XDP support for Suricata (Daniel if you read me, yes finally ;)
> Target is to be able to start Suricata with --xdp eth5 and get
> everything setup by Suricata to get a working capture.

Great, finally! ;)

> I've done one year ago an implementation of eBPF support in Suricata
> using the library in tools/lib/bpf. One year later is using this
> library the way to go or is there another library ?

Yep, the lib in tools/lib/bpf would be recommended (also used in
tools/testing/selftests/bpf/ for some of the networking selftests
these days, incl. XDP).

Anyway, patches welcome just in case. ;)
