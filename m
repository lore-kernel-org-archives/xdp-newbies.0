Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:26126 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753000AbdKGXTE (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 7 Nov 2017 18:19:04 -0500
From: "Mathew, Elza" <elza.mathew@intel.com>
Subject: nlmsg error Cannot allocate memory
Date: Tue, 7 Nov 2017 23:19:02 +0000
Message-ID: <14F79F4FCCB5574FBE4B89C8CDB514BA24CF3B0E@ORSMSX111.amr.corp.intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>

Hi,
I am trying to run the XDP sample programs (located at samples/bpf/xdp1 and samples/bpf/xdp2) on the ixgbe driver. I am getting this error:

./xdp1 15
nlmsg error Cannot allocate memory
link set xdp fd failed

Kernel version : 4.13.0+
Driver version : 5.1.0-k

Is there any setup issues I might be doing wrong? I have BPF_SYSCALL=y enabled in my kernel config file.
Thanks!
Elza
