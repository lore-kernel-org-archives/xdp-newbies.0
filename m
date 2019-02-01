Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx0b-00196b01.pphosted.com ([67.231.157.166]:47102 "EHLO
        mx0a-00196b01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731353AbfBAUVx (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 1 Feb 2019 15:21:53 -0500
Received: from pps.filterd (m0096262.ppops.net [127.0.0.1])
        by mx0b-00196b01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x11JH3Er026764
        for <xdp-newbies@vger.kernel.org>; Fri, 1 Feb 2019 14:30:02 -0500
Received: from nam04-sn1-obe.outbound.protection.outlook.com (mail-sn1nam04lp2058.outbound.protection.outlook.com [104.47.44.58])
        by mx0b-00196b01.pphosted.com with ESMTP id 2qcr0urbn2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <xdp-newbies@vger.kernel.org>; Fri, 01 Feb 2019 14:30:02 -0500
From: "Jones, Conner" <Connor.Jones@netscout.com>
Subject: bpf_perf_event_output() from pinned program
Date: Fri, 1 Feb 2019 19:29:54 +0000
Message-ID: <DM5PR0102MB3512A9C012B936AE7D9A6CCCF6920@DM5PR0102MB3512.prod.exchangelabs.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>


Hey All,

I've been struggling to try to get an eBPF program attached to XDP to output to a perf_event buffer. I have read the kernel samples [1][2] and found Toke's sample[3] but I can't seem to get my eBPF program to output to the PERF_EVENT_ARRAY. 

My current approach is that I have a binary which pins my maps and loads my elf object and attaches the program to XDP. I then have a second binary which allocates a file descriptor for each cpu with sys_perf_event_open() and stores that to the index of the map. I then use perf_event_mmap_header() to mmap all of the fds. I end by calling perf_event_poll_multi(). 

I have determined that bpf_perf_event_output() is returning ENOENT. Which makes sense when the program is first loaded but shouldn't the program use the fds in the map after they are put there by the second binary? or is this incorrect?

Summary: Is my approach of using two binaries valid? Can I update the PERF_EVENT_ARRY with the mmap'd fds after the program is running?

Any insight would be greatly appreciated!

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/samples/bpf/trace_output_user.c
[2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/samples/bpf/trace_output_kern.c
[3] https://lore.kernel.org/netdev/152830792912.21161.3609946361971472545.stgit@alrua-kau/
