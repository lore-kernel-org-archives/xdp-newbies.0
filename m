Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:45298 "EHLO
        mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750811AbeBUUBe (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 21 Feb 2018 15:01:34 -0500
MIME-Version: 1.0
In-Reply-To: <CAKgT0UeMCpjq60ULZ7H8UEw+-hkB2nqBnroDQc8GGu56CY-83Q@mail.gmail.com>
References: <1513333486.28703.9.camel@regit.org> <20171215.105338.2092740911243038177.davem@davemloft.net>
 <c677440b-46c5-e32b-5038-21a760ba738b@gmail.com> <CAKgT0UeFUnYdvNZZAzFibYm6JXccyv+9q3=5j1AsAe9Z9bGhjw@mail.gmail.com>
 <F765740A-B847-4EE5-8BFD-3130F64E6116@gmail.com> <CAMhe82KyKtWnMyN-v7_X7jOQWyE6xw0-P3UZYivCgEVYWM8URA@mail.gmail.com>
 <CAKgT0UeMCpjq60ULZ7H8UEw+-hkB2nqBnroDQc8GGu56CY-83Q@mail.gmail.com>
From: Peter Manev <petermanev@gmail.com>
Date: Wed, 21 Feb 2018 15:01:33 -0500
Message-ID: <CAMhe82JhXWaO_30Ufd=jyQCqW2WkckYT6F=C5aHyyTbsNKtAuA@mail.gmail.com>
Subject: Re: ixgbe tuning reset when XDP is setup
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Alexander Duyck <alexander.duyck@gmail.com>
Cc: John Fastabend <john.fastabend@gmail.com>, David Miller <davem@davemloft.net>, Eric Leblond <eric@regit.org>, Netdev <netdev@vger.kernel.org>, xdp-newbies@vger.kernel.org, Emil Tantilov <emil.s.tantilov@intel.com>

>>
>> Hi,
>>
>> We were wondering if there is any follow up/potential solution for that?
>> If there is something we could help out testing with regards to that
>> - please let us know.
>>
>> Thank you
>>
>> --
>> Regards,
>> Peter Manev
>
> We don't have a solution available for this yet. Basically what it
> comes down to is that we have to change the driver code so that if
> assumes it is going to need to alloc Tx rings for XDP always, and then
> if it can't we have to disable the XDP feature. The current logic is
> to advertise the XDP feature, and then allocate the rings when XDP is
> actually used, and if that fails we fail to load the XDP program.
>
> Unfortunately I don't have an ETA for when we can get to that. It may
> be a while, however patches are always welcome.
>
> Thanks.
>
> - Alex

It seems the issue is not present on 4.15.2 (while it is in 4.13.10
for example) using the ixgbe available in tree
(/lib/modules/4.15.2-amd64/kernel/drivers/net/ethernet/intel/ixgbe)

Not sure what triggered the fix -  thought here would be a good place
to ask for some pointers.

Thank you

-- 
Regards,
Peter Manev
