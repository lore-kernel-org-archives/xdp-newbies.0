Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:59803 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753098AbeDPScp (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 16 Apr 2018 14:32:45 -0400
Date: Tue, 17 Apr 2018 02:31:51 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: dma-mapping: bypass dma_ops for direct mappings
Message-ID: <201804170018.5lF6docc%fengguang.wu@intel.com>
References: <20180416122706.GA20624@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="T4sUOijqQbZv57TR"
Content-Disposition: inline
In-Reply-To: <20180416122706.GA20624@infradead.org>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: kbuild-all@01.org, Jesper Dangaard Brouer <brouer@redhat.com>, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, David Woodhouse <dwmw2@infradead.org>, William Tu <u9012063@gmail.com>, =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>, "Karlsson, Magnus" <magnus.karlsson@intel.com>, Alexander Duyck <alexander.duyck@gmail.com>, Arnaldo Carvalho de Melo <acme@redhat.com>


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Christoph,

I love your patch! Perhaps something to improve:

[auto build test WARNING on linus/master]
[also build test WARNING on v4.17-rc1 next-20180416]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Christoph-Hellwig/dma-mapping-bypass-dma_ops-for-direct-mappings/20180416-230032
reproduce: make htmldocs

All warnings (new ones prefixed by >>):

   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   net/mac80211/sta_info.h:586: warning: Function parameter or member 'rx_stats_avg' not described in 'sta_info'
   net/mac80211/sta_info.h:586: warning: Function parameter or member 'rx_stats_avg.signal' not described in 'sta_info'
   net/mac80211/sta_info.h:586: warning: Function parameter or member 'rx_stats_avg.chain_signal' not described in 'sta_info'
   net/mac80211/sta_info.h:586: warning: Function parameter or member 'status_stats.filtered' not described in 'sta_info'
   net/mac80211/sta_info.h:586: warning: Function parameter or member 'status_stats.retry_failed' not described in 'sta_info'
   net/mac80211/sta_info.h:586: warning: Function parameter or member 'status_stats.retry_count' not described in 'sta_info'
   net/mac80211/sta_info.h:586: warning: Function parameter or member 'status_stats.lost_packets' not described in 'sta_info'
   net/mac80211/sta_info.h:586: warning: Function parameter or member 'status_stats.last_tdls_pkt_time' not described in 'sta_info'
   net/mac80211/sta_info.h:586: warning: Function parameter or member 'status_stats.msdu_retries' not described in 'sta_info'
   net/mac80211/sta_info.h:586: warning: Function parameter or member 'status_stats.msdu_failed' not described in 'sta_info'
   net/mac80211/sta_info.h:586: warning: Function parameter or member 'status_stats.last_ack' not described in 'sta_info'
   net/mac80211/sta_info.h:586: warning: Function parameter or member 'status_stats.last_ack_signal' not described in 'sta_info'
   net/mac80211/sta_info.h:586: warning: Function parameter or member 'status_stats.ack_signal_filled' not described in 'sta_info'
   net/mac80211/sta_info.h:586: warning: Function parameter or member 'tx_stats.packets' not described in 'sta_info'
   net/mac80211/sta_info.h:586: warning: Function parameter or member 'tx_stats.bytes' not described in 'sta_info'
   net/mac80211/sta_info.h:586: warning: Function parameter or member 'tx_stats.last_rate' not described in 'sta_info'
   net/mac80211/sta_info.h:586: warning: Function parameter or member 'tx_stats.msdu' not described in 'sta_info'
   kernel/sched/fair.c:3731: warning: Function parameter or member 'flags' not described in 'attach_entity_load_avg'
   include/linux/dma-buf.h:307: warning: Function parameter or member 'cb_excl.cb' not described in 'dma_buf'
   include/linux/dma-buf.h:307: warning: Function parameter or member 'cb_excl.poll' not described in 'dma_buf'
   include/linux/dma-buf.h:307: warning: Function parameter or member 'cb_excl.active' not described in 'dma_buf'
   include/linux/dma-buf.h:307: warning: Function parameter or member 'cb_shared.cb' not described in 'dma_buf'
   include/linux/dma-buf.h:307: warning: Function parameter or member 'cb_shared.poll' not described in 'dma_buf'
   include/linux/dma-buf.h:307: warning: Function parameter or member 'cb_shared.active' not described in 'dma_buf'
   include/linux/dma-fence-array.h:54: warning: Function parameter or member 'work' not described in 'dma_fence_array'
   Error: Cannot open file drivers/base/firmware_class.c
   WARNING: kernel-doc 'scripts/kernel-doc -rst -enable-lineno -function request_firmware drivers/base/firmware_class.c' failed with return code 1
   Error: Cannot open file drivers/base/firmware_class.c
   WARNING: kernel-doc 'scripts/kernel-doc -rst -enable-lineno -function request_firmware_direct drivers/base/firmware_class.c' failed with return code 1
   Error: Cannot open file drivers/base/firmware_class.c
   WARNING: kernel-doc 'scripts/kernel-doc -rst -enable-lineno -function request_firmware_into_buf drivers/base/firmware_class.c' failed with return code 1
   Error: Cannot open file drivers/base/firmware_class.c
   WARNING: kernel-doc 'scripts/kernel-doc -rst -enable-lineno -function request_firmware_nowait drivers/base/firmware_class.c' failed with return code 1
   Error: Cannot open file drivers/base/firmware_class.c
   WARNING: kernel-doc 'scripts/kernel-doc -rst -enable-lineno -function firmware_request_cache drivers/base/firmware_class.c' failed with return code 1
   include/linux/gpio/driver.h:142: warning: Function parameter or member 'request_key' not described in 'gpio_irq_chip'
   include/linux/iio/iio.h:270: warning: Function parameter or member 'scan_type.sign' not described in 'iio_chan_spec'
   include/linux/iio/iio.h:270: warning: Function parameter or member 'scan_type.realbits' not described in 'iio_chan_spec'
   include/linux/iio/iio.h:270: warning: Function parameter or member 'scan_type.storagebits' not described in 'iio_chan_spec'
   include/linux/iio/iio.h:270: warning: Function parameter or member 'scan_type.shift' not described in 'iio_chan_spec'
   include/linux/iio/iio.h:270: warning: Function parameter or member 'scan_type.repeat' not described in 'iio_chan_spec'
   include/linux/iio/iio.h:270: warning: Function parameter or member 'scan_type.endianness' not described in 'iio_chan_spec'
   include/linux/iio/hw-consumer.h:1: warning: no structured comments found
>> include/linux/device.h:995: warning: Function parameter or member 'is_dma_direct' not described in 'device'
   Error: Cannot open file drivers/base/firmware_class.c
   Error: Cannot open file drivers/base/firmware_class.c
   WARNING: kernel-doc 'scripts/kernel-doc -rst -enable-lineno -export drivers/base/firmware_class.c' failed with return code 2
   include/linux/input/sparse-keymap.h:46: warning: Function parameter or member 'sw' not described in 'key_entry'
   include/linux/mtd/rawnand.h:752: warning: Function parameter or member 'timings.sdr' not described in 'nand_data_interface'
   include/linux/mtd/rawnand.h:817: warning: Function parameter or member 'buf' not described in 'nand_op_data_instr'
   include/linux/mtd/rawnand.h:817: warning: Function parameter or member 'buf.in' not described in 'nand_op_data_instr'
   include/linux/mtd/rawnand.h:817: warning: Function parameter or member 'buf.out' not described in 'nand_op_data_instr'
   include/linux/mtd/rawnand.h:863: warning: Function parameter or member 'ctx' not described in 'nand_op_instr'
   include/linux/mtd/rawnand.h:863: warning: Function parameter or member 'ctx.cmd' not described in 'nand_op_instr'
   include/linux/mtd/rawnand.h:863: warning: Function parameter or member 'ctx.addr' not described in 'nand_op_instr'
   include/linux/mtd/rawnand.h:863: warning: Function parameter or member 'ctx.data' not described in 'nand_op_instr'
   include/linux/mtd/rawnand.h:863: warning: Function parameter or member 'ctx.waitrdy' not described in 'nand_op_instr'
   include/linux/mtd/rawnand.h:1010: warning: Function parameter or member 'ctx' not described in 'nand_op_parser_pattern_elem'
   include/linux/mtd/rawnand.h:1010: warning: Function parameter or member 'ctx.addr' not described in 'nand_op_parser_pattern_elem'
   include/linux/mtd/rawnand.h:1010: warning: Function parameter or member 'ctx.data' not described in 'nand_op_parser_pattern_elem'
   include/linux/mtd/rawnand.h:1313: warning: Function parameter or member 'manufacturer.desc' not described in 'nand_chip'
   include/linux/mtd/rawnand.h:1313: warning: Function parameter or member 'manufacturer.priv' not described in 'nand_chip'
   include/linux/regulator/driver.h:222: warning: Function parameter or member 'resume_early' not described in 'regulator_ops'
   drivers/regulator/core.c:4306: warning: Excess function parameter 'state' description in 'regulator_suspend_late'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.esw0' not described in 'irb'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.esw1' not described in 'irb'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.esw2' not described in 'irb'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.esw3' not described in 'irb'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.eadm' not described in 'irb'
   drivers/usb/typec/mux.c:186: warning: Function parameter or member 'mux' not described in 'typec_mux_unregister'
   drivers/usb/typec/mux.c:186: warning: Excess function parameter 'sw' description in 'typec_mux_unregister'

vim +995 include/linux/device.h

^1da177e Linus Torvalds 2005-04-16 @995  

:::::: The code at line 995 was first introduced by commit
:::::: 1da177e4c3f41524e886b7f1b8a0c1fc7321cac2 Linux-2.6.12-rc2

:::::: TO: Linus Torvalds <torvalds@ppc970.osdl.org>
:::::: CC: Linus Torvalds <torvalds@ppc970.osdl.org>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--T4sUOijqQbZv57TR
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--T4sUOijqQbZv57TR--
