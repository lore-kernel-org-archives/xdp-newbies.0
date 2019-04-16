Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:44184 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726774AbfDPC4c (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 15 Apr 2019 22:56:32 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH 00/57] Convert files to ReST
Date: Mon, 15 Apr 2019 23:55:25 -0300
Message-Id: <cover.1555382110.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>, Mauro Carvalho Chehab <mchehab@infradead.org>, linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, linux-riscv@lists.infradead.org, linux-fbdev@vger.kernel.org, linux-s390@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-watchdog@vger.kernel.org, xdp-newbies@vger.kernel.org, linux-samsung-soc@vger.kernel.org, linux-acpi@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, bpf@vger.kernel.org, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-scsi@vger.kernel.org, linux-gpio@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, x86@kernel.org, dm-devel@redhat.com, target-devel@vger.kernel.org, netdev@vger.kernel.org, kexec@lists.infradead.org, linux-fpga@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kbuild@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, linux-security-module@vger.kernel.org, linux-usb@vger.kernel.org, linux-arm-kernel@lists.infradead.org

This series convert lots of files to be properly parsed by Sphinx
as ReST files.

As it touches on lot of stuff, the series is based on linux-next.

I have a separate patch series with do the actual rename and
adjustment of references. I opted to submit this first, as it
sounds easier to merge this way, as each subsystem maintainer
can apply the conversion directly on their trees (or at docs
tree), avoiding merge conflects.

Both this series and  the next steps are on my devel git tree,
at:
	https://git.linuxtv.org/mchehab/experimental.git/log/?h=all_with_indexes-v3

The final output in html can be seen at:

	https://www.infradead.org/~mchehab/rst_conversion/

