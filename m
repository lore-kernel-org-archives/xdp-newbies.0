Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from fm2nodo1.polito.it ([130.192.180.17]:46853 "EHLO
        fm2nodo1.polito.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752093AbeAHQAl (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Mon, 8 Jan 2018 11:00:41 -0500
Received: from polito.it (frontmail2.polito.it [130.192.180.42])
        by fm2nodo1.polito.it  with ESMTP id w08FXd4w027142-w08FXd50027142
        (version=TLSv1.0 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <xdp-newbies@vger.kernel.org>; Mon, 8 Jan 2018 16:33:39 +0100
Received: from [130.192.225.137] (account d037140@polito.it HELO [192.168.1.102])
  by polito.it (CommuniGate Pro SMTP 6.1.9)
  with ESMTPSA id 69909655 for xdp-newbies@vger.kernel.org; Mon, 08 Jan 2018 16:33:38 +0100
From: Matteo Bertrone <matteo.bertrone@polito.it>
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Subject: Generic XDP and veth
Message-Id: <88581FA1-DA7C-4329-8D62-185090FC820D@polito.it>
Date: Mon, 8 Jan 2018 16:33:38 +0100
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org

Hello,

while I was trying to forward packets using Generic XDP [1], I encountered the following problem:

ARP and ICMP packets are forwarded correctly, and ping works fine.
It seems not all TCP packets are forwarded by XDP program, both netcat and iperf are not working for me.

(Using same configuration as [1])
sudo ip netns exec ns2 nc -l 8080
sudo ip netns exec ns1 nc 10.1.1.22 8080

sudo ip netns exec ns2 iperf3 -s 
sudo ip netns exec ns1 iperf3 -c 10.1.1.22

It seems such traffic is not processed by XDP program.
Using tcpdump on veth1 in root namespace I’m not able to see ARP and ICMP traffic (as expected) because forwarded by XDP program, but I’m able to see all the traffic it’s not forwarded.

Is this behavior expected?
Did I miss something in veth configuration?

Thanks in advance,
Matteo

[1] https://github.com/torvalds/linux/blob/master/tools/testing/selftests/bpf/test_xdp_redirect.sh
