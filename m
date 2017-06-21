Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:37090 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751798AbdFURFC (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 21 Jun 2017 13:05:02 -0400
Message-ID: <594AA739.5050307@iogearbox.net>
Date: Wed, 21 Jun 2017 19:04:57 +0200
From: Daniel Borkmann <daniel@iogearbox.net>
MIME-Version: 1.0
Subject: Re: FW: Cannot add integer value with N upper zero bits to ptr_to_packet
References: <7784F3C775469047B0E8C3B494DB28BEB0F5BC@EXC-MBX03.tsn.tno.nl> <7784F3C775469047B0E8C3B494DB28BEB0F5DA@EXC-MBX03.tsn.tno.nl> <CAH3MdRXX6UDm9Ru_9k+TVmn5UeK7vM7st5avkbMKdFED9=2X2A@mail.gmail.com>
In-Reply-To: <CAH3MdRXX6UDm9Ru_9k+TVmn5UeK7vM7st5avkbMKdFED9=2X2A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Y Song <ys114321@gmail.com>, "Panneman, J.J. (Jeffrey)" <jeffrey.panneman@tno.nl>
Cc: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>

On 06/21/2017 05:55 PM, Y Song wrote:
> This is a verifier error. Do you have a test case? I can take a
> further look at this.
>
> On Wed, Jun 21, 2017 at 6:35 AM, Panneman, J.J. (Jeffrey)
> <jeffrey.panneman@tno.nl> wrote:
>> Hi All,
>>
>> I currently have another issue which seems rather weird. I have a variable with type uint8_t, this is passed as reference to a function in which it gets a value. When I do this a single time, the variable gets a value and I can print it with the trace print call. Now when I do this a second time, I get the 'cannot add integer value with 0 upper zero bits to ptr_to_packet' message, I have also tried to create another variable and assign it to this but this did not resolve anything.
>>
>> is there some restrictions on changing values ? The message doesn't really give me enough to work out the exact issue.
>>
>> Happy to provide verifier output and code for those who might have an idea.

The error message usually happens when you have register that contains
{skb,xdp}->data or some pointer derived from this, and you add another
register to it that has a unknown value, where verifier has no knowledge
of what the upper bound could be of that register so that it cannot
guarantee that this won't turn into a overflow (it expects 48 or more
zero upper bits). The passing by reference might not necessarily be the
cause for triggering this, but rather the addition that you perform
somewhere in your code. Test case would help indeed to see what you're
doing.
