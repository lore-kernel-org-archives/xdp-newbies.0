Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from ms.lwn.net ([45.79.88.28]:41090 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725820AbfDSWLB (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 19 Apr 2019 18:11:01 -0400
Date: Fri, 19 Apr 2019 16:10:58 -0600
From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: Avoiding merge conflicts while adding new docs - Was: Re:
 [PATCH 00/57] Convert files to ReST
Message-ID: <20190419161058.3628a29b@lwn.net>
In-Reply-To: <20190418091526.00e074d1@coco.lan>
References: <cover.1555382110.git.mchehab+samsung@kernel.org>
        <20190418091526.00e074d1@coco.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Linux Doc Mailing List <linux-doc@vger.kernel.org>, Mauro Carvalho Chehab <mchehab@infradead.org>, linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, linux-fbdev@vger.kernel.org, linux-s390@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-watchdog@vger.kernel.org, xdp-newbies@vger.kernel.org, linux-samsung-soc@vger.kernel.org, linux-acpi@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, bpf@vger.kernel.org, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-scsi@vger.kernel.org, linux-gpio@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, x86@kernel.org, dm-devel@redhat.com, target-devel@vger.kernel.org, netdev@vger.kernel.org, kexec@lists.infradead.org, linux-fpga@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kbuild@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, linux-security-module@vger.kernel.org, linux-usb@vger.kernel.org, linux-arm-kernel@lists.infradead.org

On Thu, 18 Apr 2019 09:42:23 -0300
Mauro Carvalho Chehab <mchehab+samsung@kernel.org> wrote:

> After thinking a little bit and doing some tests, I think a good solution
> would be to add ":orphan:" markup to the new .rst files that were not
> added yet into the main body (e. g. something like the enclosed example).

Interesting...I didn't know about that.  Yes, I think it makes sense to
put that in...

jon
