Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from fromintouta.tno.nl ([134.221.1.26]:10865 "EHLO
        fromintouta.tno.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751130AbdFUNff (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 21 Jun 2017 09:35:35 -0400
From: "Panneman, J.J. (Jeffrey)" <jeffrey.panneman@tno.nl>
Subject: FW: Cannot add integer value with N upper zero bits to ptr_to_packet
Date: Wed, 21 Jun 2017 13:35:27 +0000
Message-ID: <7784F3C775469047B0E8C3B494DB28BEB0F5DA@EXC-MBX03.tsn.tno.nl>
References: <7784F3C775469047B0E8C3B494DB28BEB0F5BC@EXC-MBX03.tsn.tno.nl>
In-Reply-To: <7784F3C775469047B0E8C3B494DB28BEB0F5BC@EXC-MBX03.tsn.tno.nl>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>

Hi All,

I currently have another issue which seems rather weird. I have a variable with type uint8_t, this is passed as reference to a function in which it gets a value. When I do this a single time, the variable gets a value and I can print it with the trace print call. Now when I do this a second time, I get the 'cannot add integer value with 0 upper zero bits to ptr_to_packet' message, I have also tried to create another variable and assign it to this but this did not resolve anything.

is there some restrictions on changing values ? The message doesn't really give me enough to work out the exact issue.

Happy to provide verifier output and code for those who might have an idea.

Kind regards,

Jeffrey Panneman
This message may contain information that is not intended for you. If you are not the addressee or if this message was sent to you by mistake, you are requested to inform the sender and delete the message. TNO accepts no liability for the content of this e-mail, for the manner in which you use it and for damage of any kind resulting from the risks inherent to the electronic transmission of messages.
