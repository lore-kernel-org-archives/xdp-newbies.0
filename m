Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from m02.nii.ac.jp ([136.187.7.8]:42804 "EHLO m02.nii.ac.jp"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750982AbeDIXAm (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 9 Apr 2018 19:00:42 -0400
Received: from 2.3.h.ccmp.jp (124.41.93.194 [124.41.93.194])
        by m02.nii.ac.jp (deepsmtpd.sk)
        with ESMTP id <47428621-2f24-3c8e-5d34-1d788a86a455@nii.ac.jp>
        for <xdp-newbies@vger.kernel.org>; Tue, 10 Apr 2018 07:49:26 +0900
From: Kimitoshi Takahashi <ktaka@nii.ac.jp>
Subject: XDP_TX for virtio_net not working in recent kernel?
Message-ID: <47428621-2f24-3c8e-5d34-1d788a86a455@nii.ac.jp>
Date: Tue, 10 Apr 2018 07:49:25 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org

Hello,

I'm totally newbie.

I want to try some examples under the samples/bpf of the kernel tree using the virtio_net driver in 
kvm, in order to get familiar with the XDP. However, it seems to me that for kernels newer than 
linux-4.15, the xdp2 and xdp_tx_tunnel are not working in the case of virtio_net.

Can somebody help me out to make them working?


1) For linux-4.11.12, linux-4.12.14, and linux-4.14.31, xdp2 and xdp_tx_tunnel are working.

[xdp2]
10.0.0.27# ./xdp2 2 (or ./xdp -N 2)

10.0.0.254# hping3 10.0.0.27 -p 5000 -2

10.0.0.254# tcpdump -nei kbr0 udp port 5000
06:18:37.677070 2e:c9:83:fb:5b:f3 > 52:54:00:11:00:1b, ethertype IPv4 (0x0800), length 42: 
10.0.0.254.2982 > 10.0.0.27.5000: UDP, length 0
06:18:37.677265 52:54:00:11:00:1b > 2e:c9:83:fb:5b:f3, ethertype IPv4 (0x0800), length 42: 
10.0.0.254.2982 > 10.0.0.27.5000: UDP, length 0

I can see the UDP packets with MAC addresses swapped.

[xdp_tx_tunnel]

10.0.0.254# telnet 10.1.2.1 80

10.0.0.27# ./xdp_tx_iptunnel -i 2 -a 10.1.2.1 -p 80 -s 10.0.0.27 -d 10.0.0.24 -m 52:54:00:11:00:18

10.0.0.24# tcpdump -nei any proto 4
22:08:20.510354  In 52:54:00:11:00:1b ethertype IPv4 (0x0800), length 96: 10.0.0.27 > 10.0.0.24: 
10.0.0.254.60826 > 10.1.2.1.80: Flags [S], seq 3224377720, win 29200, options [mss 1460,sackOK,TS 
val 217801953 ecr 0,nop,wscale 7], length 0 (ipip-proto-4)

I can see the encapsulated SYN packet that is forwarded by the 10.0.0.27.

2) For linux-4.15, linux-4.15.5, linux-4.15.13 and linux-4.16.1, xdp2 and xdp_tx_tunnel are NOT working.

[xdp2]
10.0.0.27# ./xdp2 -N 2

10.0.0.254# hping3 10.0.0.27 -p 5000 -2

10.0.0.254# tcpdump -nei br0 udp port 5000
06:45:34.810046 2e:c9:83:fb:5b:f3 > 52:54:00:11:00:1b, ethertype IPv4 (0x0800), length 42: 
10.0.0.254.2346 > 10.0.0.27.5000: UDP, length 0
06:45:35.810176 2e:c9:83:fb:5b:f3 > 52:54:00:11:00:1b, ethertype IPv4 (0x0800), length 42: 
10.0.0.254.2347 > 10.0.0.27.5000: UDP, length 0

Only the outgoing packets can be seen.

[xdp_tx_tunnel]

10.0.0.254# telnet 10.1.2.1 80

10.0.0.27# ./xdp_tx_iptunnel -i 2 -a 10.1.2.1 -p 80 -s 10.0.0.27 -d 10.0.0.24 -m 52:54:00:11:00:18

10.0.0.24# tcpdump -nei any proto 4

I can NOT see the encapsulated SYN packet that is forwarded by the 10.0.0.27.


--
Sincerely,
Takahashi Kimitoshi
