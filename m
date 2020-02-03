Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-eopbgr10087.outbound.protection.outlook.com ([40.107.1.87]:11601
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726561AbgBCLtW (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 3 Feb 2020 06:49:22 -0500
Subject: Re: Cannot run multiple 'xdpsock' concurrently?
References: <CAMyc9bVixUDEJ-WHLJaCCTF3iV4pFF2j+RPM0hM1XOKh6S2yBw@mail.gmail.com>
 <CAJ8uoz0btU4L80d2DHv+=ivL3RJmunnAsmetL=2zBo_2xfpgAA@mail.gmail.com>
 <20200203031104.GA19512@ranger.igk.intel.com>
From: Maxim Mikityanskiy <maximmi@mellanox.com>
Message-ID: <afcf4030-aee3-7e9c-a57f-c5458c285b74@mellanox.com>
Date: Mon, 3 Feb 2020 13:49:11 +0200
In-Reply-To: <20200203031104.GA19512@ranger.igk.intel.com>
Content-Language: en-US
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Maciej Fijalkowski <maciej.fijalkowski@intel.com>, Magnus Karlsson <magnus.karlsson@gmail.com>
Cc: Cameron Elliott <cameron@cameronelliott.com>, Xdp <xdp-newbies@vger.kernel.org>, bjorn.topel@intel.com

On 2020-02-03 05:11, Maciej Fijalkowski wrote:
> On Mon, Feb 03, 2020 at 10:53:40AM +0100, Magnus Karlsson wrote:
>> On Fri, Jan 31, 2020 at 3:14 AM Cameron Elliott
>> <cameron@cameronelliott.com> wrote:
>>>
>>> Hello, I am trying to measure the maximum mpps I can push using AF_XDP on a 40G X710
>>>
>>> I can do 22 mpps  after resolving a few bumbles I made with drivers, etc., (Thanks Magnus!)
>>> when using a single instance of 'xdpsock'
>>>
>>>
>>> Apparently the way to upto 50, 60 or 70? mpps is to use multiple cores...
>>> And apparently the simple way to do that, is multiple instances of xdpsock on different queues.
>>>
>>> But, my attempts with multiple instances fail. :(
>>>
>>>
>>>
>>> First, I checked my channel setup:
>>>
>>> $ sudo ethtool --set-channels enp1s0f0
>>> no channel parameters changed.
>>> current values: rx 0 tx 0 other 1 combined 4
>>>
>>> I presume that is okay...
>>>
>>> Then I run these two commands in two different windows:
>>>
>>> sudo  /home/c/bpf-next/samples/bpf/xdpsock -i enp1s0f0 -t -N -z -q 0
>>> sudo  /home/c/bpf-next/samples/bpf/xdpsock -i enp1s0f0 -t -N -z -q 1
>>>
>>> With the only difference being the queue id.
>>>
>>> The first will start and show ~22 mpps tx rate.
>>> When I start the second, both instances die:
>>>
>>> The first instace dies with:
>>> /home/c/bpf-next/samples/bpf/xdpsock_user.c:kick_tx:794: errno: 100/"Network is down"
>>>
>>> The second instance dies with:
>>> /home/c/bpf-next/samples/bpf/xdpsock_user.c:kick_tx:794: errno: 6/"No such device or address"
>>>
>>>
>>> Do I understand correctly I should be able to run two instances like this concurrently?
>>
>> This is probably not supported by the current xdpsock application.
>> What is likely happening is that it tries to load the XDP program
>> multiple times. As the XDP program is per netdev, not per queue, it
>> should only be loaded once. When the second process then fails, it
>> probably removes the XDP program (as it think it has loaded it) which
>> crashes the first process you started.
> 
> Of course it *was* supported. Program is loaded only on the first xdpsock
> instance since libbpf is checking whether xdp resources are there. On the
> removal part you're right, we still haven't figured it out how to properly
> exit the xdpsock when there are other xdpsocks running.
> 
> Actually commit b3873a5be757 ("net/i40e: Fix concurrency issues between
> config flow and XSK") (CCing Maxim, Bjorn) broke the xdpsock multiple
> instances support.

That was surprising, but now that I took a look at that code in the 
context of this issue, it got clear to me why it happens.

> If we drop the check against busy bit in PF state in
> the i40e_xsk_wakeup, then I can run many xdpsocks on same ifindex.
> 
> I'm not really sure that is the right approach since we are explicitly
> setting the __I40E_CONFIG_BUSY bit in i40e_queue_pair_disable which is
> used when ndo_bpf is called with XDP_SETUP_XSK_UMEM command.

Right, we shouldn't drop this check, at least it's needed to sync on 
xsk_wakeup when closing a socket. I think there are two issues here, and 
I suggest this way of solving them:

1. __I40E_CONFIG_BUSY is set while a single QP is being recreated, e.g., 
when opening/closing an XSK. I considered it as a flag for global 
configuration changes, but apparently it's also needed when a single XSK 
is being configured. Probably xsk_wakeup shouldn't return ENETDOWN when 
this flag is set, but something lighter like EAGAIN. xdpsock will need 
to repeat the syscall instead of bailing out.

2. Should xdpsock stop on ENETDOWN? Normal network sockets don't close 
as soon as the carrier is lost, so why should xdpsock fail on ENETDOWN? 
IMO, xdpsock should handle it more gracefully (wait with some timeout?).

Does it sound like the right direction?

>>
>> So, the application needs to get extended to support this. Maybe you
>> want to do this :-)? Could be a good exercise. You could add a new
>> commend line option that takes the number of instances you would like
>> to create. Look at the -M option for some inspiration as it does some
>> of the things you need. Maybe you can reuse that code to support your
>> use case.
>>
>> /Magnus
>>
>>>
>>> Thank you for any ideas, input.
>>>
>>>
>>>
>>> # ethtool dump / i40e driver from recent bpf-next clone
>>> c@lumen ~> ethtool -i enp1s0f0
>>> driver: i40e
>>> version: 2.8.20-k
>>> firmware-version: 7.10 0x80006456 1.2527.0
>>> expansion-rom-version:
>>> bus-info: 0000:01:00.0
>>> supports-statistics: yes
>>> supports-test: yes
>>> supports-eeprom-access: yes
>>> supports-register-dump: yes
>>> supports-priv-flags: yes
>>>
>>>
