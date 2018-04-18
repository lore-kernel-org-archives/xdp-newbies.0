Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:52991 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752050AbeDRWpH (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 18 Apr 2018 18:45:07 -0400
Received: from [62.202.221.10] (helo=linux.home)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-SHA:256)
        (Exim 4.85_2)
        (envelope-from <daniel@iogearbox.net>)
        id 1f8vp4-0004Bg-AT
        for xdp-newbies@vger.kernel.org; Thu, 19 Apr 2018 00:45:06 +0200
From: Daniel Borkmann <daniel@iogearbox.net>
Subject: BPF doc updates ...
Message-ID: <1468383d-fd50-dbc0-5329-2f9d5bee81a0@iogearbox.net>
Date: Thu, 19 Apr 2018 00:45:05 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org

Just fyi, for those interested, added several updates to the BPF doc
including better coverage for llvm, bpftool, bpf calls, iproute2, tc,
xdp and various miscellaneous bits:

http://cilium.readthedocs.io/en/latest/bpf/
