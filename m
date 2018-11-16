Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-wm1-f54.google.com ([209.85.128.54]:35594 "EHLO
        mail-wm1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728684AbeKQC4j (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 16 Nov 2018 21:56:39 -0500
Received: by mail-wm1-f54.google.com with SMTP id t15-v6so21767504wmt.0
        for <xdp-newbies@vger.kernel.org>; Fri, 16 Nov 2018 08:43:31 -0800 (PST)
MIME-Version: 1.0
References: <92cbca4a5165be75b164271ce0f97992a16f9b39.camel@regit.org>
In-Reply-To: <92cbca4a5165be75b164271ce0f97992a16f9b39.camel@regit.org>
From: Justin Azoff <justin.azoff@gmail.com>
Date: Fri, 16 Nov 2018 10:43:18 -0600
Message-ID: <CAJL276BybGC9kWDRfM-AUWoCV0A2n-zxjQD7ptosXu=fvQ4_nQ@mail.gmail.com>
Subject: Re: Pinning map and libbpf
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: eric@regit.org
Cc: xdp-newbies@vger.kernel.org

This sounds similar to an issue I ran into when I was getting pinning
working for libflowbypass.  At one point I was pinning the map but not
loading it properly again on startup.  This caused a 2nd map with the
same name to be created.  This meant anything using the pinned map on
the bpf filesystem saw one set of values, but the app was running with
it's own private non-pinned map.

If you do a 'bpftool map list' when the app is stopped, you should see
your pinned map. If you start the app back up and 'bpftool map list'
now lists 2 maps, that would be your problem as well.  If nothing
else, 'bpftool map list' and 'bpftool map dump' may also help debug
this, since they should be able to confirm that the map is empty too.

On Thu, Nov 15, 2018 at 12:57 PM Eric Leblond <eric@regit.org> wrote:
>
> Hi,
>
> I've just added an libbpf bpf_pin_obj call to a working setup and this
> did cause bpf_map_lookup_elem() call to fail and return a value even if
> the set is empty.
>
> The maps structure is the following:
>
> struct bpf_map_def SEC("maps") ipv4_drop = {
>     .type = BPF_MAP_TYPE_HASH,
>     .key_size = sizeof(__u32),
>     .value_size = sizeof(__u32),
>     .max_entries = 32768,
> };
>
> Is there something I should change ?
>
> I'm using 4.18.
>
> BR,
> --
> Eric Leblond <eric@regit.org>
>


-- 
- Justin
