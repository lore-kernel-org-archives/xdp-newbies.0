Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:24005 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730425AbgCaJ3P (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 31 Mar 2020 05:29:15 -0400
Received: by mail-lj1-f200.google.com with SMTP id i19so1530015ljn.17
        for <xdp-newbies@vger.kernel.org>; Tue, 31 Mar 2020 02:29:12 -0700 (PDT)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: Using AF_XDP To Modify Outgoing Packets
In-Reply-To: <dd0d11d8-29ff-18c5-85b2-d566d2bba2ea@gflclan.com>
References: <7902d2f1-1c21-f3e8-5035-352bba130d50@gflclan.com> <20200330111048.1167e6f4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <dd0d11d8-29ff-18c5-85b2-d566d2bba2ea@gflclan.com>
Date: Tue, 31 Mar 2020 11:29:08 +0200
Message-ID: <87sghoj2jf.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Christian Deacon <gamemann@gflclan.com>, Jakub Kicinski <kuba@kernel.org>
Cc: xdp-newbies@vger.kernel.org

Christian Deacon <gamemann@gflclan.com> writes:

> Hey David and Jakub,
>
> Thank you for your replies!
>
> David, it's good to know that egress support is being added to XDP and I 
> appreciate all the work you and others are putting into this! Do you 
> know if there is any ETA on when this will be officially 
> available/supported? With that said, will this be faster than most 
> solutions available now for processing/modifying outbound packets such 
> as using standard AF_PACKET sockets, IPTables, or DPDK?
>
> Jakub, thank you for that information! As for my project, I have a 
> program forwarding traffic to a server via IPIP packets. The destination 
> server has multiple network namespaces along with the IPIP tunnel 
> endpoints and the application sitting inside each namespace. As of right 
> now, the destination machine replies back through the IPIP tunnel (to 
> the forwarding server) and the forwarding server has to send the replies 
> back to the client. My goal is to make it so the application sends 
> traffic back to the client directly by spoofing the source address as 
> the forwarding server's IP address. This would result in less load on 
> the forwarding server along with less latency in my case. Currently, the 
> IPIP tunnel endpoints inside the namespaces are set as the default 
> devices and all IPIP packets go out the main interface on the 
> destination machine.
>
> Initially, I tried creating a veth pair and put the peer inside the 
> namespace. I then created a bridge on the main namespace and bridged the 
> veth on the main namespace. I assigned the bridge an IP and had an SNAT 
> rule in the IPTables POSTROUTING chain to source all traffic out as the 
> forwarding server IP. I set the veth pair inside the network namespace 
> as the default device on the network namespace and set the next hop to 
> the bridge IP. The networking part of this worked fine, traffic sent out 
> from the application (through the default route in the network 
> namespace) was reaching the clients directly and the clients were 
> replying back to the forwarding server. However, this still didn't work 
> and I believe the cause is due to the application not supporting two 
> separate interfaces (one for receiving and one for sending). 
> Unfortunately, the application is closed-source and I doubt support for 
> using two separate interfaces will be added.
>
> With the above said, I've been trying to look into creating a program 
> that would receive all outgoing packets on the main interface. It would 
> check the outer IP header's protocol to ensure it's IPPROTO_IPIP. If 
> this is the case, it would then check if the outer IP header's source 
> address is the same as the main interface's IP address. If this matches, 
> it would save the outer IP header's destination address and remove the 
> outer IP header. It would then replace the inner IP header's source 
> address with the saved address (outer IP header's destination address) 
> which should be the IP of the forwarding server. Afterwards, it would 
> recalculate the IP and transport header's checksums and continue sending 
> the packet. I believe in theory this should work.
>
> I am trying to find the best way to achieve the above. I don't believe 
> IPTables supports changing the packet's contents to the same extent as 
> the above.
>
> I made an XDP program yesterday that would do this, but later found out 
> XDP doesn't support egress at the moment. I still plan to use the code 
> for when TX path/egress support is added. I'd like to come up with 
> another solution in the meantime to achieve the above, though.

I think you could do this with the TC hook? You can install BPF programs
there that have then same ability to modify the program as XDP does. And
since the packets are coming from an application, you don't gain any
speedup from XDP anyway (since the kernel has already built its packet
data structures).

-Toke
