Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:34129 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751520AbdF1JSX (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 28 Jun 2017 05:18:23 -0400
Message-ID: <59537453.6080407@iogearbox.net>
Date: Wed, 28 Jun 2017 11:18:11 +0200
From: Daniel Borkmann <daniel@iogearbox.net>
MIME-Version: 1.0
Subject: Re: UDP checksum calculation
References: <7784F3C775469047B0E8C3B494DB28BEB1B126@EXC-MBX03.tsn.tno.nl> <7784F3C775469047B0E8C3B494DB28BEB1B143@EXC-MBX03.tsn.tno.nl>
In-Reply-To: <7784F3C775469047B0E8C3B494DB28BEB1B143@EXC-MBX03.tsn.tno.nl>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: "Panneman, J.J. (Jeffrey)" <jeffrey.panneman@tno.nl>
Cc: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>

On 06/28/2017 10:46 AM, Panneman, J.J. (Jeffrey) wrote:
> Hi All,
>
> I posted this question in the Cillium Slack too, but I figured posting it here might help other people too.
> I checked out the Cillium source(from what I see makes use of the provided tc-helpers: https://github.com/cilium/cilium/blob/master/bpf/lib/csum.h), but is there an appropriate way to do checksum (re)calculation for UDP with XDP ? Since it does not really like long loops that much and the payload possibly being quite long. I don't really see a way to loop over the payload to recalculate the checksum, would anyone perhaps have a code snippet for this ?

Depends on the use-case, are you rewriting also UDP payload
in XDP? If not, why is [1] not sufficient resp. a variant of
that which calcs the diff? csum_diff() could be an option, but
why not doing it in BPF itself?

   [1] http://lingrok.org/xref/linux-net-next/tools/testing/selftests/bpf/test_xdp.c#141
