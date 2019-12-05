Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-il1-f193.google.com ([209.85.166.193]:42469 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729598AbfLERgT (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Thu, 5 Dec 2019 12:36:19 -0500
MIME-Version: 1.0
References: <E53E0693-1C3A-4B47-B205-DC8E5DAF3619@redhat.com>
 <CAADnVQKkLtG-QCZwxx-Bpz8-goh-_mSTtUSzpb_oTv9a-qLizg@mail.gmail.com>
 <3AC9D2B7-9D2F-4286-80A2-1721B51B62CF@redhat.com> <CAADnVQJKSnoMVpQ3F86zBhFyo8WQ0vi65Z4QDtopLRrpK4yB8Q@mail.gmail.com>
 <4BBF99E4-9554-44F7-8505-D4B8416554C4@redhat.com> <d588c894-a4e0-8b99-72a9-4429b27091df@fb.com>
 <056E9F5E-4FDD-4636-A43A-EC98A06E84D3@redhat.com> <aa59532b-34a9-7887-f550-ef2859f0c9f1@fb.com>
 <B7E0062E-37ED-46E6-AE64-EE3E2A0294EA@redhat.com> <7062345a-1060-89f6-0c02-eef2fe0d835a@fb.com>
 <b8d80047-3bc1-5393-76a1-7517cb2b7280@fb.com> <E08A0006-E254-492C-92AB-408B58E456C0@redhat.com>
 <F8CFD537-7907-4259-9C91-4649F799216B@redhat.com>
In-Reply-To: <F8CFD537-7907-4259-9C91-4649F799216B@redhat.com>
From: Y Song <ys114321@gmail.com>
Date: Thu, 5 Dec 2019 09:35:42 -0800
Message-ID: <CAH3MdRXr+3mUfrd8MPH-mDdNwD1szXRhz07s2C4dVQ0EkzDaAg@mail.gmail.com>
Subject: Re: Trying the bpf trace a bpf xdp program
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: Eelco Chaudron <echaudro@redhat.com>
Cc: Yonghong Song <yhs@fb.com>, Alexei Starovoitov <alexei.starovoitov@gmail.com>, Xdp <xdp-newbies@vger.kernel.org>, bpf <bpf@vger.kernel.org>

On Thu, Dec 5, 2019 at 4:41 AM Eelco Chaudron <echaudro@redhat.com> wrote:
>
>
>
> On 4 Dec 2019, at 19:52, Eelco Chaudron wrote:
>
> > On 4 Dec 2019, at 19:01, Yonghong Song wrote:
> >
> > <SNIP>
> >
> >>>> I’ve put my code on GitHub, maybe it’s just something stupid…
> >>
> >> Thanks for the test case. This indeed a kernel bug.
> >> The following change fixed the issue:
> >>
> >>
> >> -bash-4.4$ git diff
> >> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> >> index a0482e1c4a77..034ef81f935b 100644
> >> --- a/kernel/bpf/verifier.c
> >> +++ b/kernel/bpf/verifier.c
> >> @@ -9636,7 +9636,10 @@ static int check_attach_btf_id(struct
> >> bpf_verifier_env *env)
> >>                                  ret = -EINVAL;
> >>                                  goto out;
> >>                          }
> >> -                       addr = (long)
> >> tgt_prog->aux->func[subprog]->bpf_func;
> >> +                       if (subprog == 0)
> >> +                               addr = (long) tgt_prog->bpf_func;
> >> +                       else
> >> +                               addr = (long)
> >> tgt_prog->aux->func[subprog]->bpf_func;
> >>                  } else {
> >>                          addr = kallsyms_lookup_name(tname);
> >>                          if (!addr) {
> >> -bash-4.4$
> >>
> >> The reason is for a bpf program without any additional subprogram
> >> (callees), tgt_prog->aux->func is not populated and is a NULL
> >> pointer,
> >> so the access tgt_prog->aux->func[0]->bpf_func will segfault.
> >>
> >> With the above change, your test works properly.
> >
> > Thanks for the quick response, and as you mention the test passes with
> > the patch above.
> >
> > I will continue my experiments later this week, and let you know if I
> > run into any other problems.
> >
>
> With the following program I get some access errors:
>
> #define bpf_debug(fmt, ...)                         \
> {                                                   \
>    char __fmt[] = fmt;                               \
>    bpf_trace_printk(__fmt, sizeof(__fmt),            \
>                     ##__VA_ARGS__);                  \
> }
>
> BPF_TRACE_2("fexit/xdp_prog_simple", trace_on_exit,
>              struct xdp_md *, xdp, int, ret)
> {
>    __u32 rx_queue;
>
>    __builtin_preserve_access_index(({
>          rx_queue = xdp->rx_queue_index;
>        }));
>
>    bpf_debug("fexit: queue = %u, ret = %d\n", rx_queue, ret);
>
>    return 0;
> }
>
> I assume the XDP context has not been vetted?
>
> libbpf: -- BEGIN DUMP LOG ---
> libbpf:
> func#0 @0
> BPF program ctx type is not a struct
> Type info disagrees with actual arguments due to compiler optimizations
> 0: R1=ctx(id=0,off=0,imm=0) R10=fp0
> ; BPF_TRACE_2("fexit/xdp_prog_simple", trace_on_exit,
> 0: (b7) r2 = 16
> 1: R1=ctx(id=0,off=0,imm=0) R2_w=inv16 R10=fp0
> ; BPF_TRACE_2("fexit/xdp_prog_simple", trace_on_exit,
> 1: (79) r3 = *(u64 *)(r1 +0)
> 2: R1=ctx(id=0,off=0,imm=0) R2_w=inv16
> R3_w=ptr_xdp_buff(id=0,off=0,imm=0) R10=fp0
> 2: (0f) r3 += r2
> last_idx 2 first_idx 0
> regs=4 stack=0 before 1: (79) r3 = *(u64 *)(r1 +0)
> regs=4 stack=0 before 0: (b7) r2 = 16
> 3: R1=ctx(id=0,off=0,imm=0) R2_w=invP16
> R3_w=ptr_xdp_buff(id=0,off=16,imm=0) R10=fp0
> ; rx_queue = xdp->rx_queue_index;
> 3: (61) r3 = *(u32 *)(r3 +0)
> cannot access ptr member data_meta with moff 16 in struct xdp_buff with
> off 16 size 4
> verification time 102 usec
> stack depth 0
> processed 4 insns (limit 1000000) max_states_per_insn 0 total_states 0
> peak_states 0 mark_read 0
> libbpf: -- END LOG --
>

It is a little tricky. The below change can make verifier happy. I did
not test it so not sure whether produces correct result or not.

==========
struct xdp_rxq_info {
        __u32 queue_index;
} __attribute__((preserve_access_index));

struct xdp_buff {
        struct xdp_rxq_info *rxq;
} __attribute__((preserve_access_index));

BPF_TRACE_2("fexit/xdp_prog_simple", trace_on_exit,
            struct xdp_buff *, ctx, int, ret)
{
   __u32 rx_queue;

   rx_queue = ctx->rxq->queue_index;
   bpf_debug("fexit: queue = %u, ret = %d\n", rx_queue, ret);

   return 0;
}
==========

In the above, I am using newly added clang attribute "__preserve_access_index"
(in llvm-project trunk since Nov. 13) to make code
a little bit cleaner. The old way as in selftests fexit_bpf2bpf.c
should work too.

Basically, the argument for fexit function should be types actually
passing to the jited function.
For user visible 'xdp_md`. the jited function will receive `xdp_buff`.
The access for each field
sometimes is not one-to-one mapping. You need to check kernel code to
find the correct
way. We probably should make this part better to improve user experience.

>
> Trying to use the helpers, passes verification, however, it’s dumping
> invalid content:
>
> BPF_TRACE_2("fexit/xdp_prog_simple", trace_on_exit,
>              struct xdp_md *, xdp, int, ret)
> {
>    __u32 rx_queue;
>
>    bpf_probe_read_kernel(&rx_queue, sizeof(rx_queue),
>                          __builtin_preserve_access_index(&xdp->rx_queue_index));
>
>    bpf_debug("fexit: queue = %u, ret = %d\n", rx_queue, ret);
>    return 0;
> }
>
> Debug output:
>
>     ping6-2752  [004] ..s1 60763.917790: 0: SIMPLE: [ifindex = 4, queue
> =  0]
>     ping6-2752  [004] ..s1 60763.917800: 0: fexit: queue = 2969379072,
> ret = 2
>     ping6-2752  [004] ..s1 60764.941817: 0: SIMPLE: [ifindex = 4, queue
> =  0]
>     ping6-2752  [004] ..s1 60764.941828: 0: fexit: queue = 2969379072,
> ret = 2
>     ping6-2752  [004] ..s1 60765.965835: 0: SIMPLE: [ifindex = 4, queue
> =  0]
>
>
> Tried the same with fentry for this function, but the same results as
> fexit.
>
> Any hints?
>
> Thanks,
>
>
> Eelco
>
