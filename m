Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:51910 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752726AbeDRXJ7 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 18 Apr 2018 19:09:59 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w3IN72gB096196
        for <xdp-newbies@vger.kernel.org>; Wed, 18 Apr 2018 23:09:59 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2hdrxnvxj4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <xdp-newbies@vger.kernel.org>; Wed, 18 Apr 2018 23:09:59 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w3IN9vpI002796
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <xdp-newbies@vger.kernel.org>; Wed, 18 Apr 2018 23:09:58 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w3IN9vht000484
        for <xdp-newbies@vger.kernel.org>; Wed, 18 Apr 2018 23:09:57 GMT
From: Tushar Dave <tushar.n.dave@oracle.com>
Subject: Decode ebpf errors
Message-ID: <cf0f05a2-45d0-19ea-c07c-948aba4e2281@oracle.com>
Date: Wed, 18 Apr 2018 16:09:32 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>

Hi,

When ebpf program fails it dumps log as eBPF instruction.

e.g.
[samples/bpf]# ./xyz
0: (bf) r6 = r1
1: (b7) r1 = 171602533
2: (63) *(u32 *)(r10 -40) = r1
3: (18) r1 = 0x6461654820534452
5: (7b) *(u64 *)(r10 -48) = r1
6: (b7) r7 = 0
7: (73) *(u8 *)(r10 -36) = r7
8: (bf) r1 = r10
9: (07) r1 += -48
10: (b7) r2 = 13
11: (85) call bpf_trace_printk#6
...
.


Is there a way I can dump jited instruction (e.g. x86 assembly) instead
for ease of understanding?

Thanks.

-Tushar
