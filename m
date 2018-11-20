Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-vs1-f51.google.com ([209.85.217.51]:39742 "EHLO
        mail-vs1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727346AbeKUBNA (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 20 Nov 2018 20:13:00 -0500
Received: by mail-vs1-f51.google.com with SMTP id h78so1198718vsi.6
        for <xdp-newbies@vger.kernel.org>; Tue, 20 Nov 2018 06:43:30 -0800 (PST)
MIME-Version: 1.0
From: Peter Parkanyi <peter@redsift.io>
Date: Tue, 20 Nov 2018 14:45:38 +0000
Message-ID: <CAG+T_tVFQwoNXw+=-RME+zMQzNij_Q8EUsBY6aXCguv8QovwgA@mail.gmail.com>
Subject: BPF probe namespacing
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org

Hi,

At LPC I raised the observation that currently it doesn't seem
feasible to insert a BPF probe from within a container that sees
events happening outside of the container, while it is possible to
insert a kernel module.

It was suggested that this is not the case, and things should just work.
I wanted to get a minimal reproduction of what I've seen in Docker
containers, so if somebody could take a look, I'd appreciate any
comments on the right way of doing this.

The kprobe in question:
https://github.com/redsift/ingraind/blob/master/bpf/file.c
BCC's libbpf does the attach:
https://github.com/iovisor/bcc/blob/master/src/cc/libbpf.c#L829

# Steps to reproduce
Build the bpf module & loader (generic binary targeting 4.16/x86_64 at
https://123-130035428-gh.circle-artifacts.com/0/ingraind ):
1. get a rust toolchain, musl-dev
2. git clone https://github.com/redsift/ingraind; cd ingraind;
KERNEL_SOURCE=<path to src> cargo +nightly build
--target=x86_64-unknown-linux-musl --release

## Run the BPF module without a sandbox
3. echo >config <<EOF
[[probe]]
pipelines = ["console"]
[probe.config]
type = "Files"
monitor_dirs = ["/"]not

[pipeline.console.config]
backend = "Console"
EOF
4. sudo ./target/x86_64-unknown-linux-musl/release/ingraind config
5. You can see that all VFS operations from the host are listed.
6. Kill the process C-c

### Expectation
I get system-wide filesystem events through the VFS

### Reality
Meets the expectation

## Run BPF module from chroot
1. mkdir -p test/proc test/sys; cp
/target/x86_64-unknown-linux-musl/release/ingraind config test
2. sudo mount -t sysfs sys test/sys; sudo mount -t debugfs none
test/sys/kernel/debug
3. sudo chroot ./test /ingraind /config

### Expectation
I see system-wide events, just like without chroot.

### Reality
I don't see events firing at all.

If you compile the code at
https://gist.github.com/rsdy/bfe45ebae7354217e7242c8bf10df274
statically and run it inside the chroot while ingraind is running
chrooted, the kprobe will fire both read and write events from within
the mount namespace.

Thanks,
Peter

-- 


Red Sift is the power behind OnDMARC

You can find us at 20 Air Street, 
4th Floor at Wayra, London, W1B 5AN




Red Sift is a limited company 
registered in England and Wales. Registered number: 09240956. Registered 
office: Kemp House, 152 City Road, London, EC1V 2NX.
