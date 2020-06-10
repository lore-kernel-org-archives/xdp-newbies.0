Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726219AbgFJJVh (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 10 Jun 2020 05:21:37 -0400
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B9DDC03E96B
        for <xdp-newbies@vger.kernel.org>; Wed, 10 Jun 2020 02:21:35 -0700 (PDT)
Received: by mail-vs1-xe29.google.com with SMTP id 190so802857vsr.9
        for <xdp-newbies@vger.kernel.org>; Wed, 10 Jun 2020 02:21:35 -0700 (PDT)
MIME-Version: 1.0
From: Elerion <elerion1000@gmail.com>
Date: Wed, 10 Jun 2020 02:21:23 -0700
Message-ID: <CAMDScm=VZJMZYN=SXo9OAshY=yYxwtavLDgTvu1qEasg77JyLw@mail.gmail.com>
Subject: How to load BTF style maps?
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
To: xdp-newbies@vger.kernel.org

I have maps written in the old style like this:

struct bpf_map_def SEC("maps") xdp_stats_map = {
.type        = BPF_MAP_TYPE_ARRAY,
.key_size    = sizeof(__u32),
.value_size  = sizeof(struct datarec),
.max_entries = XDP_ACTION_MAX,
};

I changed it to the new BTF style like this but now the example BPF
loader from the kernel doesn't work anymore.

struct {
    __uint(type, BPF_MAP_TYPE_ARRAY);
    __uint(max_entries,  XDP_ACTION_MAX);
    __type(key,  __u32);
    __type(value,  struct datarec);
}  xdp_stats_map SEC(".maps");

I used this to load my program
https://github.com/torvalds/linux/blob/master/samples/bpf/bpf_load.c

But now it fails to load. First thing I noticed was the I had to
change "maps" to ".maps"
https://github.com/torvalds/linux/blob/master/samples/bpf/bpf_load.c#L563

But then bpf_create_map_node fails because all the arguments are 0. I
dumped the buffer here
https://github.com/torvalds/linux/blob/master/samples/bpf/bpf_load.c#L489
and it just copies 28 bytes of zeroes for each map I have.

How do you load BTF style maps? bpf_load.c doesn't seem to work on them.
