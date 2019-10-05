Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pl1-f193.google.com ([209.85.214.193]:46454 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729081AbfJETW2 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Sat, 5 Oct 2019 15:22:28 -0400
Received: by mail-pl1-f193.google.com with SMTP id q24so4741877plr.13
        for <xdp-newbies@vger.kernel.org>; Sat, 05 Oct 2019 12:22:26 -0700 (PDT)
From: Eric Sage <eric@sage.org>
Subject: Re: samples/bpf not working?
Date: Sat,  5 Oct 2019 19:20:41 +0000
Message-Id: <20191005192040.20308-1-eric@sage.org>
In-Reply-To: <CAEKGpzhoYHrE4NTvaWSpy-R6CiLYehGHzLM6v+-9j8iemNyK0g@mail.gmail.com>
References: <CAEKGpzhoYHrE4NTvaWSpy-R6CiLYehGHzLM6v+-9j8iemNyK0g@mail.gmail.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: netdev@vger.kernel.org
Cc: bpf@vger.kernel.org, daniel@iogearbox.net, xdp-newbies@vger.kernel.org, ast@kernel.org, Eric Sage <eric@sage.org>

394053f4a4b3 ("kbuild: make single targets work more correctly")
changed the way single target builds work. For example,
'make samples/bpf/' in the previous commit matched:

Makefile:1787
%/: prepare FORCE
  $(Q)$(MAKE) KBUILD_MODULES=1 $(build)=$(build-dir) need-modorder=1

So that 'samples/bpf/Makefile' was processed directly.
Commit 394053f4a4b3 removed this rule and now requires that
'CONFIG_SAMPLES=y' and that 'bpf/' be added to 'samples/Makefile'
so it is added to the list of targets processed by the new
'ifdef single-build' section of 'scripts/Makefile.build'.

This commit adds a new 'CONFIG_SAMPLE_BPF' under 'CONFIG_SAMPLES' to
match what the other sample subdirs have done.

Signed-off-by: Eric Sage <eric@sage.org>
---
 samples/Kconfig  | 6 ++++++
 samples/Makefile | 1 +
 2 files changed, 7 insertions(+)

diff --git a/samples/Kconfig b/samples/Kconfig
index c8dacb4dda80..396e87ba97e0 100644
--- a/samples/Kconfig
+++ b/samples/Kconfig
@@ -6,6 +6,12 @@ menuconfig SAMPLES
 
 if SAMPLES
 
+config SAMPLE_BPF
+	tristate "Build bpf examples"
+	depends on EVENT_TRACING && m
+	help
+	  This builds the bpf example modules.
+
 config SAMPLE_TRACE_EVENTS
 	tristate "Build trace_events examples -- loadable modules only"
 	depends on EVENT_TRACING && m
diff --git a/samples/Makefile b/samples/Makefile
index 7d6e4ca28d69..e133a78f3fb8 100644
--- a/samples/Makefile
+++ b/samples/Makefile
@@ -2,6 +2,7 @@
 # Makefile for Linux samples code
 
 obj-$(CONFIG_SAMPLE_ANDROID_BINDERFS)	+= binderfs/
+obj-$(CONFIG_SAMPLE_BPF) += bpf/
 obj-$(CONFIG_SAMPLE_CONFIGFS)		+= configfs/
 obj-$(CONFIG_SAMPLE_CONNECTOR)		+= connector/
 subdir-$(CONFIG_SAMPLE_HIDRAW)		+= hidraw
-- 
2.18.1
