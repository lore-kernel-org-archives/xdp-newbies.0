Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from smtp2.iitd.ac.in ([103.27.10.44]:57736 "EHLO smtp2.iitd.ac.in"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752163AbdLDOj0 (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 4 Dec 2017 09:39:26 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp2.iitd.ac.in (Postfix) with ESMTP id 6FC5640190
        for <xdp-newbies@vger.kernel.org>; Mon,  4 Dec 2017 20:09:23 +0530 (IST)
Received: from smtp2.iitd.ac.in ([127.0.0.1])
        by localhost (smtp2.iitd.ac.in [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 02RRtGnb9YOu for <xdp-newbies@vger.kernel.org>;
        Mon,  4 Dec 2017 20:09:19 +0530 (IST)
Received: from webmail.iitd.ac.in (webmail.iitd.ac.in [10.7.172.189])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: anmol07.visitor)
        by smtp2.iitd.ac.in (Postfix) with ESMTPSA id A32064008D
        for <xdp-newbies@vger.kernel.org>; Mon,  4 Dec 2017 20:09:19 +0530 (IST)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Mon, 04 Dec 2017 20:09:19 +0530
From: Anmol Panda <anmol07.visitor@cse.iitd.ac.in>
Subject: Common hash function for kernel and user space in XDP
Reply-To: anmol07.visitor@cse.iitd.ac.in
Message-ID: <3580c48c28ad1688229efe962bc96c9a@cse.iitd.ac.in>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Xdp <xdp-newbies@vger.kernel.org>

Hello All,
    We are trying to implement L2 forwarding in xdp and we need to 
convert the mac-address to a hash value. Thus far, we have tried using 
crc32 functions from <linux/crc32.h> for kernel space but it can't be 
used in user space. We need a common crc hash function for both kernel 
and user space.

    The kernel crc function causes the following error:

invalid relo for insn[24].code 0x85
bpf_load_program() err=22
0: (61) r2 = *(u32 *)(r1 +4)
1: (61) r1 = *(u32 *)(r1 +0)
.
.
.
23: (b7) r3 = 6
24: (85) call unknown#-1
BPF_CALL uses reserved fields


    Can you please point to some examples or references?
    We would be highly grateful.

Thanks,
Sincerely,