Mauro Carvalho Chehab (57):
  docs: trace: fix some Sphinx warnings
  docs: acpi: convert text files to ReST
  docs: aoe: convert text files to ReST
  docs: arm64: convert documentation to ReST format
  docs: cdrom/cdrom-standard.tex: convert from LaTeX to ReST
  docs: cdrom: convert remaining files to ReST
  docs: cgroup-v1: convert to ReST file format
  docs: cgroup-v1/blkio-controller.rst: add a note about CFQ scheduler
  docs: cpu-freq: convert files to ReST
  docs: device-mapper: convert it to ReST format
  docs: extcon: move it to acpi dir and convert it to ReST
  docs: fault-injection: convert it to ReST format
  docs: fb: convert documentation to ReST format
  docs: fpga: convert it to ReST
  docs: gpio: convert it to ReST
  docs: ide: convert it to ReST format
  docs: infiniband: convert it to ReST format
  docs: kbuild: convert it to ReST output
  docs: kdump: convert it to ReST
  docs: livepatch: convert it to ReST format
  docs: locking: convert docs to ReST format
  docs: mic: convert it to ReST format
  docs: netlabel: convert it to ReST
  docs: pcmcia: convert it to ReST format
  docs: power: convert docs to ReST
  docs: powerpc: convert docs to ReST
  docs: pps/pps.txt convert it to ReST and move to API book
  docs: ptp.txt: convert to ReST and move to driver-api
  docs: riscv: convert it to ReST format
  docs: s390: Debugging390.txt: convert table to ascii artwork
  docs: s390: convert text files to ReST format
  s390: include/asm/debug.h add kerneldoc markups
  docs: serial: convert it to ReST format
  docs: target: convert it to ReST format
  docs: timers: convert documentation to ReST
  docs: usb: convert documents to ReST
  docs: watchdog: convert documents to ReST format
  docs: x86: convert text files to ReST
  docs: xilinx: convert eemi.txt to ReST
  docs: scheduler: convert files to ReST
  docs: EDID/HOWTO.txt: convert to ReST and move to kernel-API
  docs: connector.txt: convert to ReST
  docs: lcd-panel-cgram.txt convert it to ReST and move to admin-guide
  docs: lp855x-driver.txt: convert to ReST and move to kernel-api
  docs: m68k: convert it to ReST file format and add to arch bookset
  docs: cma/debugfs.txt: convert to ReST and move to admin-guide/mm
  docs: console.txt: convert to ReST format
  docs: pti_intel_mid.txt: convert to ReST
  docs: early-userspace: convert docs to ReST
  docs: driver-model: convert it to ReST format
  docs: arm: convert text files to ReST format
  docs: memory-devices: convert ti-emif.txt to ReST format
  docs: xen-tpmfront.txt: convert the file to ReST format
  docs: bus-devices: ti-gpmc.txt: convert it to ReST
  docs: nvmem: convert file to ReST format
  docs: phy: convert samsung-usb2.txt to ReST format
  docs: Prepare files to be renamed to *.rst

 Documentation/EDID/HOWTO.txt                  |   29 +-
 Documentation/acpi/DSD-properties-rules.txt   |    4 +-
 Documentation/acpi/acpi-lid.txt               |   37 +-
 Documentation/acpi/aml-debugger.txt           |   31 +-
 Documentation/acpi/apei/einj.txt              |   59 +-
 Documentation/acpi/apei/output_format.txt     |  247 +-
 Documentation/acpi/cppc_sysfs.txt             |   52 +-
 Documentation/acpi/debug.txt                  |   20 +-
 .../drivers/extcon-intel-int3496.txt}         |   14 +-
 .../acpi/dsd/data-node-references.txt         |   11 +-
 Documentation/acpi/dsd/graph.txt              |   24 +-
 Documentation/acpi/dsd/leds.txt               |   18 +-
 Documentation/acpi/dsdt-override.txt          |    4 +-
 Documentation/acpi/enumeration.txt            |   42 +-
 Documentation/acpi/gpio-properties.txt        |   42 +-
 Documentation/acpi/i2c-muxes.txt              |   21 +-
 Documentation/acpi/initrd_table_override.txt  |   90 +-
 Documentation/acpi/linuxized-acpica.txt       |   58 +-
 Documentation/acpi/lpit.txt                   |    8 +-
 Documentation/acpi/method-customizing.txt     |   48 +-
 Documentation/acpi/method-tracing.txt         |  132 +-
 Documentation/acpi/namespace.txt              |  323 +-
 Documentation/acpi/osi.txt                    |    3 +-
 Documentation/acpi/scan_handlers.txt          |    9 +-
 Documentation/acpi/ssdt-overlays.txt          |  128 +-
 Documentation/acpi/video_extension.txt        |   16 +-
 Documentation/aoe/aoe.txt                     |   63 +-
 Documentation/aoe/todo.txt                    |    3 +
 Documentation/aoe/udev.txt                    |    2 +-
 Documentation/arm/Booting                     |   71 +-
 Documentation/arm/IXP4xx                      |   61 +-
 Documentation/arm/Interrupts                  |   86 +-
 Documentation/arm/Marvell/README              |  537 ++--
 Documentation/arm/Microchip/README            |   63 +-
 Documentation/arm/Netwinder                   |   59 +-
 Documentation/arm/OMAP/DSS                    |  112 +-
 Documentation/arm/OMAP/README                 |    7 +
 Documentation/arm/OMAP/omap_pm                |   55 +-
 Documentation/arm/Porting                     |   14 +-
 Documentation/arm/README                      |   50 +-
 Documentation/arm/SA1100/ADSBitsy             |   14 +-
 Documentation/arm/SA1100/Assabet              |  185 +-
 Documentation/arm/SA1100/Brutus               |   45 +-
 Documentation/arm/SA1100/CERF                 |   10 +-
 Documentation/arm/SA1100/FreeBird             |   26 +-
 Documentation/arm/SA1100/GraphicsClient       |   46 +-
 Documentation/arm/SA1100/GraphicsMaster       |   13 +-
 Documentation/arm/SA1100/HUW_WEBPANEL         |    8 +-
 Documentation/arm/SA1100/Itsy                 |   14 +-
 Documentation/arm/SA1100/LART                 |    3 +-
 Documentation/arm/SA1100/PLEB                 |    6 +-
 Documentation/arm/SA1100/Pangolin             |   10 +-
 Documentation/arm/SA1100/Tifon                |    4 +-
 Documentation/arm/SA1100/Yopy                 |    5 +-
 Documentation/arm/SA1100/empeg                |    2 -
 Documentation/arm/SA1100/nanoEngine           |    6 +-
 Documentation/arm/SA1100/serial_UART          |   60 +-
 Documentation/arm/SPEAr/overview.txt          |   20 +-
 Documentation/arm/Samsung-S3C24XX/CPUfreq.txt |    5 +-
 .../arm/Samsung-S3C24XX/EB2410ITX.txt         |    5 +-
 Documentation/arm/Samsung-S3C24XX/GPIO.txt    |   21 +-
 Documentation/arm/Samsung-S3C24XX/H1940.txt   |    5 +-
 Documentation/arm/Samsung-S3C24XX/NAND.txt    |    6 +-
 .../arm/Samsung-S3C24XX/Overview.txt          |   15 +-
 Documentation/arm/Samsung-S3C24XX/S3C2412.txt |    5 +-
 Documentation/arm/Samsung-S3C24XX/S3C2413.txt |    7 +-
 .../arm/Samsung-S3C24XX/SMDK2440.txt          |    5 +-
 Documentation/arm/Samsung-S3C24XX/Suspend.txt |   20 +-
 .../arm/Samsung-S3C24XX/USB-Host.txt          |   16 +-
 .../arm/Samsung/Bootloader-interface.txt      |   27 +-
 Documentation/arm/Samsung/GPIO.txt            |    5 +-
 Documentation/arm/Samsung/Overview.txt        |   11 +-
 Documentation/arm/Setup                       |   49 +-
 Documentation/arm/VFP/release-notes.txt       |    4 +-
 .../arm/cluster-pm-race-avoidance.txt         |  177 +-
 Documentation/arm/firmware.txt                |   14 +-
 Documentation/arm/kernel_mode_neon.txt        |    3 +
 Documentation/arm/kernel_user_helpers.txt     |   79 +-
 Documentation/arm/keystone/Overview.txt       |   47 +-
 Documentation/arm/keystone/knav-qmss.txt      |    6 +-
 Documentation/arm/mem_alignment               |   11 +-
 Documentation/arm/memory.txt                  |    9 +-
 Documentation/arm/nwfpe/NOTES                 |    3 +
 Documentation/arm/nwfpe/README                |   10 +-
 Documentation/arm/nwfpe/README.FPE            |   24 +-
 Documentation/arm/nwfpe/TODO                  |   47 +-
 Documentation/arm/pxa/mfp.txt                 |  106 +-
 Documentation/arm/sti/overview.txt            |   21 +-
 Documentation/arm/sti/stih407-overview.txt    |    9 +-
 Documentation/arm/sti/stih415-overview.txt    |    8 +-
 Documentation/arm/sti/stih416-overview.txt    |    5 +-
 Documentation/arm/sti/stih418-overview.txt    |    9 +-
 .../arm/stm32/stm32f429-overview.rst          |    5 +-
 .../arm/stm32/stm32f746-overview.rst          |    5 +-
 .../arm/stm32/stm32f769-overview.rst          |    5 +-
 .../arm/stm32/stm32h743-overview.rst          |    5 +-
 .../arm/stm32/stm32mp157-overview.rst         |    1 +
 Documentation/arm/sunxi/README                |   98 +-
 Documentation/arm/sunxi/clocks.txt            |    7 +-
 Documentation/arm/swp_emulation               |   24 +-
 Documentation/arm/tcm.txt                     |   54 +-
 Documentation/arm/uefi.txt                    |   39 +-
 Documentation/arm/vlocks.txt                  |    9 +-
 Documentation/arm64/acpi_object_usage.txt     |  288 +-
 Documentation/arm64/arm-acpi.txt              |  153 +-
 Documentation/arm64/booting.txt               |   91 +-
 Documentation/arm64/cpu-feature-registers.txt |  190 +-
 Documentation/arm64/elf_hwcaps.txt            |   50 +-
 Documentation/arm64/hugetlbpage.txt           |    7 +-
 Documentation/arm64/legacy_instructions.txt   |   43 +-
 Documentation/arm64/memory.txt                |   91 +-
 .../arm64/pointer-authentication.txt          |    2 +
 Documentation/arm64/silicon-errata.txt        |   63 +-
 Documentation/arm64/sve.txt                   |   10 +-
 Documentation/arm64/tagged-pointers.txt       |    6 +-
 Documentation/auxdisplay/lcd-panel-cgram.txt  |    7 +-
 Documentation/backlight/lp855x-driver.txt     |   65 +-
 Documentation/bt8xxgpio.txt                   |    1 -
 Documentation/bus-devices/ti-gpmc.txt         |  157 +-
 Documentation/bus-virt-phys-mapping.txt       |   50 +-
 Documentation/cdrom/Makefile                  |   21 -
 Documentation/cdrom/cdrom-standard.tex        | 1026 -------
 Documentation/cdrom/cdrom-standard.txt        | 1063 +++++++
 Documentation/cdrom/ide-cd                    |  178 +-
 Documentation/cdrom/packet-writing.txt        |   27 +-
 Documentation/cgroup-v1/blkio-controller.txt  |  103 +-
 Documentation/cgroup-v1/cgroups.txt           |  180 +-
 Documentation/cgroup-v1/cpuacct.txt           |   15 +-
 Documentation/cgroup-v1/cpusets.txt           |  203 +-
 Documentation/cgroup-v1/devices.txt           |   40 +-
 Documentation/cgroup-v1/freezer-subsystem.txt |   14 +-
 Documentation/cgroup-v1/hugetlb.txt           |   31 +-
 Documentation/cgroup-v1/memcg_test.txt        |  259 +-
 Documentation/cgroup-v1/memory.txt            |  449 +--
 Documentation/cgroup-v1/net_cls.txt           |   37 +-
 Documentation/cgroup-v1/net_prio.txt          |   24 +-
 Documentation/cgroup-v1/pids.txt              |   78 +-
 Documentation/cgroup-v1/rdma.txt              |   66 +-
 Documentation/cma/debugfs.txt                 |    6 +-
 Documentation/connector/connector.txt         |  128 +-
 Documentation/console/console.txt             |   61 +-
 Documentation/cpu-freq/amd-powernow.txt       |   11 +-
 Documentation/cpu-freq/core.txt               |   66 +-
 Documentation/cpu-freq/cpu-drivers.txt        |  217 +-
 Documentation/cpu-freq/cpufreq-nforce2.txt    |   12 +-
 Documentation/cpu-freq/cpufreq-stats.txt      |  141 +-
 Documentation/cpu-freq/pcc-cpufreq.txt        |  102 +-
 .../device-mapper/cache-policies.txt          |   24 +-
 Documentation/device-mapper/cache.txt         |  206 +-
 Documentation/device-mapper/delay.txt         |   29 +-
 Documentation/device-mapper/dm-crypt.txt      |   57 +-
 Documentation/device-mapper/dm-flakey.txt     |   45 +-
 Documentation/device-mapper/dm-init.txt       |   75 +-
 Documentation/device-mapper/dm-integrity.txt  |   55 +-
 Documentation/device-mapper/dm-io.txt         |   14 +-
 Documentation/device-mapper/dm-log.txt        |    5 +-
 .../device-mapper/dm-queue-length.txt         |   25 +-
 Documentation/device-mapper/dm-raid.txt       |  225 +-
 .../device-mapper/dm-service-time.txt         |   68 +-
 Documentation/device-mapper/dm-uevent.txt     |  143 +-
 Documentation/device-mapper/dm-zoned.txt      |   10 +-
 Documentation/device-mapper/era.txt           |   36 +-
 Documentation/device-mapper/kcopyd.txt        |   10 +-
 Documentation/device-mapper/linear.txt        |  100 +-
 Documentation/device-mapper/log-writes.txt    |   91 +-
 .../device-mapper/persistent-data.txt         |    4 +
 Documentation/device-mapper/snapshot.txt      |  116 +-
 Documentation/device-mapper/statistics.txt    |   62 +-
 Documentation/device-mapper/striped.txt       |   68 +-
 Documentation/device-mapper/switch.txt        |   47 +-
 .../device-mapper/thin-provisioning.txt       |   68 +-
 Documentation/device-mapper/unstriped.txt     |  111 +-
 Documentation/device-mapper/verity.txt        |   20 +-
 Documentation/device-mapper/writecache.txt    |   13 +-
 Documentation/device-mapper/zero.txt          |   14 +-
 Documentation/driver-model/binding.txt        |   20 +-
 Documentation/driver-model/bus.txt            |   69 +-
 Documentation/driver-model/class.txt          |   74 +-
 .../driver-model/design-patterns.txt          |  106 +-
 Documentation/driver-model/device.txt         |   57 +-
 Documentation/driver-model/devres.txt         |   50 +-
 Documentation/driver-model/driver.txt         |  112 +-
 Documentation/driver-model/overview.txt       |   37 +-
 Documentation/driver-model/platform.txt       |   30 +-
 Documentation/driver-model/porting.txt        |  333 +--
 Documentation/early-userspace/README          |    3 +
 .../early-userspace/buffer-format.txt         |   19 +-
 .../fault-injection/fault-injection.txt       |  265 +-
 .../fault-injection/notifier-error-inject.txt |   18 +-
 .../fault-injection/nvme-fault-injection.txt  |  174 +-
 .../fault-injection/provoke-crashes.txt       |   40 +-
 Documentation/fb/api.txt                      |   29 +-
 Documentation/fb/arkfb.txt                    |    8 +-
 Documentation/fb/aty128fb.txt                 |   31 +-
 Documentation/fb/cirrusfb.txt                 |   47 +-
 Documentation/fb/cmap_xfbdev.txt              |   57 +-
 Documentation/fb/deferred_io.txt              |   28 +-
 Documentation/fb/efifb.txt                    |   18 +-
 Documentation/fb/ep93xx-fb.txt                |   25 +-
 Documentation/fb/fbcon.txt                    |  177 +-
 Documentation/fb/framebuffer.txt              |   79 +-
 Documentation/fb/gxfb.txt                     |   22 +-
 Documentation/fb/intel810.txt                 |   77 +-
 Documentation/fb/intelfb.txt                  |   62 +-
 Documentation/fb/internals.txt                |   24 +-
 Documentation/fb/lxfb.txt                     |   23 +-
 Documentation/fb/matroxfb.txt                 |  526 ++--
 Documentation/fb/metronomefb.txt              |    8 +-
 Documentation/fb/modedb.txt                   |   44 +-
 Documentation/fb/pvr2fb.txt                   |   55 +-
 Documentation/fb/pxafb.txt                    |   81 +-
 Documentation/fb/s3fb.txt                     |    8 +-
 Documentation/fb/sa1100fb.txt                 |   23 +-
 Documentation/fb/sh7760fb.txt                 |  153 +-
 Documentation/fb/sisfb.txt                    |   40 +-
 Documentation/fb/sm501.txt                    |    7 +-
 Documentation/fb/sm712fb.txt                  |   18 +-
 Documentation/fb/sstfb.txt                    |  231 +-
 Documentation/fb/tgafb.txt                    |   30 +-
 Documentation/fb/tridentfb.txt                |   34 +-
 Documentation/fb/udlfb.txt                    |   55 +-
 Documentation/fb/uvesafb.txt                  |  128 +-
 Documentation/fb/vesafb.txt                   |  121 +-
 Documentation/fb/viafb.txt                    |  393 +--
 Documentation/fb/vt8623fb.txt                 |   10 +-
 Documentation/fpga/dfl.txt                    |   58 +-
 Documentation/gpio/sysfs.txt                  |   39 +-
 Documentation/highuid.txt                     |    2 +-
 Documentation/ide/ide-tape.txt                |   23 +-
 Documentation/ide/ide.txt                     |  147 +-
 Documentation/ide/warm-plug-howto.txt         |   10 +-
 Documentation/index.rst                       |    1 +
 Documentation/infiniband/core_locking.txt     |   64 +-
 Documentation/infiniband/ipoib.txt            |   24 +-
 Documentation/infiniband/opa_vnic.txt         |  108 +-
 Documentation/infiniband/sysfs.txt            |    4 +-
 Documentation/infiniband/tag_matching.txt     |    5 +
 Documentation/infiniband/user_mad.txt         |   33 +-
 Documentation/infiniband/user_verbs.txt       |   12 +-
 Documentation/kbuild/headers_install.txt      |    5 +-
 Documentation/kbuild/kbuild.txt               |  119 +-
 Documentation/kbuild/kconfig-language.txt     |  232 +-
 .../kbuild/kconfig-macro-language.txt         |   37 +-
 Documentation/kbuild/kconfig.txt              |  136 +-
 Documentation/kbuild/makefiles.txt            |  518 ++--
 Documentation/kbuild/modules.txt              |  166 +-
 Documentation/kdump/kdump.txt                 |  131 +-
 Documentation/kdump/vmcoreinfo.txt            |   59 +-
 Documentation/kobject.txt                     |    2 +-
 Documentation/ldm.txt                         |    3 +-
 Documentation/livepatch/callbacks.txt         |   12 +-
 .../livepatch/cumulative-patches.txt          |   14 +-
 Documentation/livepatch/livepatch.txt         |   56 +-
 Documentation/livepatch/module-elf-format.txt |  211 +-
 Documentation/livepatch/shadow-vars.txt       |   65 +-
 Documentation/locking/lockdep-design.txt      |   41 +-
 Documentation/locking/lockstat.txt            |  219 +-
 Documentation/locking/locktorture.txt         |  105 +-
 Documentation/locking/mutex-design.txt        |   26 +-
 Documentation/locking/rt-mutex-design.txt     |  135 +-
 Documentation/locking/rt-mutex.txt            |   30 +-
 Documentation/locking/spinlocks.txt           |   32 +-
 Documentation/locking/ww-mutex-design.txt     |   82 +-
 Documentation/m68k/kernel-options.txt         |  319 +-
 Documentation/memory-barriers.txt             |    2 +-
 Documentation/memory-devices/ti-emif.txt      |   25 +-
 Documentation/mic/mic_overview.txt            |    6 +-
 Documentation/mic/scif_overview.txt           |   58 +-
 Documentation/netlabel/cipso_ipv4.txt         |   19 +-
 Documentation/netlabel/introduction.txt       |   16 +-
 Documentation/netlabel/lsm_interface.txt      |   16 +-
 Documentation/numastat.txt                    |    1 -
 Documentation/nvmem/nvmem.txt                 |  110 +-
 Documentation/pcmcia/devicetable.txt          |    4 +
 Documentation/pcmcia/driver-changes.txt       |   35 +-
 Documentation/pcmcia/driver.txt               |   18 +-
 Documentation/pcmcia/locking.txt              |   39 +-
 Documentation/phy/samsung-usb2.txt            |   60 +-
 Documentation/pnp.txt                         |   11 +-
 Documentation/power/apm-acpi.txt              |   10 +-
 Documentation/power/basic-pm-debugging.txt    |   77 +-
 Documentation/power/charger-manager.txt       |  101 +-
 Documentation/power/drivers-testing.txt       |    5 +
 Documentation/power/energy-model.txt          |  101 +-
 Documentation/power/freezing-of-tasks.txt     |   91 +-
 Documentation/power/interface.txt             |   20 +-
 Documentation/power/opp.txt                   |  175 +-
 Documentation/power/pci.txt                   |   77 +-
 Documentation/power/pm_qos_interface.txt      |  127 +-
 Documentation/power/power_supply_class.txt    |  269 +-
 Documentation/power/powercap/powercap.txt     |  297 +-
 Documentation/power/regulator/consumer.txt    |  141 +-
 Documentation/power/regulator/design.txt      |    9 +-
 Documentation/power/regulator/machine.txt     |   47 +-
 Documentation/power/regulator/overview.txt    |   51 +-
 Documentation/power/regulator/regulator.txt   |   18 +-
 Documentation/power/runtime_pm.txt            |  234 +-
 Documentation/power/s2ram.txt                 |   20 +-
 .../power/suspend-and-cpuhotplug.txt          |   42 +-
 .../power/suspend-and-interrupts.txt          |    2 +
 Documentation/power/swsusp-and-swap-files.txt |   15 +-
 Documentation/power/swsusp-dmcrypt.txt        |  118 +-
 Documentation/power/swsusp.txt                |  639 ++--
 Documentation/power/tricks.txt                |    6 +-
 Documentation/power/userland-swsusp.txt       |   53 +-
 Documentation/power/video.txt                 |  156 +-
 Documentation/powerpc/DAWR-POWER9.txt         |   10 +-
 Documentation/powerpc/bootwrapper.txt         |   28 +-
 Documentation/powerpc/cpu_families.txt        |   23 +-
 Documentation/powerpc/cpu_features.txt        |    6 +-
 Documentation/powerpc/cxl.txt                 |   46 +-
 Documentation/powerpc/cxlflash.txt            |    8 +-
 Documentation/powerpc/dscr.txt                |   18 +-
 .../powerpc/eeh-pci-error-recovery.txt        |  108 +-
 .../powerpc/firmware-assisted-dump.txt        |  117 +-
 Documentation/powerpc/hvcs.txt                |  108 +-
 Documentation/powerpc/isa-versions.rst        |   13 +-
 Documentation/powerpc/mpc52xx.txt             |   12 +-
 .../powerpc/pci_iov_resource_on_powernv.txt   |   15 +-
 Documentation/powerpc/pmu-ebb.txt             |    1 +
 Documentation/powerpc/ptrace.txt              |  169 +-
 Documentation/powerpc/qe_firmware.txt         |   37 +-
 Documentation/powerpc/syscall64-abi.txt       |   29 +-
 .../powerpc/transactional_memory.txt          |   45 +-
 Documentation/pps/pps.txt                     |   67 +-
 Documentation/preempt-locking.txt             |    2 +-
 Documentation/pti/pti_intel_mid.txt           |  135 +-
 Documentation/ptp/ptp.txt                     |   26 +-
 Documentation/rbtree.txt                      |   52 +-
 Documentation/riscv/pmu.txt                   |   98 +-
 Documentation/rtc.txt                         |    6 +-
 Documentation/s390/3270.txt                   |   85 +-
 Documentation/s390/CommonIO                   |   47 +-
 Documentation/s390/DASD                       |   33 +-
 Documentation/s390/Debugging390.txt           | 2599 ++++++++++-------
 Documentation/s390/cds.txt                    |  354 ++-
 Documentation/s390/driver-model.txt           |  179 +-
 Documentation/s390/monreader.txt              |   85 +-
 Documentation/s390/qeth.txt                   |   36 +-
 Documentation/s390/s390dbf.txt                |  639 ++--
 Documentation/s390/vfio-ap.txt                |  487 +--
 Documentation/s390/vfio-ccw.txt               |   88 +-
 Documentation/s390/zfcpdump.txt               |    2 +
 Documentation/scheduler/completion.txt        |   38 +-
 Documentation/scheduler/sched-arch.txt        |   18 +-
 Documentation/scheduler/sched-bwc.txt         |   28 +-
 Documentation/scheduler/sched-deadline.txt    |  293 +-
 Documentation/scheduler/sched-design-CFS.txt  |   15 +-
 Documentation/scheduler/sched-domains.txt     |    8 +-
 Documentation/scheduler/sched-energy.txt      |   47 +-
 Documentation/scheduler/sched-nice-design.txt |    6 +-
 Documentation/scheduler/sched-rt-group.txt    |   28 +-
 Documentation/scheduler/sched-stats.txt       |   35 +-
 Documentation/security/tpm/xen-tpmfront.txt   |  101 +-
 Documentation/serial/README.cycladesZ         |    5 +-
 Documentation/serial/driver                   |  113 +-
 Documentation/serial/moxa-smartio             |  750 ++---
 Documentation/serial/n_gsm.txt                |   81 +-
 Documentation/serial/rocket.txt               |  144 +-
 Documentation/serial/serial-iso7816.txt       |   21 +-
 Documentation/serial/serial-rs485.txt         |   22 +-
 Documentation/serial/tty.txt                  |  111 +-
 Documentation/target/tcm_mod_builder.txt      |  200 +-
 Documentation/target/tcmu-design.txt          |  268 +-
 Documentation/timers/NO_HZ.txt                |   40 +-
 Documentation/timers/highres.txt              |   11 +-
 Documentation/timers/hpet.txt                 |    4 +-
 Documentation/timers/hrtimers.txt             |    6 +-
 Documentation/timers/timekeeping.txt          |    3 +-
 Documentation/timers/timers-howto.txt         |   15 +-
 Documentation/trace/ftrace.rst                |    1 +
 Documentation/trace/histogram.rst             |   86 +-
 Documentation/usb/WUSB-Design-overview.txt    |   56 +-
 Documentation/usb/acm.txt                     |  156 +-
 Documentation/usb/authorization.txt           |   75 +-
 Documentation/usb/chipidea.txt                |  101 +-
 Documentation/usb/dwc3.txt                    |   12 +-
 Documentation/usb/ehci.txt                    |   42 +-
 Documentation/usb/functionfs.txt              |   17 +-
 Documentation/usb/gadget-testing.txt          |  609 ++--
 Documentation/usb/gadget_configfs.txt         |  302 +-
 Documentation/usb/gadget_hid.txt              |  175 +-
 Documentation/usb/gadget_multi.txt            |   43 +-
 Documentation/usb/gadget_printer.txt          |  155 +-
 Documentation/usb/gadget_serial.txt           |   73 +-
 Documentation/usb/iuu_phoenix.txt             |   34 +-
 Documentation/usb/mass-storage.txt            |   19 +-
 Documentation/usb/misc_usbsevseg.txt          |    9 +-
 Documentation/usb/mtouchusb.txt               |   42 +-
 Documentation/usb/ohci.txt                    |    5 +-
 Documentation/usb/rio.txt                     |   83 +-
 Documentation/usb/usb-help.txt                |   21 +-
 Documentation/usb/usb-serial.txt              |  203 +-
 Documentation/usb/usbip_protocol.txt          |  552 ++--
 Documentation/usb/usbmon.txt                  |  100 +-
 .../convert_drivers_to_kernel_api.txt         |  109 +-
 Documentation/watchdog/hpwdt.txt              |   23 +-
 Documentation/watchdog/mlx-wdt.txt            |   24 +-
 Documentation/watchdog/pcwd-watchdog.txt      |   13 +-
 Documentation/watchdog/watchdog-api.txt       |   76 +-
 .../watchdog/watchdog-kernel-api.txt          |   89 +-
 .../watchdog/watchdog-parameters.txt          |  672 +++--
 Documentation/watchdog/watchdog-pm.txt        |    3 +
 Documentation/watchdog/wdt.txt                |   31 +-
 Documentation/x86/amd-memory-encryption.txt   |   10 +-
 Documentation/x86/boot.txt                    |  578 ++--
 Documentation/x86/earlyprintk.txt             |   69 +-
 Documentation/x86/entry_64.txt                |   11 +-
 Documentation/x86/exception-tables.txt        |  245 +-
 Documentation/x86/i386/IO-APIC.txt            |   23 +-
 Documentation/x86/intel_mpx.txt               |   55 +-
 Documentation/x86/microcode.txt               |   51 +-
 Documentation/x86/mtrr.txt                    |  442 +--
 Documentation/x86/orc-unwinder.txt            |    1 +
 Documentation/x86/pat.txt                     |  217 +-
 Documentation/x86/protection-keys.txt         |   33 +-
 Documentation/x86/pti.txt                     |    8 +-
 Documentation/x86/resctrl_ui.txt              |  621 ++--
 Documentation/x86/tlb.txt                     |   12 +-
 Documentation/x86/topology.txt                |   26 +-
 Documentation/x86/usb-legacy-support.txt      |   33 +-
 Documentation/x86/x86_64/5level-paging.txt    |   14 +-
 Documentation/x86/x86_64/boot-options.txt     |   98 +-
 Documentation/x86/x86_64/mm.txt               |  212 +-
 Documentation/x86/x86_64/uefi.txt             |   21 +-
 Documentation/x86/zero-page.txt               |   67 +-
 Documentation/xilinx/eemi.txt                 |    8 +-
 Documentation/zorro.txt                       |    5 +-
 MAINTAINERS                                   |    2 +-
 arch/arm64/kernel/kexec_image.c               |    2 +-
 arch/s390/include/asm/debug.h                 |  231 ++
 drivers/cdrom/cdrom.c                         |    2 +-
 include/linux/connector.h                     |   63 +-
 433 files changed, 21459 insertions(+), 16370 deletions(-)
 rename Documentation/{extcon/intel-int3496.txt => acpi/drivers/extcon-intel-int3496.txt} (66%)
 delete mode 100644 Documentation/arm/SA1100/empeg
 delete mode 100644 Documentation/cdrom/Makefile
 delete mode 100644 Documentation/cdrom/cdrom-standard.tex
 create mode 100644 Documentation/cdrom/cdrom-standard.txt

-- 
2.20.1
