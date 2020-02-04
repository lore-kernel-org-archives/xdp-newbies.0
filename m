Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32291 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726362AbgBDKUF (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Tue, 4 Feb 2020 05:20:05 -0500
Received: by mail-lj1-f200.google.com with SMTP id l14so5106733ljb.10
        for <xdp-newbies@vger.kernel.org>; Tue, 04 Feb 2020 02:19:59 -0800 (PST)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: Need a way to modify the section name for a read program object
In-Reply-To: <D0F8E306-ABEE-480E-BDFD-D43E3A98DC5A@redhat.com>
References: <D0F8E306-ABEE-480E-BDFD-D43E3A98DC5A@redhat.com>
Date: Tue, 04 Feb 2020 11:19:53 +0100
Message-ID: <874kw664dy.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Eelco Chaudron <echaudro@redhat.com>, xdp-newbies@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>

"Eelco Chaudron" <echaudro@redhat.com> writes:

> Hi All,
>
> I'm trying to write an xdpdump like utility and have some missing part 
> in libbpf to change the fentry/FUNCTION section name before loading the 
> trace program.
>
> In short, I have an eBPF program that has a section name like 
> "fentry/FUNCTION" where FUNCTION needs to be replaced by the name of the 
> XDP program loaded in the interfaces its start function.
>
> The code for loading the ftrace part is something like:
>
> 	open_opts.attach_prog_fd = bpf_prog_get_fd_by_id(info.id);
> 	trace_obj = bpf_object__open_file("xdpdump_bpf.o", &open_opts);
>
> 	trace_prog_fentry = bpf_object__find_program_by_title(trace_obj, 
> "fentry/FUNCTION");
>
> 	/* Here I need to replace the trace_prog_fentry->section_name = 
> "fentry/<INTERFACE PROG NAME> */
>
> 	bpf_object__load(trace_obj);
> 	trace_link_fentry = bpf_program__attach_trace(trace_prog_fentry);
>
>
> See the above, I would like to change the section_name but there is no 
> API to do this, and of course, the struct bpf_program is 
> implementation-specific.
>
> Any idea how I would work around this, or what extension to libbpf can 
> be suggested to support this?

I think what's missing is a way for the caller to set the attach_btf_id.
Currently, libbpf always tries to discover this based on the section
name (see libbpf_find_attach_btf_id()). I think the right way to let the
caller specify this is not to change the section name, though, but just
to expose a way to explicitly set the btf_id (which the caller can then
go find on its own).

Not sure if it would be better with a new open_opt (to mirror
attach_prog_fd), or just a setter (bpf_program__set_attach_btf_id()?).
Or maybe both? Andrii, WDYT?

-Toke
