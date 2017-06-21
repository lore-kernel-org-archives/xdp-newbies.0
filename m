Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-ua0-f179.google.com ([209.85.217.179]:35932 "EHLO
        mail-ua0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752934AbdFUQWl (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 21 Jun 2017 12:22:41 -0400
Received: by mail-ua0-f179.google.com with SMTP id g40so117805335uaa.3
        for <xdp-newbies@vger.kernel.org>; Wed, 21 Jun 2017 09:22:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <7784F3C775469047B0E8C3B494DB28BEB0F5DA@EXC-MBX03.tsn.tno.nl>
References: <7784F3C775469047B0E8C3B494DB28BEB0F5BC@EXC-MBX03.tsn.tno.nl> <7784F3C775469047B0E8C3B494DB28BEB0F5DA@EXC-MBX03.tsn.tno.nl>
From: Y Song <ys114321@gmail.com>
Date: Wed, 21 Jun 2017 08:55:21 -0700
Message-ID: <CAH3MdRXX6UDm9Ru_9k+TVmn5UeK7vM7st5avkbMKdFED9=2X2A@mail.gmail.com>
Subject: Re: FW: Cannot add integer value with N upper zero bits to ptr_to_packet
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: "Panneman, J.J. (Jeffrey)" <jeffrey.panneman@tno.nl>
Cc: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>

This is a verifier error. Do you have a test case? I can take a
further look at this.

On Wed, Jun 21, 2017 at 6:35 AM, Panneman, J.J. (Jeffrey)
<jeffrey.panneman@tno.nl> wrote:
> Hi All,
>
> I currently have another issue which seems rather weird. I have a variable with type uint8_t, this is passed as reference to a function in which it gets a value. When I do this a single time, the variable gets a value and I can print it with the trace print call. Now when I do this a second time, I get the 'cannot add integer value with 0 upper zero bits to ptr_to_packet' message, I have also tried to create another variable and assign it to this but this did not resolve anything.
>
> is there some restrictions on changing values ? The message doesn't really give me enough to work out the exact issue.
>
> Happy to provide verifier output and code for those who might have an idea.
>
> Kind regards,
>
> Jeffrey Panneman
> This message may contain information that is not intended for you. If you are not the addressee or if this message was sent to you by mistake, you are requested to inform the sender and delete the message. TNO accepts no liability for the content of this e-mail, for the manner in which you use it and for damage of any kind resulting from the risks inherent to the electronic transmission of messages.
>
