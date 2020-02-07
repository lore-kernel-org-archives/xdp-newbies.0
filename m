Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:48230 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727012AbgBGVlP (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Fri, 7 Feb 2020 16:41:15 -0500
Subject: Re: [PATCH bpf] xsk: publish global consumer pointers when NAPI is
 finsihed
References: <1581068272-4615-1-git-send-email-magnus.karlsson@intel.com>
 <c5d6fd11-8696-e898-6f05-5fcc087c0065@mellanox.com>
From: Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <95de5e86-8930-5655-62b9-ec60b9952440@iogearbox.net>
Date: Fri, 7 Feb 2020 22:40:59 +0100
MIME-Version: 1.0
In-Reply-To: <c5d6fd11-8696-e898-6f05-5fcc087c0065@mellanox.com>
Content-Language: en-US
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Maxim Mikityanskiy <maximmi@mellanox.com>, Magnus Karlsson <magnus.karlsson@intel.com>
Cc: xdp-newbies@vger.kernel.org, rgoodfel@isi.edu, bjorn.topel@intel.com, tariqt@mellanox.com, saeedm@mellanox.com, moshe@mellanox.com

On 2/7/20 1:34 PM, Maxim Mikityanskiy wrote:
> On 2020-02-07 11:37, Magnus Karlsson wrote:
>> The commit 4b638f13bab4 ("xsk: Eliminate the RX batch size")
>> introduced a much more lazy way of updating the global consumer
>> pointers from the kernel side, by only doing so when running out of
>> entries in the fill or Tx rings (the rings consumed by the
>> kernel). This can result in a deadlock with the user application if
>> the kernel requires more than one entry to proceed and the application
>> cannot put these entries in the fill ring because the kernel has not
>> updated the global consumer pointer since the ring is not empty.
[...]
> 
> Acked-by: Maxim Mikityanskiy <maximmi@mellanox.com>
> 
> Is it intentional that you didn't send it to bpf and netdev mailing lists?

Yep, please resend with Maxim's ACK to bpf + netdev in Cc. Thanks!
