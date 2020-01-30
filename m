Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:38831 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727193AbgA3Pcm (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 30 Jan 2020 10:32:42 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6A3AD1922960
        for <xdp-newbies@vger.kernel.org>; Thu, 30 Jan 2020 15:32:23 +0000 (UTC)
Received: from [10.36.116.53] (ovpn-116-53.ams2.redhat.com [10.36.116.53])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E4FA6859DA
        for <xdp-newbies@vger.kernel.org>; Thu, 30 Jan 2020 15:32:22 +0000 (UTC)
From: "Eelco Chaudron" <echaudro@redhat.com>
Subject: Need a way to modify the section name for a read program object
Date: Thu, 30 Jan 2020 16:32:20 +0100
Message-ID: <D0F8E306-ABEE-480E-BDFD-D43E3A98DC5A@redhat.com>
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; format=flowed; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
To: xdp-newbies@vger.kernel.org

Hi All,

I'm trying to write an xdpdump like utility and have some missing part=20
in libbpf to change the fentry/FUNCTION section name before loading the=20
trace program.

In short, I have an eBPF program that has a section name like=20
"fentry/FUNCTION" where FUNCTION needs to be replaced by the name of the=20
XDP program loaded in the interfaces its start function.

The code for loading the ftrace part is something like:

=09open_opts.attach_prog_fd =3D bpf_prog_get_fd_by_id(info.id);
=09trace_obj =3D bpf_object__open_file("xdpdump_bpf.o", &open_opts);

=09trace_prog_fentry =3D bpf_object__find_program_by_title(trace_obj,=20
"fentry/FUNCTION");

=09/* Here I need to replace the trace_prog_fentry->section_name =3D=20
"fentry/<INTERFACE PROG NAME> */

=09bpf_object__load(trace_obj);
=09trace_link_fentry =3D bpf_program__attach_trace(trace_prog_fentry);


See the above, I would like to change the section_name but there is no=20
API to do this, and of course, the struct bpf_program is=20
implementation-specific.

Any idea how I would work around this, or what extension to libbpf can=20
be suggested to support this?

Cheers,

Eelco
