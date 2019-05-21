Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33096 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728256AbfEUPVs (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 21 May 2019 11:21:48 -0400
Received: by mail-wr1-f65.google.com with SMTP id d9so6133353wrx.0
        for <xdp-newbies@vger.kernel.org>; Tue, 21 May 2019 08:21:47 -0700 (PDT)
Date: Tue, 21 May 2019 17:21:45 +0200
From: Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH v2 net 2/2] net: core: generic XDP support for stacked
 device
Message-ID: <20190521152145.GA2165@nanopsycho.orion>
References: <20190519031046.4049-1-sthemmin@microsoft.com>
 <20190519031046.4049-3-sthemmin@microsoft.com>
 <20190520091105.GA2142@nanopsycho>
 <20190520090405.69b419e5@hermes.lan>
 <20190521061536.GB2210@nanopsycho.orion>
 <20190521074553.12329dd5@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190521074553.12329dd5@hermes.lan>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: netdev@vger.kernel.org, davem@davemloft.net, xdp-newbies@vger.kernel.org, bpf@vger.kernel.org, Stephen Hemminger <sthemmin@microsoft.com>, Jason Wang <jasowang@redhat.com>

Tue, May 21, 2019 at 04:45:53PM CEST, stephen@networkplumber.org wrote:
>On Tue, 21 May 2019 08:15:36 +0200
>Jiri Pirko <jiri@resnulli.us> wrote:
>
>> +	if (static_branch_unlikely(&generic_xdp_needed_key)) {
>> +		int ret2;
>> +
>> +		preempt_disable();
>> +		rcu_read_lock();
>> +		ret2 = do_xdp_generic(rcu_dereference(skb->dev->xdp_prog), skb);
>> +		rcu_read_unlock();
>> +		preempt_enable();
>> +
>> +		if (ret2 != XDP_PASS)
>> +			return NET_RX_DROP;
>> +	}
>> +
>
>rcu_read_lock is already held by callers of __netif_receive_skb_core

Sure, the purpose of the draft was just to show the idea.
