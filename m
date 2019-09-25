Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx1.univ-lille.fr ([194.254.129.33]:39560 "EHLO
        mx1.univ-lille.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727150AbfIYJSW (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 25 Sep 2019 05:18:22 -0400
Received: from smtp2.univ-lille.fr (smtp2.univ-lille.fr [10.140.10.73])
        by mx1.univ-lille.fr (LA PUISSANCE) with ESMTP id 74DFC4A39C
        for <xdp-newbies@vger.kernel.org>; Wed, 25 Sep 2019 11:10:44 +0200 (CEST)
Received: from [10.147.1.182] (238.ip-137-74-40.eu [137.74.40.238])
        (Authenticated sender: theo.mainguet.etu)
        by smtp2.univ-lille.fr (Postfix) with ESMTPSA id 1CE343FFE0
        for <xdp-newbies@vger.kernel.org>; Wed, 25 Sep 2019 11:10:44 +0200 (CEST)
From: =?UTF-8?Q?Th=c3=a9o_Mainguet?= <theo.mainguet.etu@univ-lille.fr>
Subject: [xdp-tutorial] : permission denied when I try to execute a program
Message-ID: <0cbbc2e2-9eba-ad40-d819-d092b2015707@univ-lille.fr>
Date: Wed, 25 Sep 2019 11:10:43 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org

Hi,


Thank you very much for your xdp tutorial. Currently, I try to write a 
simple xdp program to count the number of TCP and UDP packets I receive. 
For that, I created a BPF_MAP_TYPE_ARRAY map in my kern.c file. I can 
read into this map with the bpf_map_lookup_elem function but when I try 
to update a value, I have an error message "libbpf: load bpf program 
failed: Permission denied". To solve this issue, I've try to run it in 
sudo, I've verify my kernel configuration (everything needed seems 
enable) ....

I searched a solution on the internet but I didn't found anything 
relevant. I hope you can help me.

Théo Mainguet


My kernel configuration :

$ cat /boot/config-4.19.0-6-amd64 | grep BPF

CONFIG_CGROUP_BPF=y
CONFIG_BPF=y
CONFIG_BPF_SYSCALL=y
# CONFIG_BPF_JIT_ALWAYS_ON is not set
CONFIG_IPV6_SEG6_BPF=y
CONFIG_NETFILTER_XT_MATCH_BPF=m
# CONFIG_BPFILTER is not set
CONFIG_NET_CLS_BPF=m
CONFIG_NET_ACT_BPF=m
CONFIG_BPF_JIT=y
CONFIG_BPF_STREAM_PARSER=y
CONFIG_LWTUNNEL_BPF=y
CONFIG_HAVE_EBPF_JIT=y
CONFIG_BPF_EVENTS=y
# CONFIG_BPF_KPROBE_OVERRIDE is not set
CONFIG_TEST_BPF=m
