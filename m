Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-wr1-f48.google.com ([209.85.221.48]:40796 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726628AbeHUXRF (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 21 Aug 2018 19:17:05 -0400
Received: by mail-wr1-f48.google.com with SMTP id n2-v6so6377380wrw.7
        for <xdp-newbies@vger.kernel.org>; Tue, 21 Aug 2018 12:55:33 -0700 (PDT)
MIME-Version: 1.0
From: Justin Azoff <justin.azoff@gmail.com>
Date: Tue, 21 Aug 2018 15:55:20 -0400
Message-ID: <CAJL276BB6OudtAxQdSq_4c-cFCQ1JpKFAwJvjs0SK_fdksT8bA@mail.gmail.com>
Subject: libbpf and persistent maps
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org

Hi!

I'm working on a library to try to encapsulate some of the things that
Eric Leblond did for suricata so that arbitrary tools can drop flows
inside bpf.

Is anyone else working with persistent maps and libbpf?

I started with the examples from the prototype-kernel repository and
have updated some of the bits to use libbpf and bpf_prog_load instead
of the (older?) code in bpf_load.c

I tried using bpf_prog_load+bpf_object__pin to make persistent maps,
but noticed it is missing some functionality that is present in
bpf_load.c

The load_maps function in bpf_load.c supports the fixup_map callback
that it uses like so:

    for (i = 0; i < nr_maps; i++) {
        if (fixup_map) {
            fixup_map(&maps[i], i);
            /* Allow userspace to assign map FD prior to creation */
            if (maps[i].fd != -1) {
                map_fd[i] = maps[i].fd;
                continue;
            }
        }

This is used by pre_load_maps_via_fs in xdp_ddos01_blacklist_user.c

With libbpf there doesn't appear to be a way to skip creating maps
when loading an object if a pinned version of that map already exists.
You currently end up with duplicate maps.

I would like to add this functionality to libbpf.  I see two ways of doing this:

* Adding a callback param to bpf_prog_load_attr similar to bpf_load
* Adding a char *persistent_path param to bpf_prog_load_attr

The persistent_path would be used inside bpf_object__create_maps in
the same way that bpf_object__pin uses it so that a map can loaded if
it already exists or otherwise created and (maybe?) automatically
pinned in one operation.

If a 'persistent' flag could be added to bpf_map_def that could also
be useful, but I'm not sure if that structure is something that can be
easily changed.

-- 
- Justin
