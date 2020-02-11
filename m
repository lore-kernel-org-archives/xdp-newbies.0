Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:35935 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727818AbgBKOhm (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 11 Feb 2020 09:37:42 -0500
From: "Eelco Chaudron" <echaudro@redhat.com>
Subject: Re: Need a way to modify the section name for a read program object
Date: Tue, 11 Feb 2020 15:37:18 +0100
Message-ID: <0D7B2C92-FC75-4167-A973-EB0AD84FC878@redhat.com>
In-Reply-To: <CAEf4BzbWwseeKnGJCPj_VLLcQ-wkbhXWKAPsjQuy4LNDq8fvBg@mail.gmail.com>
References: <D0F8E306-ABEE-480E-BDFD-D43E3A98DC5A@redhat.com>
 <874kw664dy.fsf@toke.dk> <f1fa48b7-8096-b4f2-51cc-bcb4c1da0cd4@fb.com>
 <87zhdyduho.fsf@toke.dk>
 <CAEf4BzbWwseeKnGJCPj_VLLcQ-wkbhXWKAPsjQuy4LNDq8fvBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: Andrii Nakryiko <andrii.nakryiko@gmail.com>, Toke =?utf-8?b?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc: Andrii Nakryiko <andriin@fb.com>, Xdp <xdp-newbies@vger.kernel.org>, bpf@vger.kernel.org



On 4 Feb 2020, at 20:32, Andrii Nakryiko wrote:

> On Tue, Feb 4, 2020 at 11:27 AM Toke Høiland-Jørgensen 
> <toke@redhat.com> wrote:
>>
>> Andrii Nakryiko <andriin@fb.com> writes:
>>
>>> On 2/4/20 2:19 AM, Toke Høiland-Jørgensen wrote:
>>>> "Eelco Chaudron" <echaudro@redhat.com> writes:
>>>>
>>>>> Hi All,
>>>>>
>>>>> I'm trying to write an xdpdump like utility and have some missing 
>>>>> part
>>>>> in libbpf to change the fentry/FUNCTION section name before 
>>>>> loading the
>>>>> trace program.
>>>>>
>>>>> In short, I have an eBPF program that has a section name like
>>>>> "fentry/FUNCTION" where FUNCTION needs to be replaced by the name 
>>>>> of the
>>>>> XDP program loaded in the interfaces its start function.
>>>>>
>>>>> The code for loading the ftrace part is something like:
>>>>>
>>>>>     open_opts.attach_prog_fd = bpf_prog_get_fd_by_id(info.id);
>>>>>     trace_obj = bpf_object__open_file("xdpdump_bpf.o", 
>>>>> &open_opts);
>>>>>
>>>>>     trace_prog_fentry = 
>>>>> bpf_object__find_program_by_title(trace_obj,
>>>>> "fentry/FUNCTION");
>>>>>
>>>>>     /* Here I need to replace the trace_prog_fentry->section_name 
>>>>> =
>>>>> "fentry/<INTERFACE PROG NAME> */
>>>>>
>>>>>     bpf_object__load(trace_obj);
>>>>>     trace_link_fentry = 
>>>>> bpf_program__attach_trace(trace_prog_fentry);
>>>>>
>>>>>
>>>>> See the above, I would like to change the section_name but there 
>>>>> is no
>>>>> API to do this, and of course, the struct bpf_program is
>>>>> implementation-specific.
>>>>>
>>>>> Any idea how I would work around this, or what extension to libbpf 
>>>>> can
>>>>> be suggested to support this?
>>>>
>>>> I think what's missing is a way for the caller to set the 
>>>> attach_btf_id.
>>>> Currently, libbpf always tries to discover this based on the 
>>>> section
>>>> name (see libbpf_find_attach_btf_id()). I think the right way to 
>>>> let the
>>>> caller specify this is not to change the section name, though, but 
>>>> just
>>>> to expose a way to explicitly set the btf_id (which the caller can 
>>>> then
>>>> go find on its own).
>>>
>>> Yes, I agree, section name should be treated as an immutable 
>>> identifier
>>> and a (overrideable) hint to libbpf.
>>>
>>>>
>>>> Not sure if it would be better with a new open_opt (to mirror
>>>> attach_prog_fd), or just a setter 
>>>> (bpf_program__set_attach_btf_id()?).
>>>> Or maybe both? Andrii, WDYT?
>>>
>>> open_opts is definitely wrong way to do this, because open_opts 
>>> apply to
>>> all BPF programs, while this should be per-program.
>>
>> Yes, of course; silly me :)
>>
>>> I'm also not sure having API that allows to specify BTF type ID is 
>>> the
>>> best, probably better to let libbpf perform the search by name. So 
>>> I'd
>>> say something like this:
>>>
>>> int bpf_program__set_attach_target(int attach_prog_fd, const char
>>> *attach_func_name)
>>>
>>> This should handle customizing all the tp_btf/fentry/fexit/freplace 
>>> BPF
>>> programs we have.
>>
>> Right, that makes sense; I think that would cover it (apart from your
>> function signature missing a struct bpf_program argument).
>
> great! and, ha-ha, too object-oriented thinking ;)

Thanks for your feedback, assuming you are not working on it, I’ll 
implement/test it and sent out a patch.

//Eelco
