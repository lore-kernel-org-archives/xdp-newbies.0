Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qk0-f169.google.com ([209.85.220.169]:43447 "EHLO
        mail-qk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727144AbeHWWcU (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 23 Aug 2018 18:32:20 -0400
Received: by mail-qk0-f169.google.com with SMTP id 130-v6so4321550qkd.10
        for <xdp-newbies@vger.kernel.org>; Thu, 23 Aug 2018 12:01:17 -0700 (PDT)
Date: Thu, 23 Aug 2018 21:01:11 +0200
From: Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: Re: libbpf and persistent maps
Message-ID: <20180823210111.5238ad38@cakuba.netronome.com>
In-Reply-To: <CAJL276BB6OudtAxQdSq_4c-cFCQ1JpKFAwJvjs0SK_fdksT8bA@mail.gmail.com>
References: <CAJL276BB6OudtAxQdSq_4c-cFCQ1JpKFAwJvjs0SK_fdksT8bA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Justin Azoff <justin.azoff@gmail.com>
Cc: xdp-newbies@vger.kernel.org

On Tue, 21 Aug 2018 15:55:20 -0400, Justin Azoff wrote:
> Hi!
> 
> I'm working on a library to try to encapsulate some of the things that
> Eric Leblond did for suricata so that arbitrary tools can drop flows
> inside bpf.
> 
> Is anyone else working with persistent maps and libbpf?
> 
> I started with the examples from the prototype-kernel repository and
> have updated some of the bits to use libbpf and bpf_prog_load instead
> of the (older?) code in bpf_load.c
> 
> I tried using bpf_prog_load+bpf_object__pin to make persistent maps,
> but noticed it is missing some functionality that is present in
> bpf_load.c
> 
> The load_maps function in bpf_load.c supports the fixup_map callback
> that it uses like so:
> 
>     for (i = 0; i < nr_maps; i++) {
>         if (fixup_map) {
>             fixup_map(&maps[i], i);
>             /* Allow userspace to assign map FD prior to creation */
>             if (maps[i].fd != -1) {
>                 map_fd[i] = maps[i].fd;
>                 continue;
>             }
>         }
> 
> This is used by pre_load_maps_via_fs in xdp_ddos01_blacklist_user.c
> 
> With libbpf there doesn't appear to be a way to skip creating maps
> when loading an object if a pinned version of that map already exists.
> You currently end up with duplicate maps.
> 
> I would like to add this functionality to libbpf.  I see two ways of doing this:
> 
> * Adding a callback param to bpf_prog_load_attr similar to bpf_load
> * Adding a char *persistent_path param to bpf_prog_load_attr
> 
> The persistent_path would be used inside bpf_object__create_maps in
> the same way that bpf_object__pin uses it so that a map can loaded if
> it already exists or otherwise created and (maybe?) automatically
> pinned in one operation.
> 
> If a 'persistent' flag could be added to bpf_map_def that could also
> be useful, but I'm not sure if that structure is something that can be
> easily changed.

Could bpf_map__reuse_fd() be of any help?  (Present in Linus's tree for
now, will be there in upcoming -rc1.)  You'll need to
bpf_object__open() and bpf_object__load() separately, and set the FDs
between the two.
