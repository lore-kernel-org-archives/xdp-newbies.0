Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from fromintoutb.tno.nl ([134.221.1.27]:23089 "EHLO
        fromintoutb.tno.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751535AbdF1Iq1 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 28 Jun 2017 04:46:27 -0400
From: "Panneman, J.J. (Jeffrey)" <jeffrey.panneman@tno.nl>
Subject: UDP checksum calculation
Date: Wed, 28 Jun 2017 08:46:25 +0000
Message-ID: <7784F3C775469047B0E8C3B494DB28BEB1B143@EXC-MBX03.tsn.tno.nl>
References: <7784F3C775469047B0E8C3B494DB28BEB1B126@EXC-MBX03.tsn.tno.nl>
In-Reply-To: <7784F3C775469047B0E8C3B494DB28BEB1B126@EXC-MBX03.tsn.tno.nl>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>

Hi All,

I posted this question in the Cillium Slack too, but I figured posting it here might help other people too.
I checked out the Cillium source(from what I see makes use of the provided tc-helpers: https://github.com/cilium/cilium/blob/master/bpf/lib/csum.h), but is there an appropriate way to do checksum (re)calculation for UDP with XDP ? Since it does not really like long loops that much and the payload possibly being quite long. I don't really see a way to loop over the payload to recalculate the checksum, would anyone perhaps have a code snippet for this ?

Kind regards,

Jeffrey
This message may contain information that is not intended for you. If you are not the addressee or if this message was sent to you by mistake, you are requested to inform the sender and delete the message. TNO accepts no liability for the content of this e-mail, for the manner in which you use it and for damage of any kind resulting from the risks inherent to the electronic transmission of messages.
