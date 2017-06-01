Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qt0-f179.google.com ([209.85.216.179]:33878 "EHLO
        mail-qt0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751083AbdFARRU (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Thu, 1 Jun 2017 13:17:20 -0400
Received: by mail-qt0-f179.google.com with SMTP id c13so41550467qtc.1
        for <xdp-newbies@vger.kernel.org>; Thu, 01 Jun 2017 10:17:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <7784F3C775469047B0E8C3B494DB28BEAF7DE1@EXC-MBX03.tsn.tno.nl>
References: <7784F3C775469047B0E8C3B494DB28BEAF7DE1@EXC-MBX03.tsn.tno.nl>
From: Andy Gospodarek <andy@greyhouse.net>
Date: Thu, 1 Jun 2017 13:16:58 -0400
Message-ID: <CAHashqAdKRLNTO22CaaTk9=2LiLpdtcN0+SCXd+RwMBXRG+Dtg@mail.gmail.com>
Subject: Re: Empty ethernet frame after XDP_TX
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: "Panneman, J.J. (Jeffrey)" <jeffrey.panneman@tno.nl>
Cc: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>

On Thu, Jun 1, 2017 at 7:38 AM, Panneman, J.J. (Jeffrey)
<jeffrey.panneman@tno.nl> wrote:
> Hi Andy,
>
> Thanks for your quick response! When looking at the header I observe that the protocol is listed as '0x0000',  besides that the 'data field' in the Ethernet Frame is all 0s, but I think this is expected.
> Maybe some more context for my setup as is is needed. Currently I have set up two network namespaces on my Ubuntu machine, the XDP example is then attached to the receiving side of my setup.
> Before this I verify the routes are setup correctly using ping, this works as expected.
> When the network is setup, I use 'nping' from the 'nmap' package, using the following settings:
>
> nping $SERVER_IP --udp --source-ip $CLIENT_IP -p $TCPDUMP_PORT -g $TCPDUMP_PORT --data-length 1000 --rate 100 -c $NPING_SEND_COUNT --source-mac $CLIENT_MAC --dest-mac $SERVER_MAC
>
> I have added the source and dest mac parameters in the hopes this would fix the problem, but the same behavior occurs when disregarding these parameters.
> After I start the nping on the client side, I load the XDP program onto the receiving interface on the server side.  I added some ' bpf_trace_printk' statements to verify the program was reaching certain areas but besides this it is exactly the same example file. (xdp2)
>
> The diff can be found below. For this experiment I ran my test using "-c 110", so 110 UDP packets should be sent using nping.
> This is for the server (receiving side) interface: https://www.diffchecker.com/2HLX9Y5t

I've got three concerns:

1. I'm a bit troubled by the fact that none of the xdp_* ethtool
counters appear to be incrementing.  Are these incrementing (and can
you confirm the frames are being dropped with the XDP_DROP return code
from the bpf program) when you run xdp1?

2. You also may want to check the output of ethtool -k and see what
offloads are enabled by default on the interface.  I've seen issues
where some offloads have a negative impact on the ability to read and
process the frame data (though this is rare and today's code only has
issues with VLAN offload IIRC).

3. Lastly you should consider keeping the receive side (the one doing
XDP) in the default namespace and only create a new namespace for the
netdev that will run the nping command to see if that makes a
difference.  I'm quite sure this should not be an issue, but it's
worth doing to eliminate as many variables as possible.


> This is for the client (sending side) interface: https://www.diffchecker.com/TK7EncN5
>
> In case the above links do not properly present the information I have included the output in the attachments.
> If you need any other information I am happy to supply this, thank you for your time so far!
>
> Kind regards,
>
> Jeffrey Panneman
>
>
>
>
>
>
>
> -----Original Message-----
> From: xdp-newbies-owner@vger.kernel.org [mailto:xdp-newbies-owner@vger.kernel.org] On Behalf Of Andy Gospodarek
> Sent: woensdag 31 mei 2017 18:34
> To: Jeffrey Panneman <jeffrey.panneman@student.uva.nl>
> Cc: xdp-newbies@vger.kernel.org
> Subject: Re: Empty ethernet fram after XDP_TX
>
> On Wed, May 31, 2017 at 5:29 AM, Jeffrey Panneman <jeffrey.panneman@student.uva.nl> wrote:
>> Hi all,
>>
>> I have recently started experimenting with XDP in regards to my master
>> thesis project. I have been playing around with some examples and had
>> a question regarding the following sample file from the linux kernel:
>> https://github.com/torvalds/linux/blob/master/samples/bpf/xdp2_kern.c
>>
>> I have setup a test environment on which I can monitor both my source
>> and destination port using Wireshark. I observe that when I run the
>> example, always returning XDP_PASS, packets go on normal but the MAC
>> swapping does not occur. When using the XDP_TX return code after
>> swapping I observe that I see Ethernet frames appear in wireshark with
>> a source and destination 00:00:00:00:00:00. The IP related headers are
>> gone and this is the only thing I am seeing.
>
> That is not what I would expect to see.  I've run numerous tests with
> xdp2 on other hardware (Broadcom) and not seen this issue.  Are only the source and destination MAC addresses all zeros or are other parts of the ethernet header also zero?
>
>> For some context, I am running on: 4.11.0-041100-generic x86_64 x86_64
>> x86_64 GNU/Linux using ConnectX-4 Lx cards with the mlx5_core driver
>> (from lspci -v output). From "systool -vm" output I see my mlx5_core
>> version is "4.0-2.0.0"
>>
>> I was wondering if this behaviour was normal, and if anyone knows what
>> is going wrong here. I am happy to provide some more diagnostic
>> information if needed.
>
> Can you send the diff of the ethtool stats (ethtool -S <netdev>) from before and after your XDP_TX test to see if anything stands out?
>
>> Kind regards,
>>
>> Jeffrey
> This message may contain information that is not intended for you. If you are not the addressee or if this message was sent to you by mistake, you are requested to inform the sender and delete the message. TNO accepts no liability for the content of this e-mail, for the manner in which you use it and for damage of any kind resulting from the risks inherent to the electronic transmission of messages.
