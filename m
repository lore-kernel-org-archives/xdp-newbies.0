Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:43542 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753080AbdDKV6U (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 11 Apr 2017 17:58:20 -0400
From: Jay Vosburgh <jay.vosburgh@canonical.com>
Subject: Re: [PATCH] Enable Netdev XDP tutorial for Ubuntu 17.04
In-reply-to: <20170411200154.GF4730@C02RW35GFVH8.dhcp.broadcom.net>
References: <20602.1491881713@famine> <20170411200154.GF4730@C02RW35GFVH8.dhcp.broadcom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Date: Tue, 11 Apr 2017 14:58:15 -0700
Message-ID: <3488.1491947895@famine>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Andy Gospodarek <andy@greyhouse.net>
Cc: xdp-newbies@vger.kernel.org, Jesper Dangaard Brouer <brouer@redhat.com>

Andy Gospodarek <andy@greyhouse.net> wrote:

>On Mon, Apr 10, 2017 at 08:35:13PM -0700, Jay Vosburgh wrote:
>> 	This patch resolves build issues when compiling the samples on
>> Ubuntu 17.04 with the distro 4.10 kernel and the linux-headers package
>> installed.  This permits running the samples using distro packages
>> without needing to rebuild the kernel from source.
>> 
>> 	Tested on a 17.04 VM using virtio_net.
>
>This is a good goal and I like where you are going with this.
>
>Unfortunately with this patch applied I cannot build against a locally
>installed and running kernel.
>
>$ make 
>gcc -O2 -Wall -o tools/lib/bpf/bpf.o -c tools/lib/bpf/bpf.c
>tools/lib/bpf/bpf.c: In function ‘bpf_create_map’:
>tools/lib/bpf/bpf.c:67:6: error: ‘union bpf_attr’ has no member named ‘map_flags’
>  attr.map_flags = map_flags;
>      ^
>Makefile:141: recipe for target 'tools/lib/bpf/bpf.o' failed
>make: *** [tools/lib/bpf/bpf.o] Error 1

	FWIW, I saw this error when originally trying to compile on the
Ubuntu 16.04 user space, because the glibc headers are too old to have
this field in bpf_attr.

>The build deps are not ideal in this Makefile, so I'm wondering if your
>build was successful because you had tools/lib/bpf/bpf.o left over from
>a successful build.  

	"make clean" looks like it erases that bpf.o, so I don't think
this was it.

	Also, I just noticed that make clean isn't getting the command
line program itself:

diff --git a/kernel/samples/bpf/Makefile b/kernel/samples/bpf/Makefile
index 7d77e53d6cd8..cd6b6ab03bb8 100644
--- a/kernel/samples/bpf/Makefile
+++ b/kernel/samples/bpf/Makefile
@@ -96,6 +96,7 @@ clean:
 	rm -f $(TARGETS)
 	rm -f $(KERN_OBJECTS)
 	rm -f $(USER_OBJECTS)
+	rm -f $(CMDLINE_TOOLS)
 
 dependencies: verify_llvm_target_bpf linux-src-devel-headers
 

>This patch on top of yours does work for me.  Can you add this on top
>and let me know if your build still works?

	With your patch applied, on my system it still builds fine.

	-J

>diff --git a/kernel/samples/bpf/Makefile b/kernel/samples/bpf/Makefile
>index 7d77e53..8e493b1 100644
>--- a/kernel/samples/bpf/Makefile
>+++ b/kernel/samples/bpf/Makefile
>@@ -49,7 +49,7 @@ KERNEL=$(kbuilddir)
> CFLAGS := -O2 -Wall
> 
> # Local copy of kernel/tools/lib/
>-USER_CFLAGS := $(CFLAGS) -I./tools/lib
>+USER_CFLAGS := $(CFLAGS) -I./tools/lib -I./tools/include/uapi/
> 
> LDFLAGS= -lelf
> 
>@@ -138,7 +138,7 @@ verify_llvm_target_bpf: verify_cmds
> 
> # The fake-minimal-libbpf
> $(OBJECT_LIBBPF): %.o: %.c
>-	$(CC) $(CFLAGS) -o $@ -c $<
>+	$(CC) $(USER_CFLAGS) -o $@ -c $<
> 
> $(OBJECT_LOADBPF): bpf_load.c
> 	$(CC) $(USER_CFLAGS) -o $@ -c $<
>
>> 
>> Signed-off-by: Jay Vosburgh <jay.vosburgh@canonical.com>
>> ---
>> 
>> 	I haven't tried the patched version of this on a built from
>> source kernel yet, so it might break that.
>> 
>>  kernel/samples/bpf/Makefile                       | 18 ++++--------------
>>  kernel/samples/bpf/libbpf.h                       |  2 +-
>>  kernel/samples/bpf/xdp_ddos01_blacklist_cmdline.c |  3 +--
>>  3 files changed, 6 insertions(+), 17 deletions(-)
>> 
>> diff --git a/kernel/samples/bpf/Makefile b/kernel/samples/bpf/Makefile
>> index 2aa4f73a6bba..7d77e53d6cd8 100644
>> --- a/kernel/samples/bpf/Makefile
>> +++ b/kernel/samples/bpf/Makefile
>> @@ -49,17 +49,7 @@ KERNEL=$(kbuilddir)
>>  CFLAGS := -O2 -Wall
>>  
>>  # Local copy of kernel/tools/lib/
>> -CFLAGS += -I./tools/lib
>> -#CFLAGS += -I$(KERNEL)/tools/lib
>> -#
>> -# Local copy of uapi/linux/bpf.h kept under ./tools/include
>> -# needed due to enum dependency in bpf_helpers.h
>> -CFLAGS += -I./tools/include
>> -CFLAGS += -I$(KERNEL)/tools/include
>> -#CFLAGS += -I$(KERNEL)/tools/perf
>> -CFLAGS += -I$(KERNEL)/usr/include
>> -# Strange dependency to "selftests" due to "bpf_util.h"
>> -#CFLAGS += -I$(KERNEL)/tools/testing/selftests/bpf/
>> +USER_CFLAGS := $(CFLAGS) -I./tools/lib
>>  
>>  LDFLAGS= -lelf
>>  
>> @@ -151,7 +141,7 @@ $(OBJECT_LIBBPF): %.o: %.c
>>  	$(CC) $(CFLAGS) -o $@ -c $<
>>  
>>  $(OBJECT_LOADBPF): bpf_load.c
>> -	$(CC) $(CFLAGS) -o $@ -c $<
>> +	$(CC) $(USER_CFLAGS) -o $@ -c $<
>>  
>>  # Compiling of eBPF restricted-C code with LLVM
>>  #  clang option -S generated output file with suffix .ll
>> @@ -168,7 +158,7 @@ $(KERN_OBJECTS): %.o: %.c
>>  	$(LLC) -march=bpf -filetype=obj -o $@ ${@:.o=.ll}
>>  
>>  $(TARGETS): %: %_user.c $(OBJECTS) Makefile
>> -	$(CC) $(CFLAGS) $(OBJECTS) $(LDFLAGS) -o $@ $<
>> +	$(CC) $(USER_CFLAGS) $(OBJECTS) $(LDFLAGS) -o $@ $<
>>  
>>  $(CMDLINE_TOOLS): %: %.c $(OBJECTS) Makefile $(COMMON_H)
>> -	$(CC) -g $(CFLAGS) $(OBJECTS) $(LDFLAGS) -o $@ $<
>> +	$(CC) -g $(USER_CFLAGS) $(OBJECTS) $(LDFLAGS) -o $@ $<
>> diff --git a/kernel/samples/bpf/libbpf.h b/kernel/samples/bpf/libbpf.h
>> index 1a3c7a06f4c3..b572a0517498 100644
>> --- a/kernel/samples/bpf/libbpf.h
>> +++ b/kernel/samples/bpf/libbpf.h
>> @@ -9,7 +9,7 @@
>>   * construct of -I$(KERNEL)/tools/lib/ this include find
>>   * tools/lib/bpf/bpf.h which defines the userspace API
>>   */
>> -#include <bpf/bpf.h>
>> +#include "bpf/bpf.h"
>>  
>>  struct bpf_insn;
>>  
>> diff --git a/kernel/samples/bpf/xdp_ddos01_blacklist_cmdline.c b/kernel/samples/bpf/xdp_ddos01_blacklist_cmdline.c
>> index 11157f94b062..5cf297ee2664 100644
>> --- a/kernel/samples/bpf/xdp_ddos01_blacklist_cmdline.c
>> +++ b/kernel/samples/bpf/xdp_ddos01_blacklist_cmdline.c
>> @@ -13,7 +13,6 @@ static const char *__doc__=
>>  #include <string.h>
>>  #include <unistd.h>
>>  #include <locale.h>
>> -#include <linux/bitops.h>
>>  
>>  #include <sys/resource.h>
>>  #include <getopt.h>
>> @@ -212,7 +211,7 @@ static void blacklist_print_proto(int key, __u64 count)
>>  	printf("\n\t\"%s\" : %llu", xdp_proto_filter_names[key], count);
>>  }
>>  
>> -static void blacklist_print_port(int key, u32 val, int countfds[])
>> +static void blacklist_print_port(int key, __u32 val, int countfds[])
>>  {
>>  	int i;
>>  	__u64 count;
>> -- 
>> 2.7.4
>> 

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
