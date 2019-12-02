Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:28133 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727418AbfLBQe0 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 2 Dec 2019 11:34:26 -0500
From: "Eelco Chaudron" <echaudro@redhat.com>
Subject: Re: Trying the bpf trace a bpf xdp program
Date: Mon, 02 Dec 2019 17:34:16 +0100
Message-ID: <056E9F5E-4FDD-4636-A43A-EC98A06E84D3@redhat.com>
In-Reply-To: <d588c894-a4e0-8b99-72a9-4429b27091df@fb.com>
References: <E53E0693-1C3A-4B47-B205-DC8E5DAF3619@redhat.com>
 <CAADnVQKkLtG-QCZwxx-Bpz8-goh-_mSTtUSzpb_oTv9a-qLizg@mail.gmail.com>
 <3AC9D2B7-9D2F-4286-80A2-1721B51B62CF@redhat.com>
 <CAADnVQJKSnoMVpQ3F86zBhFyo8WQ0vi65Z4QDtopLRrpK4yB8Q@mail.gmail.com>
 <4BBF99E4-9554-44F7-8505-D4B8416554C4@redhat.com>
 <d588c894-a4e0-8b99-72a9-4429b27091df@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: Yonghong Song <yhs@fb.com>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>, Xdp <xdp-newbies@vger.kernel.org>, bpf <bpf@vger.kernel.org>



On 29 Nov 2019, at 17:52, Yonghong Song wrote:

