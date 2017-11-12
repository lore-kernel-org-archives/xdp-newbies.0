Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from smtp2.iitd.ac.in ([103.27.10.44]:38994 "EHLO smtp2.iitd.ac.in"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753050AbdKLI5b (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Sun, 12 Nov 2017 03:57:31 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp2.iitd.ac.in (Postfix) with ESMTP id 5DADC40037
        for <xdp-newbies@vger.kernel.org>; Sun, 12 Nov 2017 14:27:29 +0530 (IST)
Received: from smtp2.iitd.ac.in ([127.0.0.1])
        by localhost (smtp2.iitd.ac.in [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id uh7-gMRzG7X4 for <xdp-newbies@vger.kernel.org>;
        Sun, 12 Nov 2017 14:27:25 +0530 (IST)
Received: from webmail.iitd.ac.in (webmail.iitd.ac.in [10.7.172.189])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: anmol07.visitor)
        by smtp2.iitd.ac.in (Postfix) with ESMTPSA id 3084B4002F
        for <xdp-newbies@vger.kernel.org>; Sun, 12 Nov 2017 14:27:25 +0530 (IST)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Sun, 12 Nov 2017 14:27:25 +0530
From: Anmol Panda <anmol07.visitor@cse.iitd.ac.in>
Subject: Packet forwarding in XDP
Reply-To: anmol07.visitor@cse.iitd.ac.in
Message-ID: <bb1feffe7bf1e420b484e3963526748d@cse.iitd.ac.in>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Xdp <xdp-newbies@vger.kernel.org>

Dear all,
     We are trying to write a program that receives a packet from a 
client and is supposed to return the packet to the source. We tried to 
swap the source and dest and send it using the XDP_TX action. But it 
doesn't work.

    We have compiled a new kernel and bound the NIC to xdp successfully. 
After binding, the system stops responding to ping and other packet 
generating scripts (like sendip). We are using kernel  4.13.12 (Ubuntu 
17.10) from the main linux kernel tree and binding with Intel I217-LM 
NIC. This NIC is using e1000e driver. Can xdp / eBPF be used for this 
NIC? Moreover, do we need to patch the driver for additional support?

     Our aim is to benchmark various forwarding applications (L2 , L3, 
etc.) run using xdp. Please point to some code samples to achieve this. 
We will be truly grateful.



Thanks,
Sincerely,
