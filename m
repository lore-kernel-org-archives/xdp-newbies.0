Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:59561 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1161596AbdDUU6r (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 21 Apr 2017 16:58:47 -0400
From: Jay Vosburgh <jay.vosburgh@canonical.com>
Subject: Re: [PATCH] Enable Netdev XDP tutorial for Ubuntu 17.04
In-reply-to: <1491997888.2855.1.camel@sipsolutions.net>
References: <20602.1491881713@famine> (sfid-20170411_053552_749185_2EF01FC0) <1491997888.2855.1.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Date: Fri, 21 Apr 2017 13:58:42 -0700
Message-ID: <5170.1492808322@famine>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: xdp-newbies@vger.kernel.org, Jesper Dangaard Brouer <brouer@redhat.com>, Andy Gospodarek <andy@greyhouse.net>


Johannes Berg <johannes@sipsolutions.net> wrote:

>On Mon, 2017-04-10 at 20:35 -0700, Jay Vosburgh wrote:
>> 	This patch resolves build issues when compiling the samples on
>> Ubuntu 17.04 with the distro 4.10 kernel and the linux-headers
>> package
>> installed.  This permits running the samples using distro packages
>> without needing to rebuild the kernel from source.
>> 
>> 	Tested on a 17.04 VM using virtio_net.
>> 
>> Signed-off-by: Jay Vosburgh <jay.vosburgh@canonical.com>
>> ---
>> 
>> 	I haven't tried the patched version of this on a built from
>> source kernel yet, so it might break that.
>
>I was able to build on a recent Debian testing by simply inserting the
>following line into samples/bpf/Makefile to force it to use the
>kernel's UAPI instead of the installed headers:
>
>HOSTCFLAGS += -I$(srctree)/include/uapi/ -D__EXPORTED_HEADERS__

	Getting back to this after a couple of weeks...

	The above changes didn't make any difference for me, but it
turns out all of the various Makefile hacks I did previously aren't
needed for Ubuntu 17.04, the following lets the examples build and run
fine:

diff --git a/kernel/samples/bpf/xdp_ddos01_blacklist_cmdline.c b/kernel/samples/bpf/xdp_ddos01_blacklist_cmdline.c
index 11157f9..5cf297e 100644
--- a/kernel/samples/bpf/xdp_ddos01_blacklist_cmdline.c
+++ b/kernel/samples/bpf/xdp_ddos01_blacklist_cmdline.c
@@ -13,7 +13,6 @@ static const char *__doc__=
 #include <string.h>
 #include <unistd.h>
 #include <locale.h>
-#include <linux/bitops.h>
 
 #include <sys/resource.h>
 #include <getopt.h>
@@ -212,7 +211,7 @@ static void blacklist_print_proto(int key, __u64 count)
 	printf("\n\t\"%s\" : %llu", xdp_proto_filter_names[key], count);
 }
 
-static void blacklist_print_port(int key, u32 val, int countfds[])
+static void blacklist_print_port(int key, __u32 val, int countfds[])
 {
 	int i;
 	__u64 count;


	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
