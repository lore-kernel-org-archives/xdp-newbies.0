Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-eopbgr130048.outbound.protection.outlook.com ([40.107.13.48]:28390
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726799AbfDJKeX (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 10 Apr 2019 06:34:23 -0400
From: Petr Machata <petrm@mellanox.com>
Subject: Re: [PATCH] net:bridge:always disable auto-tuning when the user
 specified MTU
Date: Wed, 10 Apr 2019 10:34:17 +0000
Message-ID: <87y34ijgil.fsf@mellanox.com>
References: <20190410023208.25435-1-huangruiPPP@gmail.com>
 <20190409193911.2d68a64d@shemminger-XPS-13-9360>
In-Reply-To: <20190409193911.2d68a64d@shemminger-XPS-13-9360>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: Huang Rui <huangruippp@gmail.com>, "davem@davemloft.net" <davem@davemloft.net>, "ast@kernel.org" <ast@kernel.org>, "daniel@iogearbox.net" <daniel@iogearbox.net>, "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>, "hawk@kernel.org" <hawk@kernel.org>, "john.fastabend@gmail.com" <john.fastabend@gmail.com>, "kafai@fb.com" <kafai@fb.com>, "songliubraving@fb.com" <songliubraving@fb.com>, "yhs@fb.com" <yhs@fb.com>, Jiri Pirko <jiri@mellanox.com>, "ecree@solarflare.com" <ecree@solarflare.com>, Ido Schimmel <idosch@mellanox.com>, "alexander.h.duyck@intel.com" <alexander.h.duyck@intel.com>, "amritha.nambiar@intel.com" <amritha.nambiar@intel.com>, Li Rongqing <lirongqing@baidu.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>, "roopa@cumulusnetworks.com" <roopa@cumulusnetworks.com>, "nikolay@cumulusnetworks.com" <nikolay@cumulusnetworks.com>, "bridge@lists.linux-foundation.org" <bridge@lists.linux-foundation.org>


Stephen Hemminger <stephen@networkplumber.org> writes:

> On Wed, 10 Apr 2019 02:32:08 +0000
> Huang Rui <huangruippp@gmail.com> wrote:
>
>> For example.
>> My purpose is to create a bridge br0 and join eth0 into br0.
>> if we use this following way, the auto-tuning flag will not be disabled.
>>
>> If eth0's mtu is 1200
>> step 1.brctl addbr br0
>> step 2.brctl addif br0 eth0
>> step 3.ifconfig br0 mtu 1200
>> step 4.ifconfig eth0 mtu 1500
>>
>> Result:
>> br0's MTU: 1500, eth0's MTU: 1500
>>
>> Expected:
>> br0's MTU: 1200, eth0's MTU: 1500
>>
>> I have specified br0's MTU,  but auto-min policy works. So the MTU is
>> not the result what we expected.
>> As expected, if i have specified bridge's MTU, it will set the flag:
>> BROPT_MTU_SET_BY_USER in net_bridge_opts disabled and auto-min/max
>> policy will not work.But in this case, because the dev_set_mtu return
>> early, the BROPT_MTU_SET_BY_USER flag will not be disabled and
>> auto-min/max policy will still work.
>>
>> Signed-off-by: Huang Rui <huangruiPPP@gmail.com>
>
> A bridge like this going to drop frames.
> A frame received with MTU of 1200 will get dropped.

That's true even if above you set br0's MTU to 1201, but then the
auto-tuning is disabled as expected. The problem is that setting MTU to
1200 is perceived as a non-change, whereas it should instead be
perceived as a signal that the user takes over the MTU management.

> The proper way to do this is to change MTU of both interfaces to match.
