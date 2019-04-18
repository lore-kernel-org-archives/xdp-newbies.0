Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:49308 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726162AbfDRMmm (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 18 Apr 2019 08:42:42 -0400
Date: Thu, 18 Apr 2019 09:42:23 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: Avoiding merge conflicts while adding new docs - Was: Re: [PATCH
 00/57] Convert files to ReST
Message-ID: <20190418091526.00e074d1@coco.lan>
In-Reply-To: <cover.1555382110.git.mchehab+samsung@kernel.org>
References: <cover.1555382110.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Linux Doc Mailing List <linux-doc@vger.kernel.org>, Mauro Carvalho Chehab <mchehab@infradead.org>, linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, linux-fbdev@vger.kernel.org, linux-s390@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-watchdog@vger.kernel.org, xdp-newbies@vger.kernel.org, linux-samsung-soc@vger.kernel.org, linux-acpi@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, bpf@vger.kernel.org, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-scsi@vger.kernel.org, linux-gpio@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, x86@kernel.org, dm-devel@redhat.com, target-devel@vger.kernel.org, netdev@vger.kernel.org, kexec@lists.infradead.org, linux-fpga@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kbuild@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, linux-security-module@vger.kernel.org, linux-usb@vger.kernel.org, linux-arm-kernel@lists.infradead.org

Jon,

Em Mon, 15 Apr 2019 23:55:25 -0300
Mauro Carvalho Chehab <mchehab+samsung@kernel.org> escreveu:

> I have a separate patch series with do the actual rename and
> adjustment of references. I opted to submit this first, as it
> sounds easier to merge this way, as each subsystem maintainer
> can apply the conversion directly on their trees (or at docs
> tree), avoiding merge conflects.

Based on the number of feedbacks we have about this, I'm
considering to submit a second version of my conversion patch
series that would be doing the rename together with each patch,
adding the rst files to an index file.

However, doing that would produce lots of warnings. We have
already lots of those at linux-next:

	checking consistency... 

	docs/Documentation/accelerators/ocxl.rst: WARNING: document isn't included in any toctree
	docs/Documentation/admin-guide/mm/numaperf.rst: WARNING: document isn't included in any toctree
	docs/Documentation/filesystems/ext4/allocators.rst: WARNING: document isn't included in any toctree
	docs/Documentation/filesystems/ext4/attributes.rst: WARNING: document isn't included in any toctree
	docs/Documentation/filesystems/ext4/bigalloc.rst: WARNING: document isn't included in any toctree
	docs/Documentation/filesystems/ext4/bitmaps.rst: WARNING: document isn't included in any toctree
	docs/Documentation/filesystems/ext4/blockgroup.rst: WARNING: document isn't included in any toctree
	docs/Documentation/filesystems/ext4/blocks.rst: WARNING: document isn't included in any toctree
	docs/Documentation/filesystems/ext4/checksums.rst: WARNING: document isn't included in any toctree
	docs/Documentation/filesystems/ext4/directory.rst: WARNING: document isn't included in any toctree
	docs/Documentation/filesystems/ext4/eainode.rst: WARNING: document isn't included in any toctree
	docs/Documentation/filesystems/ext4/group_descr.rst: WARNING: document isn't included in any toctree
	docs/Documentation/filesystems/ext4/ifork.rst: WARNING: document isn't included in any toctree
	docs/Documentation/filesystems/ext4/inlinedata.rst: WARNING: document isn't included in any toctree
	docs/Documentation/filesystems/ext4/inodes.rst: WARNING: document isn't included in any toctree
	docs/Documentation/filesystems/ext4/journal.rst: WARNING: document isn't included in any toctree
	docs/Documentation/filesystems/ext4/mmp.rst: WARNING: document isn't included in any toctree
	docs/Documentation/filesystems/ext4/special_inodes.rst: WARNING: document isn't included in any toctree
	docs/Documentation/filesystems/ext4/super.rst: WARNING: document isn't included in any toctree
	docs/Documentation/fmc/index.rst: WARNING: document isn't included in any toctree
	docs/Documentation/gpu/msm-crash-dump.rst: WARNING: document isn't included in any toctree
	docs/Documentation/interconnect/interconnect.rst: WARNING: document isn't included in any toctree
	docs/Documentation/laptops/lg-laptop.rst: WARNING: document isn't included in any toctree
	docs/Documentation/virtual/kvm/amd-memory-encryption.rst: WARNING: document isn't included in any toctree
	docs/Documentation/virtual/kvm/vcpu-requests.rst: WARNING: document isn't included in any toctree

After thinking a little bit and doing some tests, I think a good solution
would be to add ":orphan:" markup to the new .rst files that were not
added yet into the main body (e. g. something like the enclosed example).

That will make Sphinx suppress the:
	"WARNING: document isn't included in any toctree"
warning for the new files, while they're not included at the main indexes.

This way, maintainers can do all the hard work of doing/applying the ReST
file conversion/addition patch series on their own trees, and, once
everything gets merged, submit a patch against the latest docs-next
tree, removing the :orphan: tag and add them to the common index.rst
files.

That should largely avoid merging conflicts.

For example, assuming that someone converts the stuff at
Documentation/accounting and rename the text files there to
RST (I'm actually doing that), he could add the enclosed change on
the top of its index file:

	diff --git a/Documentation/accounting/index.rst b/Documentation/accounting/index.rst
	index e7dda5afa73f..e1f6284b5ff3 100644
	--- a/Documentation/accounting/index.rst
	+++ b/Documentation/accounting/index.rst
	@@ -1,3 +1,5 @@
	+:orphan:
	+
	 ==========
	 Accounting
	 ==========

With would make Sphinx to ignore the subdir index file while
reporting errors. It will still build the documentation, allowing
the developer to test the changes.

One of the advantages is that checking the orphaned docs is as
easy as running:

	$ git grep -l ":orphan:" Documentation/
	...
	Documentation/accounting/index.rst
	...

Making easy for people to check the orphaned files and send a fixup
patch if something got orphaned after the merge window and send a
fixes patches to be applied upstream.

What do you think?

Regards,
Mauro
