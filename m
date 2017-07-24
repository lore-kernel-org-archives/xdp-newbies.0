Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:38258 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752019AbdGXA1U (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Sun, 23 Jul 2017 20:27:20 -0400
Received: by mail-pf0-f193.google.com with SMTP id c23so9153180pfe.5
        for <xdp-newbies@vger.kernel.org>; Sun, 23 Jul 2017 17:27:20 -0700 (PDT)
Subject: Re: XDP/BPF C and python libraries?
References: <20170720225308.14e2ac14@cakuba.netronome.com>
 <5971D5D6.8010300@iogearbox.net>
 <20170721153743.31cd84a0@cakuba.netronome.com>
 <20170722002050.315717be@cakuba.netronome.com>
 <20170723165420.5916f2a2@cakuba.netronome.com>
From: David Ahern <dsahern@gmail.com>
Message-ID: <088e52d9-22ed-7926-189a-0bb14279dbf6@gmail.com>
Date: Sun, 23 Jul 2017 18:27:14 -0600
MIME-Version: 1.0
In-Reply-To: <20170723165420.5916f2a2@cakuba.netronome.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jakub Kicinski <kubakici@wp.pl>, Daniel Borkmann <daniel@iogearbox.net>
Cc: xdp-newbies@vger.kernel.org, ast@fb.com, Martin KaFai Lau <kafai@fb.com>, Hannes Frederic Sowa <hannes@redhat.com>

On 7/23/17 5:54 PM, Jakub Kicinski wrote:
> On Sat, 22 Jul 2017 00:20:50 -0700, Jakub Kicinski wrote:
>> One thing which is not clear to me is how to get the association
>> between programs and maps?  Would we need to extend
>> BPF_OBJ_GET_INFO_BY_FD to provide this info?
> 
> Another thing that I can't find a way of doing is telling whether BPF fs
> file is representing a map or a program.  Is there a way to do this
> today?
> 

Once you have the fd you should be able to look at /proc/pid/fd/%d

I have been using this:

static int bpf_get_type(__u32 fd, __u32 pid, enum bpf_type *type)
{
        char file[PATH_MAX];
        char buf[512];
        ssize_t n;

        *type = BPF_TYPE_UNSPEC;

        snprintf(file, sizeof(file), "/proc/%d/fd/%d", pid, fd);

        n = readlink(file, buf, sizeof(buf));
        if (n < 0)
                return -1;

        if (strstr(buf, "bpf-prog"))
                *type = BPF_TYPE_PROG;
        else if (strstr(buf, "bpf-map"))
                *type = BPF_TYPE_MAP;

        return 0;
}
