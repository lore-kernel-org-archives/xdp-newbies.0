Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-d.ads.isi.edu ([128.9.180.199]:41361 "EHLO
        mail-d.ads.isi.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726559AbgAQRFv (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 17 Jan 2020 12:05:51 -0500
Date: Fri, 17 Jan 2020 12:05:48 -0500
From: Ryan Goodfellow <rgoodfel@isi.edu>
Subject: Re: zero-copy between interfaces
Message-ID: <20200117170547.GA69024@smtp.ads.isi.edu>
References: <CAJ8uoz1FcfDYa1PaQuY-Yk+keEX5FT6+q2H2eLTce6DxcQjuiA@mail.gmail.com>
 <20200113151159.GB68570@smtp.ads.isi.edu>
 <CAJ8uoz1Ax5CAfO4wfo0Pj+jieeRN+gj0s2LpeeJ53uTorFP0ng@mail.gmail.com>
 <20200114205250.GA85903@smtp.ads.isi.edu>
 <20200115014137.GA105434@smtp.ads.isi.edu>
 <CAJ8uoz2VTXAT9ryF9Ls2JjacEw0Bc23t9w2jDEoMdA0dRc6Aaw@mail.gmail.com>
 <CAJ8uoz1Nf+Fsg40tfdnMenFiCjRBJN9maY9rVo--trt+Uwkqwg@mail.gmail.com>
 <20200116020414.GA46831@smtp.ads.isi.edu>
 <CAJ8uoz2WqQMVVu8F9JPBc2-Z=yvkg_9LH6cycxtYvJhJ4ytWJQ@mail.gmail.com>
 <CAJ8uoz3k1y9DeqQPf16BYL2HrrOUkpjEMmgUuVZX4nxAspJ4AA@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAJ8uoz3k1y9DeqQPf16BYL2HrrOUkpjEMmgUuVZX4nxAspJ4AA@mail.gmail.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
To: Magnus Karlsson <magnus.karlsson@gmail.com>
Cc: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>

On Fri, Jan 17, 2020 at 10:45:33AM +0100, Magnus Karlsson wrote:
> If have now run your application, but unfortunately I cannot recreate
> your problem. It works and runs for several minutes until I get bored
> and terminate it. Note that I use an i40e card that you get a crash
> with. So two problems I cannot reproduce, sigh. Here is my system
> info. Can you please dump yours? Please do the ethtool dump on your
> i40e card.
>=20
> mkarlsso@kurt:~/src/dna-linux$ sudo ethtool -i ens803f0
> [sudo] password for mkarlsso:
> driver: i40e
> version: 2.8.20-k
> firmware-version: 5.05 0x800028a6 1.1568.0
> expansion-rom-version:
> bus-info: 0000:86:00.0
> supports-statistics: yes
> supports-test: yes
> supports-eeprom-access: yes
> supports-register-dump: yes
> supports-priv-flags: yes
>=20
> mkarlsso@kurt:~/src/dna-linux$ uname -a
> Linux kurt 5.5.0-rc4+ #72 SMP PREEMPT Thu Jan 16 10:03:20 CET 2020
> x86_64 x86_64 x86_64 GNU/Linux
>=20
> mkarlsso@kurt:~/src/dna-linux$ git log -1
> commit b65053cd94f46619b4aae746b98f2d8d9274540e (HEAD, bpf-next/master)
> Author: Andrii Nakryiko <andriin@fb.com>
> Date:   Wed Jan 15 16:55:49 2020 -0800
>=20
>     selftests/bpf: Add whitelist/blacklist of test names to test_progs
>=20
> gcc version 9.2.1 20191008 (Ubuntu 9.2.1-9ubuntu2)
>=20
> I also noted that you use MAX_SOCKS in your XDP program. The size of
> the xsks_map is not dependent on the number of sockets in your case.
> It is dependent on the queue id you use. So I would introduce a
> MAX_QUEUE_ID and set it to e.g. 128 and use that instead. MAX_SOCKS is
> 4, so quite restrictive.
>=20
> /Magnus

So I plugged in my X710-DA4 card, and this one actually works fine. Here is=
 the
requested output for that card.

ry@turbine:~$ sudo ethtool -i enp101s0f0
driver: i40e
version: 2.8.20-k
firmware-version: 7.10 0x80006471 1.2527.0
expansion-rom-version:
bus-info: 0000:65:00.0
supports-statistics: yes
supports-test: yes
supports-eeprom-access: yes
supports-register-dump: yes
supports-priv-flags: yes

ry@turbine:~$ sudo lspci -vvv | grep 710
65:00.0 Ethernet controller: Intel Corporation Ethernet Controller X710 for=
 10GbE SFP+ (rev 01)
=09Subsystem: Intel Corporation Ethernet Converged Network Adapter X710-4
=09=09Product Name: XL710 40GbE Controller
65:00.1 Ethernet controller: Intel Corporation Ethernet Controller X710 for=
 10GbE SFP+ (rev 01)
=09Subsystem: Intel Corporation Ethernet Converged Network Adapter X710
=09=09Product Name: XL710 40GbE Controller
65:00.2 Ethernet controller: Intel Corporation Ethernet Controller X710 for=
 10GbE SFP+ (rev 01)
=09Subsystem: Intel Corporation Ethernet Converged Network Adapter X710
=09=09Product Name: XL710 40GbE Controller
65:00.3 Ethernet controller: Intel Corporation Ethernet Controller X710 for=
 10GbE SFP+ (rev 01)
=09Subsystem: Intel Corporation Ethernet Converged Network Adapter X710
=09=09Product Name: XL710 40GbE Controller

Here is the output for the X722 card. As of a few weeks ago firmware versio=
n
3.33 was the latest I could find.

ry@turbine:~$ sudo ethtool -i eno7
driver: i40e
version: 2.8.20-k
firmware-version: 3.33 0x80001006 1.1747.0
expansion-rom-version:
bus-info: 0000:b7:00.2
supports-statistics: yes
supports-test: yes
supports-eeprom-access: yes
supports-register-dump: yes
supports-priv-flags: yes

ry@turbine:~$ sudo lspci -vvv | grep 722
b7:00.0 Ethernet controller: Intel Corporation Ethernet Connection X722 for=
 10GBASE-T (rev 04)
=09DeviceName: Intel LAN X722 #1
=09Subsystem: Super Micro Computer Inc Ethernet Connection X722 for 10GBASE=
-T
b7:00.1 Ethernet controller: Intel Corporation Ethernet Connection X722 for=
 10GBASE-T (rev 04)
=09DeviceName: Intel LAN X722 #2
=09Subsystem: Super Micro Computer Inc Ethernet Connection X722 for 10GBASE=
-T
b7:00.2 Ethernet controller: Intel Corporation Ethernet Connection X722 for=
 10GbE SFP+ (rev 04)
=09DeviceName: Intel LAN X722 #3
=09Subsystem: Super Micro Computer Inc Ethernet Connection X722 for 10GbE S=
FP+
b7:00.3 Ethernet controller: Intel Corporation Ethernet Connection X722 for=
 10GbE SFP+ (rev 04)
=09DeviceName: Intel LAN X722 #4
=09Subsystem: Super Micro Computer Inc Ethernet Connection X722 for 10GbE S=
FP+

I verified that the driver still crashes with the current kernel/program I =
am
runing that works on the X710-DA4.

Other output as requested

ry@turbine:~$ uname -a
Linux turbine 5.5.0-rc4-moa+ #16 SMP Fri Jan 17 10:52:42 EST 2020 x86_64 GN=
U/Linux

ry@turbine:~/kmoa/bpf-next$ git log -2
commit 60d71397d27e7859fdaaaaab6594e4d977ae46e2 (HEAD -> master)
Author: Ryan Goodfellow <rgoodfel@isi.edu>
Date:   Wed Jan 15 16:54:39 2020 -0500

    add xdpsock_multidev sample program

    This is a simple program that uses AF_XDP sockets to forward packets
    between two interfaces using a common memory region and no copying of
    packets.

    Signed-off-by: Ryan Goodfellow <rgoodfel@isi.edu>

commit 9173cac3b64e6785dd604f5075e6035b045a0026 (origin/master, origin/HEAD=
)
Author: Andrii Nakryiko <andriin@fb.com>
Date:   Wed Jan 15 11:08:56 2020 -0800

    libbpf: Support .text sub-calls relocations

    The LLVM patch https://reviews.llvm.org/D72197 makes LLVM emit function=
 call
    relocations within the same section. This includes a default .text sect=
ion,
    which contains any BPF sub-programs. This wasn't the case before and so=
 libbpf
    was able to get a way with slightly simpler handling of subprogram call
    relocations.

    This patch adds support for .text section relocations. It needs to ensu=
re
    correct order of relocations, so does two passes:
    - first, relocate .text instructions, if there are any relocations in i=
t;
    - then process all the other programs and copy over patched .text instr=
uctions
    for all sub-program calls.

    v1->v2:
    - break early once .text program is processed.

    Signed-off-by: Andrii Nakryiko <andriin@fb.com>
    Signed-off-by: Alexei Starovoitov <ast@kernel.org>
    Acked-by: Yonghong Song <yhs@fb.com>
    Cc: Alexei Starovoitov <ast@kernel.org>
    Link: https://lore.kernel.org/bpf/20200115190856.2391325-1-andriin@fb.c=
om

Here is the info for the Mellanox card that is not working after the df0ae6=
f
commit.

ry@turbine:~$ sudo ethtool -i enp23s0f0
driver: mlx5_core
version: 5.0-0
firmware-version: 12.23.1020 (MT_2150110033)
expansion-rom-version:=20
bus-info: 0000:17:00.0
supports-statistics: yes
supports-test: yes
supports-eeprom-access: no
supports-register-dump: no
supports-priv-flags: yes

ry@turbine:~$ sudo lspci -vvv | grep Mellanox
17:00.0 Ethernet controller: Mellanox Technologies MT27700 Family [ConnectX=
-4]
        Subsystem: Mellanox Technologies ConnectX-4 Stand-up dual-port 100G=
bE MCX416A-CCAT
17:00.1 Ethernet controller: Mellanox Technologies MT27700 Family [ConnectX=
-4]
        Subsystem: Mellanox Technologies ConnectX-4 Stand-up dual-port 100G=
bE MCX416A-CCAT

--=20
~ ry
