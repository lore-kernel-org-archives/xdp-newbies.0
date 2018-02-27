Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:60698 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751233AbeB0Ama (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 26 Feb 2018 19:42:30 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w1R0gTTM168499
        for <xdp-newbies@vger.kernel.org>; Tue, 27 Feb 2018 00:42:29 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2gcvfg846d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <xdp-newbies@vger.kernel.org>; Tue, 27 Feb 2018 00:42:29 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w1R0WSur026821
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <xdp-newbies@vger.kernel.org>; Tue, 27 Feb 2018 00:32:28 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w1R0WSNG030178
        for <xdp-newbies@vger.kernel.org>; Tue, 27 Feb 2018 00:32:28 GMT
From: Tushar Dave <tushar.n.dave@oracle.com>
Subject: loop in eBPF kernel program
Message-ID: <e3a523ec-b090-61b5-c92b-58d3b74a9c31@oracle.com>
Date: Mon, 26 Feb 2018 16:32:27 -0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org
Cc: tndave <tushar.n.dave@oracle.com>

Hello,

I am writing sample eBPF kernel program that uses kprobe
e.g.
SEC("kprobe/xyz")
int bpf_prog1(struct pt_regs *ctx)
{
.
..
}

And with pt_regs context I retrieved pointer to 'struct sk_buff_head'.
 From here on, I want to iterate over all skbs in the skb queue and
print/gather packet data. This certainly involves loop and that causes
my ebpf kernel program to fail with error,
e.g.
bpf_load_program() err=22
back-edge from insn 51 to 39
back-edge from insn 51 to 39


Any other alternative so that I can retrieve all packet data from skb queue?

Apology as this is not pure xdp query but I feel it should be okay to
ask here.

Thanks.

-Tushar
