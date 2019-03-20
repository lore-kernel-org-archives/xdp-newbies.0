Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38310 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726366AbfCTMTM (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 20 Mar 2019 08:19:12 -0400
Subject: Re: [PATCH] thunderbolt: xdomain: Fix to check return value of
 kmemdup
References: <20190318225508.7886-1-pakki001@umn.edu>
 <57793438545e41cc85d00beab7505143@AcuMS.aculab.com>
From: Mukesh Ojha <mojha@codeaurora.org>
Message-ID: <034573d6-61dc-4555-2559-acb4aa86dabe@codeaurora.org>
Date: Wed, 20 Mar 2019 17:48:55 +0530
MIME-Version: 1.0
In-Reply-To: <57793438545e41cc85d00beab7505143@AcuMS.aculab.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: David Laight <David.Laight@ACULAB.COM>, 'Aditya Pakki' <pakki001@umn.edu>
Cc: "kjlu@umn.edu" <kjlu@umn.edu>, Andreas Noever <andreas.noever@gmail.com>, Michael Jamet <michael.jamet@intel.com>, Mika Westerberg <mika.westerberg@linux.intel.com>, Yehezkel Bernat <YehezkelShB@gmail.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>


On 3/20/2019 4:27 PM, David Laight wrote:
> From: Aditya Pakki
>> Sent: 18 March 2019 22:55
>>
>> kmemdup can fail and return a NULL pointer. The patch modifies the
>> signature of tb_xdp_schedule_request and passes the failure error upstream.
>>
>> Signed-off-by: Aditya Pakki <pakki001@umn.edu>
>> ---
>>   drivers/thunderbolt/xdomain.c | 10 ++++++----
>>   1 file changed, 6 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/thunderbolt/xdomain.c b/drivers/thunderbolt/xdomain.c
>> index e27dd8beb94b..b0e9cc30d708 100644
>> --- a/drivers/thunderbolt/xdomain.c
>> +++ b/drivers/thunderbolt/xdomain.c
>> @@ -526,7 +526,7 @@ static void tb_xdp_handle_request(struct work_struct *work)
>>   	kfree(xw);
>>   }
>>
>> -static void
>> +static bool
>>   tb_xdp_schedule_request(struct tb *tb, const struct tb_xdp_header *hdr,
>>   			size_t size)
>>   {
>> @@ -534,13 +534,16 @@ tb_xdp_schedule_request(struct tb *tb, const struct tb_xdp_header *hdr,
>>
>>   	xw = kmalloc(sizeof(*xw), GFP_KERNEL);
>>   	if (!xw)
>> -		return;
>> +		return false;
>>
>>   	INIT_WORK(&xw->work, tb_xdp_handle_request);
>>   	xw->pkg = kmemdup(hdr, size, GFP_KERNEL);
>> +	if (!xw->pkg)
>> +		return false;
> You're leaking 'xw' here.


Yes , Clean up is missing otherwise patch looks good.

Mukesh

>
> 	David
>
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
>
