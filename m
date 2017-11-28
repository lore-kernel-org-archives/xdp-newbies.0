Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from smtp2.iitd.ac.in ([103.27.10.44]:58360 "EHLO smtp2.iitd.ac.in"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753673AbdK1MTv (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 28 Nov 2017 07:19:51 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp2.iitd.ac.in (Postfix) with ESMTP id 536CA40D86
        for <xdp-newbies@vger.kernel.org>; Tue, 28 Nov 2017 17:49:48 +0530 (IST)
Received: from smtp2.iitd.ac.in ([127.0.0.1])
        by localhost (smtp2.iitd.ac.in [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id t4SWwAjSRK5E for <xdp-newbies@vger.kernel.org>;
        Tue, 28 Nov 2017 17:49:44 +0530 (IST)
Received: from webmail.iitd.ac.in (webmail.iitd.ac.in [10.7.172.189])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: anmol07.visitor)
        by smtp2.iitd.ac.in (Postfix) with ESMTPSA id 49E2640D75
        for <xdp-newbies@vger.kernel.org>; Tue, 28 Nov 2017 17:49:44 +0530 (IST)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Tue, 28 Nov 2017 17:49:44 +0530
From: Anmol Panda <anmol07.visitor@cse.iitd.ac.in>
Subject: Compile error with unsigned integers
Reply-To: anmol07.visitor@cse.iitd.ac.in
Message-ID: <6fc588408c38bdb9fe79b4128bb4e124@cse.iitd.ac.in>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Xdp <xdp-newbies@vger.kernel.org>

Dear all,

     We are trying to compile the xdp programs in the /tests folder of 
p4c-xdp. On compiling from .c to .o using clang:
clang -O2 -S -Wall -target bpf -c xdp1-mod.c -o xdp1-mod.o

the following errors are reported:

In file included from xdp1-mod.c:3:
./xdp1-mod.h:16:5: error: unknown type name 'u32'
     u32 input_port; /* bit<32> */
     ^
./xdp1-mod.h:21:5: error: unknown type name 'u32'
     u32 output_port; /* bit<32> */
     ^
./xdp1-mod.h:25:5: error: unknown type name 'u64'
     u64 destination; /* bit<48> */
     ^
./xdp1-mod.h:26:5: error: unknown type name 'u64'
     u64 source; /* bit<48> */
     ^
./xdp1-mod.h:27:5: error: unknown type name 'u16'
     u16 etherType; /* bit<16> */
     ^
    It reports 20 such errors and exits. We weren't getting such errors 
before when we successfully compiled and ran the test programs and even 
some programs that we had written. After browsing for this error, we 
tried including <stdint.h> and <linux/types.h>, but the error persists.

    The libstdc++ version is 7.2.0, llvm version is 6.0.0svn. Please 
guide us how we may resolve this issue. We are utmost grateful for your 
help and time.

Awaiting your response,
Sincerely,