> On 11/29/19 8:30 AM, Eelco Chaudron wrote:
>>
>>
>> On 28 Nov 2019, at 20:47, Alexei Starovoitov wrote:
>>
>>> On Thu, Nov 28, 2019 at 11:16 AM Eelco Chaudron 
>>> <echaudro@redhat.com>
>>> wrote:
>>>>
>>>>
>>>>
>>>> On 28 Nov 2019, at 19:18, Alexei Starovoitov wrote:
>>>>
>>>>> On Thu, Nov 28, 2019 at 9:20 AM Eelco Chaudron 
>>>>> <echaudro@redhat.com>
>>>>> wrote:
>>>>>>
>>>>>> Trying out the BPF trace to trace a BPF program, but I’m 
>>>>>> already
>>>>>> getting stuck loading the object with the fexit  :(
>>>>>
>>>>> I can take a look after holidays.
>>>>
>>>> Enjoy the Holidays!! I figured out my auto kernel install script 
>>>> failed
>>>> whiteout me noticing, and I was running an old kernel :(
>>>>
>>>> I will try tomorrow with the correct kernel…
>>>
>>> Please also check that you have the latest llvm and pahole.
>>> pahole version should be >= 1.13.
>>> clang ideally from master.
>>> If all that is working then downgrade one by one and bisect whether
>>> the bug is.
>>>
>>
>> I tried it with the latest kernel loaded but still I got some errors 
>> on
>> bpf_object__load_xattr():
>>
>> $ sudo ./xdp_sample_fentry_fexit_user
>> libbpf: Cannot find bpf_func_info for main program sec
>> fexit/xdp_prog_simple. Ignore all bpf_func_info.
>> libbpf: load bpf program failed: Operation not permitted
>> libbpf: failed to load program 'fexit/xdp_prog_simple'
>> libbpf: failed to load object './xdp_sample_fentry_fexit_kern.o'
>> ERROR: Failed to load object file: Operation not permitted
>>
>>
>> With strace:
>>
>> [vagrant@xdp-tutorial tracing05-xdp-fentry]$ sudo
>> /home/vagrant/strace/strace -e bpf ./xdp_sample_fentry_fexit_user
>> bpf(BPF_PROG_GET_FD_BY_ID, {prog_id=36, next_id=0, open_flags=0}, 
>> 120) = 3
>> bpf(BPF_PROG_LOAD, {prog_type=BPF_PROG_TYPE_SOCKET_FILTER, 
>> insn_cnt=2,
>> insns=0x7ffcaedfd4f0, license="GPL", log_level=0, log_size=0,
>> log_buf=NULL, kern_version=KERNEL_VERSION(0, 0, 0), prog_flags=0,
>> prog_name="", prog_ifindex=0,
>> expected_attach_type=BPF_CGROUP_INET_INGRESS, prog_btf_fd=0,
>> func_info_rec_size=0, func_info=NULL, func_info_cnt=0,
>> line_info_rec_size=0, line_info=NULL, line_info_cnt=0}, 120) = 5
>> bpf(BPF_PROG_LOAD, {prog_type=BPF_PROG_TYPE_SOCKET_FILTER, 
>> insn_cnt=2,
>> insns=0x7ffcaedfd4f0, license="GPL", log_level=0, log_size=0,
>> log_buf=NULL, kern_version=KERNEL_VERSION(0, 0, 0), prog_flags=0,
>> prog_name="test", prog_ifindex=0,
>> expected_attach_type=BPF_CGROUP_INET_INGRESS, prog_btf_fd=0,
>> func_info_rec_size=0, func_info=NULL, func_info_cnt=0,
>> line_info_rec_size=0, line_info=NULL, line_info_cnt=0}, 120) = 5
>> bpf(BPF_MAP_CREATE, {map_type=BPF_MAP_TYPE_ARRAY, key_size=4,
>> value_size=32, max_entries=1, map_flags=0, inner_map_fd=0, 
>> map_name="",
>> map_ifindex=0, btf_fd=0, btf_key_type_id=0, btf_value_type_id=0}, 
>> 120) = 5
>> bpf(BPF_PROG_LOAD, {prog_type=BPF_PROG_TYPE_SOCKET_FILTER, 
>> insn_cnt=5,
>> insns=0x7ffcaedfd490, license="GPL", log_level=0, log_size=0,
>> log_buf=NULL, kern_version=KERNEL_VERSION(0, 0, 0), prog_flags=0,
>> prog_name="", prog_ifindex=0,
>> expected_attach_type=BPF_CGROUP_INET_INGRESS, prog_btf_fd=0,
>> func_info_rec_size=0, func_info=NULL, func_info_cnt=0,
>> line_info_rec_size=0, line_info=NULL, line_info_cnt=0}, 120) = 6
>> bpf(BPF_BTF_LOAD,
>> {btf="\237\353\1\0\30\0\0\0\0\0\0\0000\0\0\0000\0\0\0\t\0\0\0\1\0\0\0\0\0\0\1"...,
>> btf_log_buf=NULL, btf_size=81, btf_log_size=0, btf_log_level=0}, 120) 
>> = 5
>> bpf(BPF_BTF_LOAD,
>> {btf="\237\353\1\0\30\0\0\0\0\0\0\08\0\0\08\0\0\0\t\0\0\0\0\0\0\0\0\0\0\1"...,
>> btf_log_buf=NULL, btf_size=89, btf_log_size=0, btf_log_level=0}, 120) 
>> = 5
>> bpf(BPF_MAP_CREATE, {map_type=BPF_MAP_TYPE_ARRAY, key_size=4,
>> value_size=4, max_entries=1, map_flags=0x400 /* BPF_F_??? */,
>> inner_map_fd=0, map_name="", map_ifindex=0, btf_fd=0, 
>> btf_key_type_id=0,
>> btf_value_type_id=0}, 120) = -1 EPERM (Operation not permitted)
>> bpf(BPF_BTF_LOAD,
>> {btf="\237\353\1\0\30\0\0\0\0\0\0\0`\1\0\0`\1\0\0\236\0\0\0\0\0\0\0\0\0\0\3"...,
>> btf_log_buf=NULL, btf_size=534, btf_log_size=0, btf_log_level=0}, 
>> 120) = 5
>> bpf(BPF_OBJ_GET_INFO_BY_FD, {info={bpf_fd=3, info_len=208,
>> info=0x7ffcaedfd4a0}}, 120) = 0
>> bpf(BPF_OBJ_GET_INFO_BY_FD, {info={bpf_fd=3, info_len=208,
>> info=0x2018c30}}, 120) = 0
>> bpf(BPF_BTF_GET_FD_BY_ID, {btf_id=3}, 120) = 4
>> bpf(BPF_OBJ_GET_INFO_BY_FD, {info={bpf_fd=4, info_len=16,
>> info=0x7ffcaedfd5a0}}, 120) = 0
>> libbpf: Cannot find bpf_func_info for main program sec
>> fexit/xdp_prog_simple. Ignore all bpf_func_info.
>> bpf(BPF_PROG_LOAD, {prog_type=0x1a /* BPF_PROG_TYPE_??? */, 
>> insn_cnt=30,
>> insns=0x20191f0, license="GPL", log_level=7, log_size=16777215,
>> log_buf="", kern_version=KERNEL_VERSION(0, 0, 0), prog_flags=0,
>> prog_name="trace_on_exit", prog_ifindex=0, expected_attach_type=0x19 
>> /*
>> BPF_??? */, prog_btf_fd=5, func_info_rec_size=0, func_info=NULL,
>> func_info_cnt=0, line_info_rec_size=0, line_info=NULL, 
>> line_info_cnt=0,
>> ...}, 120) = -1 EPERM (Operation not permitted)
>> libbpf: load bpf program failed: Operation not permitted
>> libbpf: failed to load program 'fexit/xdp_prog_simple'
>> libbpf: failed to load object './xdp_sample_fentry_fexit_kern.o'
>> ERROR: Failed to load object file: Operation not permitted
>> +++ exited with 0 +++
>>
>> And with full libbpf print debugging:
>>
>> libbpf: loading ./xdp_sample_fentry_fexit_kern.o
>> libbpf: section(1) .strtab, size 250, link 0, flags 0, type=3
>> libbpf: skip section(1) .strtab
>> libbpf: section(2) .text, size 0, link 0, flags 6, type=1
>> libbpf: skip section(2) .text
>> libbpf: section(3) fexit/xdp_prog_simple, size 240, link 0, flags 6, 
>> type=1
>> libbpf: found program fexit/xdp_prog_simple
>> libbpf: section(4) license, size 4, link 0, flags 3, type=1
>> libbpf: license of ./xdp_sample_fentry_fexit_kern.o is GPL
>> libbpf: section(5) .rodata.str1.1, size 52, link 0, flags 32, type=1
>> libbpf: skip section(5) .rodata.str1.1
>> libbpf: section(6) .debug_str, size 344, link 0, flags 30, type=1
>> libbpf: skip section(6) .debug_str
>> libbpf: section(7) .debug_loc, size 70, link 0, flags 0, type=1
>> libbpf: skip section(7) .debug_loc
>> libbpf: section(8) .debug_abbrev, size 297, link 0, flags 0, type=1
>> libbpf: skip section(8) .debug_abbrev
>> libbpf: section(9) .debug_info, size 403, link 0, flags 0, type=1
>> libbpf: skip section(9) .debug_info
>> libbpf: section(10) .rel.debug_info, size 528, link 21, flags 0, 
>> type=9
>> libbpf: skip relo .rel.debug_info(10) for section(9)
>> libbpf: section(11) .debug_ranges, size 96, link 0, flags 0, type=1
>> libbpf: skip section(11) .debug_ranges
>> libbpf: section(12) .debug_macinfo, size 1, link 0, flags 0, type=1
>> libbpf: skip section(12) .debug_macinfo
>> libbpf: section(13) .BTF, size 534, link 0, flags 0, type=1
>> libbpf: section(14) .rel.BTF, size 16, link 21, flags 0, type=9
>> libbpf: skip relo .rel.BTF(14) for section(13)
>> libbpf: section(15) .BTF.ext, size 152, link 0, flags 0, type=1
>> libbpf: section(16) .rel.BTF.ext, size 96, link 21, flags 0, type=9
>> libbpf: skip relo .rel.BTF.ext(16) for section(15)
>> libbpf: section(17) .debug_frame, size 40, link 0, flags 0, type=1
>> libbpf: skip section(17) .debug_frame
>> libbpf: section(18) .rel.debug_frame, size 32, link 21, flags 0, 
>> type=9
>> libbpf: skip relo .rel.debug_frame(18) for section(17)
>> libbpf: section(19) .debug_line, size 206, link 0, flags 0, type=1
>> libbpf: skip section(19) .debug_line
>> libbpf: section(20) .rel.debug_line, size 16, link 21, flags 0, 
>> type=9
>> libbpf: skip relo .rel.debug_line(20) for section(19)
>> libbpf: section(21) .symtab, size 792, link 1, flags 0, type=2
>> libbpf: Cannot find bpf_func_info for main program sec
>> fexit/xdp_prog_simple. Ignore all bpf_func_info.
>> libbpf: load bpf program failed: Operation not permitted
>> libbpf: failed to load program 'fexit/xdp_prog_simple'
>> libbpf: failed to load object './xdp_sample_fentry_fexit_kern.o'
>> ERROR: Failed to load object file: Operation not permitted
>>
>> I’m using the latest pahole, but standard llvm 9.0.0 from Fedora.

Same error with latest llvm

>> So I decided to at least run the self-test and see if this passes, 
>> and
>> work my way from there.
>> But it’s failing to build with errors like “use of unknown 
>> builtin
>> '__builtin_preserve_field_info’”, so I’m assuming my clang9 
>> needs
>> upgrading…
>
> Yes, please try latest llvm trunk. You can find the information on the
> web. Below is the instruction from iovisor/bcc repo.
> (https://github.com/iovisor/bcc/blob/master/INSTALL.md#older-instructions)
>
> git clone https://github.com/llvm/llvm-project.git
> mkdir -p llvm-project/llvm/build/install
> cd llvm-project/llvm/build
> cmake -G "Ninja" -DLLVM_TARGETS_TO_BUILD="BPF;X86" \
>    -DLLVM_ENABLE_PROJECTS="clang" \
>    -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$PWD/install ..
> ninja && ninja install
> export PATH=$PWD/install/bin:$PATH
>

I tried compiling with the latest master llvm, but the selftest failed 
for bpf2bpf (other fail to sudo ./test_progs, Summary: 44/138 PASSED, 1 
SKIPPED, 16 FAILED)

#5 core_reloc:FAIL
test_fentry_fexit:PASS:prog_load sched cls 32573 nsec
libbpf: failed to find valid kernel BTF
libbpf: vmlinux BTF is not found
libbpf: fentry/bpf_fentry_test1 is not found in vmlinux BTF
test_fentry_fexit:FAIL:prog_load fail err -2 errno 2
#6 fentry_fexit:FAIL
test_fentry_test:PASS:prog_load sched cls 0 nsec
libbpf: failed to find valid kernel BTF
libbpf: vmlinux BTF is not found
libbpf: fentry/bpf_fentry_test1 is not found in vmlinux BTF
test_fentry_test:FAIL:prog_load fail err -2 errno 2
#7 fentry_test:FAIL
test_fexit_bpf2bpf:PASS:prog_load sched cls 32764 nsec
test_fexit_bpf2bpf:PASS:obj_open 32764 nsec
libbpf: failed to find valid kernel BTF
libbpf: failed to get target BTF: -3
libbpf: failed to perform CO-RE relocations: -3
libbpf: failed to load object './fexit_bpf2bpf.o'
test_fexit_bpf2bpf:FAIL:obj_load err -3
#8 fexit_bpf2bpf:FAIL

Is there more I need to re-compile other than the test directory?
Or do I need additional configure flags?

$ grep -E -i "btf|bpf" .config
CONFIG_CGROUP_BPF=y
CONFIG_BPF=y
CONFIG_BPF_SYSCALL=y
CONFIG_BPF_JIT_ALWAYS_ON=y
CONFIG_IPV6_SEG6_BPF=y
CONFIG_NETFILTER_XT_MATCH_BPF=m
# CONFIG_BPFILTER is not set
CONFIG_NET_CLS_BPF=m
CONFIG_NET_ACT_BPF=m
CONFIG_BPF_JIT=y
CONFIG_BPF_STREAM_PARSER=y
CONFIG_LWTUNNEL_BPF=y
CONFIG_HAVE_EBPF_JIT=y
CONFIG_BPF_LIRC_MODE2=y
CONFIG_VIDEO_SONY_BTF_MPX=m
# CONFIG_DEBUG_INFO_BTF is not set
CONFIG_BPF_EVENTS=y
# CONFIG_BPF_KPROBE_OVERRIDE is not set
# CONFIG_TEST_BPF is not set

Cheers,

Eelco
