Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:36086 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751638AbdF1WlO (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 28 Jun 2017 18:41:14 -0400
Received: by mail-pf0-f193.google.com with SMTP id z6so10610469pfk.3
        for <xdp-newbies@vger.kernel.org>; Wed, 28 Jun 2017 15:41:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <59537132.2080603@iogearbox.net>
References: <CAM7NYTh=TMc6uC_4dG=w5yAHMppLSgTgfgTY0Jzr-ipgs9SN-w@mail.gmail.com>
 <CAH3MdRX-wYpskfsjxv-jyM_zia+Va0nTv3FKGPZpnHZ6YnacsQ@mail.gmail.com>
 <CAM7NYTi=j4ZiPEk4c9CH9GqqLgynyLRsjdPgVd=TPM3QCUb_yw@mail.gmail.com> <59537132.2080603@iogearbox.net>
From: "MD I. Islam" <tamim@csebuet.org>
Date: Wed, 28 Jun 2017 18:40:53 -0400
Message-ID: <CAM7NYTjQFHSH8ytBLn-_7W_d=H166Ox-i+yXKg_hBj0Q=fSo1Q@mail.gmail.com>
Subject: Re: Cannot load eBPF program as XDP
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Daniel Borkmann <daniel@iogearbox.net>
Cc: Y Song <ys114321@gmail.com>, xdp-newbies@vger.kernel.org

Hi Daniel

On Wed, Jun 28, 2017 at 5:04 AM, Daniel Borkmann <daniel@iogearbox.net> wrote:
> On 06/28/2017 04:32 AM, MD I. Islam wrote:
>>
>> On Tue, Jun 27, 2017 at 10:05 PM, Y Song <ys114321@gmail.com> wrote:
>>>
>>> xdp meta data is different:
>>>
>>> struct xdp_md {
>>>          __u32 data;
>>>          __u32 data_end;
>>> };
>>>
>>> All other fields available for skb metadata won't be available in XDP.
>>> That is way
>>> you get verification failure.
>>
>>
>> Thanks for the quick reply! Now I'm trying xdp1_kern.c which uses
>> xdp_md. Now I'm getting the error:
>>
>> Note: 8 bytes struct bpf_elf_map fixup performed due to size mismatch!
>
>
> This one is harmless, just telling you that the native bpf_elf_map
> from iproute2 is different than the one you're loading, so it fixes
> up the remaining 8 bytes automatically.
>
>> RTNETLINK answers: Operation not supported
>
>
> This one seems likely that the driver you're trying to attach this to
> does not have XDP support. What's the driver you're using?

Yes, I was using RTL8111 driver which doesn't support XDP. I will
eventually use Netronome NIC which will hopefully work.

I'm facing the same problem in Mininet. Is there a way to use XDP in
Mininet? I am using Linux router in Mininet and I want to attach XDP
programs to virtual interfaces.

>
>
>> Could you please advise me what is wrong here?
>>
>>> On Tue, Jun 27, 2017 at 7:00 PM, MD I. Islam <tamim@csebuet.org> wrote:
>>>>
>>>> Hi
>>>>
>>>> I'm using
>>>> http://lingrok.org/xref/linux-net-next/samples/bpf/parse_simple.c.
>>>>
>>>> I can load the program as tc_cls using following commands:
>>>>
>>>> sudo tc qdisc add dev eno1 clsact
>>>> sudo tc filter add dev eno1  ingress bpf da obj parse_simple.o sec
>>>> simple
>>>>
>>>> But I get error when I load the same program in XDP:
>>>>
>>>> sudo ip link set dev eno1 xdp obj parse_simple.o section simple
>>>>
>>>> Prog section 'simple' rejected: Permission denied (13)!
>>>>   - Type:         6
>>>>   - Instructions: 23 (0 over limit)
>>>>   - License:      GPL
>>>>
>>>> Verifier analysis:
>>>>
>>>> 0: (b7) r0 = 0
>>>> 1: (61) r2 = *(u32 *)(r1 +80)
>>>> invalid bpf_context access off=80 size=4
>>>>
>>>> Error fetching program/map!
>>>>
>>>> I made sure that the parse_simple.o have necessary permission. Could
>>>> you please advise what is wrong here? I'm using Kernel 4.11+. Does XDP
>>>> need any specific kernel configuration enabled? clang and LLVM
>>>> versions are as following:
>>>>
>>>> clang --version
>>>> clang version 3.8.0-2ubuntu4 (tags/RELEASE_380/final)
>>>> Target: x86_64-pc-linux-gnu
>>>>
>>>> llc --version
>>>> LLVM (http://llvm.org/):
>>>>    LLVM version 3.8.0
>>>>
>>>>    Optimized build.
>>>>    Built Jul  9 2016 (11:22:59).
>>>>    Default target: x86_64-pc-linux-gnu
>>>>    Host CPU: haswell
>>>>
>>>>    Registered Targets:
>>>>      aarch64    - AArch64 (little endian)
>>>>      aarch64_be - AArch64 (big endian)
>>>>      amdgcn     - AMD GCN GPUs
>>>>      arm        - ARM
>>>>      arm64      - ARM64 (little endian)
>>>>      armeb      - ARM (big endian)
>>>>      bpf        - BPF (host endian)
>>>>      bpfeb      - BPF (big endian)
>>>>      bpfel      - BPF (little endian)
>>>>      cpp        - C++ backend
>>>>      hexagon    - Hexagon
>>>>      mips       - Mips
>>>>      mips64     - Mips64 [experimental]
>>>>      mips64el   - Mips64el [experimental]
>>>>      mipsel     - Mipsel
>>>>      msp430     - MSP430 [experimental]
>>>>      nvptx      - NVIDIA PTX 32-bit
>>>>      nvptx64    - NVIDIA PTX 64-bit
>>>>      ppc32      - PowerPC 32
>>>>      ppc64      - PowerPC 64
>>>>      ppc64le    - PowerPC 64 LE
>>>>      r600       - AMD GPUs HD2XXX-HD6XXX
>>>>      sparc      - Sparc
>>>>      sparcel    - Sparc LE
>>>>      sparcv9    - Sparc V9
>>>>      systemz    - SystemZ
>>>>      thumb      - Thumb
>>>>      thumbeb    - Thumb (big endian)
>>>>      x86        - 32-bit X86: Pentium-Pro and above
>>>>      x86-64     - 64-bit X86: EM64T and AMD64
>>>>      xcore      - XCore
>>>>
>>>> Many thanks
>>>> Tamim
>>
>>
>> Thanks
>> Tamim
>>
>
