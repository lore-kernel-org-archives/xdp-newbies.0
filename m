Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from fromintouta.tno.nl ([134.221.1.26]:24943 "EHLO
        fromintouta.tno.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753128AbdFVKDu (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 22 Jun 2017 06:03:50 -0400
From: "Panneman, J.J. (Jeffrey)" <jeffrey.panneman@tno.nl>
Subject: RE: FW: Cannot add integer value with N upper zero bits to
 ptr_to_packet
Date: Thu, 22 Jun 2017 10:03:43 +0000
Message-ID: <7784F3C775469047B0E8C3B494DB28BEB0F891@EXC-MBX03.tsn.tno.nl>
References: <7784F3C775469047B0E8C3B494DB28BEB0F5BC@EXC-MBX03.tsn.tno.nl>
 <7784F3C775469047B0E8C3B494DB28BEB0F5DA@EXC-MBX03.tsn.tno.nl>
 <CAH3MdRXX6UDm9Ru_9k+TVmn5UeK7vM7st5avkbMKdFED9=2X2A@mail.gmail.com>
 <594AA739.5050307@iogearbox.net>
In-Reply-To: <594AA739.5050307@iogearbox.net>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: Daniel Borkmann <daniel@iogearbox.net>, Y Song <ys114321@gmail.com>
Cc: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>

Hi all,

I spent sometime trying to figure out how I should check or guard for overflows but I could not find, let's say a default way from the samples in the kernel repo.
After some experimentation my issue seemed to disappear when I changed my uint64_t variable, which I use to keep track of my position in the payload to a uint8_t type. I now have no issue adding the values multiple times, but I would like to know why this solved my problem. Happy to provide verifier log or so. 

For some context, I was doing the following:
I had a method (tlv_amount_of_octets) that returned a value based on a switch statement;  this value was then put into a uint8_t variable.
I then tried to add this uint8_t value to my uint64_t variable to increase the payload_position by that return value. I have added the snippet at the end of the message.
When doing this a singular time it worked fine, or when adding a static value such as 1. When doing it a second time, I started getting the error in question: ' cannot add integer value with 0 upper zero bits to ptr_to_packet'.

Kind regards,

Jeffrey Panneman

------------------------------------------------- Start of Snippet -----------------------------------

static __always_inline uint8_t tlv_amount_of_octets(uint8_t *data, uint64_t payload_position) {
	uint8_t first_octet = data[payload_position]; 
	uint8_t amount_of_octets = 1;

	if (first_octet<253)
		amount_of_octets = 1;
	else {
		//length encoded in following 2,4,or 8 octets
		switch (first_octet) {
			case 253:
				amount_of_octets = 2;
				break;
			case 254:
				amount_of_octets = 4;
				break;
			case 255:
				amount_of_octets = 8;
				break;
			}
		amount_of_octets++; //account for the fact that first octet plays now indication role
	}
	return amount_of_octets;
}

-----Original Message-----
From: Daniel Borkmann [mailto:daniel@iogearbox.net] 
Sent: woensdag 21 juni 2017 19:05
To: Y Song <ys114321@gmail.com>; Panneman, J.J. (Jeffrey) <jeffrey.panneman@tno.nl>
Cc: xdp-newbies@vger.kernel.org
Subject: Re: FW: Cannot add integer value with N upper zero bits to ptr_to_packet

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

The error message usually happens when you have register that contains {skb,xdp}->data or some pointer derived from this, and you add another register to it that has a unknown value, where verifier has no knowledge of what the upper bound could be of that register so that it cannot guarantee that this won't turn into a overflow (it expects 48 or more zero upper bits). The passing by reference might not necessarily be the cause for triggering this, but rather the addition that you perform somewhere in your code. Test case would help indeed to see what you're doing.
This message may contain information that is not intended for you. If you are not the addressee or if this message was sent to you by mistake, you are requested to inform the sender and delete the message. TNO accepts no liability for the content of this e-mail, for the manner in which you use it and for damage of any kind resulting from the risks inherent to the electronic transmission of messages.
