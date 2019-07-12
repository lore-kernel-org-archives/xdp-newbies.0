Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qt1-f196.google.com ([209.85.160.196]:33962 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727024AbfGLRtc (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 12 Jul 2019 13:49:32 -0400
MIME-Version: 1.0
References: <20190708163121.18477-1-krzesimir@kinvolk.io> <20190708163121.18477-12-krzesimir@kinvolk.io>
 <CAEf4BzYaV=AxYZna225qKzyWPteU4YFPiBRE4cO30tYmyN_pJQ@mail.gmail.com> <CAGGp+cGMnumMx+GnKbD_ty1C+UWib70s0oBzqdS-=mA-L0jyHA@mail.gmail.com>
In-Reply-To: <CAGGp+cGMnumMx+GnKbD_ty1C+UWib70s0oBzqdS-=mA-L0jyHA@mail.gmail.com>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Fri, 12 Jul 2019 10:49:20 -0700
Message-ID: <CAEf4BzZHJUns8uNuVJzF-77MCtctBOK53hxgkjqpGJxr9YcAoA@mail.gmail.com>
Subject: Re: [bpf-next v3 11/12] selftests/bpf: Add tests for
 bpf_prog_test_run for perf events progs
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: Krzesimir Nowak <krzesimir@kinvolk.io>
Cc: open list <linux-kernel@vger.kernel.org>, Alban Crequy <alban@kinvolk.io>, =?UTF-8?Q?Iago_L=C3=B3pez_Galeiras?= <iago@kinvolk.io>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, Stanislav Fomichev <sdf@google.com>, Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, xdp-newbies@vger.kernel.org

On Fri, Jul 12, 2019 at 10:37 AM Krzesimir Nowak <krzesimir@kinvolk.io> wrote:
>
> On Fri, Jul 12, 2019 at 2:38 AM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Mon, Jul 8, 2019 at 3:42 PM Krzesimir Nowak <krzesimir@kinvolk.io> wrote:
> > >
> > > The tests check if ctx and data are correctly prepared from ctx_in and
> > > data_in, so accessing the ctx and using the bpf_perf_prog_read_value
> > > work as expected.
> > >
> >
> > These are x86_64-specific tests, aren't they? Should probably guard
> > them behind #ifdef's.
>
> Yeah, they are x86_64 specific, because pt_regs are arch specific. I
> was wondering what to do here in the cover letter. Ifdef? Ifdef and
> cover also other arches (please no)? Do some weird tricks with
> overriding the definition of pt_regs? Else?

So one way to go about this would be to use bpf_helpers.h's
PT_REGS_PARM{1-5} and PT_REGS_RC, which seem to be define for all
"supported" platforms. You won't be testing all possible registers,
but those that are most commonly used by BPF programs (to get input
params and func result) would be tested, which is probably the most
important one. That way your test will be arch-agnostic.

>
> >
> > > Signed-off-by: Krzesimir Nowak <krzesimir@kinvolk.io>
> > > ---
> > >  tools/testing/selftests/bpf/test_verifier.c   | 48 ++++++++++
> > >  .../selftests/bpf/verifier/perf_event_run.c   | 96 +++++++++++++++++++
> > >  2 files changed, 144 insertions(+)
> > >  create mode 100644 tools/testing/selftests/bpf/verifier/perf_event_run.c
> > >
> > > diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
> > > index 6f124cc4ee34..484ea8842b06 100644
> > > --- a/tools/testing/selftests/bpf/test_verifier.c
> > > +++ b/tools/testing/selftests/bpf/test_verifier.c
> > > @@ -295,6 +295,54 @@ static void bpf_fill_scale(struct bpf_test *self)
> > >         }
> > >  }
> > >
> > > +static void bpf_fill_perf_event_test_run_check(struct bpf_test *self)
> > > +{
> > > +       compiletime_assert(
> > > +               sizeof(struct bpf_perf_event_data) <= TEST_CTX_LEN,
> > > +               "buffer for ctx is too short to fit struct bpf_perf_event_data");
> > > +       compiletime_assert(
> > > +               sizeof(struct bpf_perf_event_value) <= TEST_DATA_LEN,
> > > +               "buffer for data is too short to fit struct bpf_perf_event_value");
> > > +
> > > +       struct bpf_perf_event_data ctx = {
> > > +               .regs = (bpf_user_pt_regs_t) {
> > > +                       .r15 = 1,
> > > +                       .r14 = 2,
> > > +                       .r13 = 3,
> > > +                       .r12 = 4,
> > > +                       .rbp = 5,
> > > +                       .rbx = 6,
> > > +                       .r11 = 7,
> > > +                       .r10 = 8,
> > > +                       .r9 = 9,
> > > +                       .r8 = 10,
> > > +                       .rax = 11,
> > > +                       .rcx = 12,
> > > +                       .rdx = 13,
> > > +                       .rsi = 14,
> > > +                       .rdi = 15,
> > > +                       .orig_rax = 16,
> > > +                       .rip = 17,
> > > +                       .cs = 18,
> > > +                       .eflags = 19,
> > > +                       .rsp = 20,
> > > +                       .ss = 21,
> > > +               },
> > > +               .sample_period = 1,
> > > +               .addr = 2,
> > > +       };
> > > +       struct bpf_perf_event_value data = {
> > > +               .counter = 1,
> > > +               .enabled = 2,
> > > +               .running = 3,
> > > +       };
> > > +
> > > +       memcpy(self->ctx, &ctx, sizeof(ctx));
> > > +       memcpy(self->data, &data, sizeof(data));
> >
> > Just curious, just assignment didn't work?
> >
> > > +       free(self->fill_insns);
> > > +       self->fill_insns = NULL;
> > > +}
> > > +
> > >  /* BPF_SK_LOOKUP contains 13 instructions, if you need to fix up maps */
> > >  #define BPF_SK_LOOKUP(func)                                            \
> > >         /* struct bpf_sock_tuple tuple = {} */                          \
> > > diff --git a/tools/testing/selftests/bpf/verifier/perf_event_run.c b/tools/testing/selftests/bpf/verifier/perf_event_run.c
> > > new file mode 100644
> > > index 000000000000..3f877458a7f8
> > > --- /dev/null
> > > +++ b/tools/testing/selftests/bpf/verifier/perf_event_run.c
> > > @@ -0,0 +1,96 @@
> > > +#define PER_LOAD_AND_CHECK_PTREG(PT_REG_FIELD, VALUE)                  \
> > > +       PER_LOAD_AND_CHECK_CTX(offsetof(bpf_user_pt_regs_t, PT_REG_FIELD), VALUE)
> > > +#define PER_LOAD_AND_CHECK_EVENT(PED_FIELD, VALUE)                     \
> > > +       PER_LOAD_AND_CHECK_CTX(offsetof(struct bpf_perf_event_data, PED_FIELD), VALUE)
> > > +#define PER_LOAD_AND_CHECK_CTX(OFFSET, VALUE)                          \
> > > +       PER_LOAD_AND_CHECK_64(BPF_REG_4, BPF_REG_1, OFFSET, VALUE)
> > > +#define PER_LOAD_AND_CHECK_VALUE(PEV_FIELD, VALUE)                     \
> > > +       PER_LOAD_AND_CHECK_64(BPF_REG_7, BPF_REG_6, offsetof(struct bpf_perf_event_value, PEV_FIELD), VALUE)
> >
> > Wrap long lines? Try also running scripts/checkpatch.pl again these
> > files you are modifying.
>
> Will wrap. Checkpatch was also complaining about complex macro not
> being inside parens, but I can't see how to wrap it in parens and keep
> it working at the same time.
>
> >
> > > +#define PER_LOAD_AND_CHECK_64(DST, SRC, OFFSET, VALUE)                 \
> > > +       BPF_LDX_MEM(BPF_DW, DST, SRC, OFFSET),                          \
> > > +       BPF_JMP_IMM(BPF_JEQ, DST, VALUE, 2),                            \
> > > +       BPF_MOV64_IMM(BPF_REG_0, VALUE),                                \
> > > +       BPF_EXIT_INSN()
> > > +
> > > +{
> > > +       "check if regs contain expected values",
> > > +       .insns = {
> > > +       PER_LOAD_AND_CHECK_PTREG(r15, 1),
> > > +       PER_LOAD_AND_CHECK_PTREG(r14, 2),
> > > +       PER_LOAD_AND_CHECK_PTREG(r13, 3),
> > > +       PER_LOAD_AND_CHECK_PTREG(r12, 4),
> > > +       PER_LOAD_AND_CHECK_PTREG(rbp, 5),
> > > +       PER_LOAD_AND_CHECK_PTREG(rbx, 6),
> > > +       PER_LOAD_AND_CHECK_PTREG(r11, 7),
> > > +       PER_LOAD_AND_CHECK_PTREG(r10, 8),
> > > +       PER_LOAD_AND_CHECK_PTREG(r9, 9),
> > > +       PER_LOAD_AND_CHECK_PTREG(r8, 10),
> > > +       PER_LOAD_AND_CHECK_PTREG(rax, 11),
> > > +       PER_LOAD_AND_CHECK_PTREG(rcx, 12),
> > > +       PER_LOAD_AND_CHECK_PTREG(rdx, 13),
> > > +       PER_LOAD_AND_CHECK_PTREG(rsi, 14),
> > > +       PER_LOAD_AND_CHECK_PTREG(rdi, 15),
> > > +       PER_LOAD_AND_CHECK_PTREG(orig_rax, 16),
> > > +       PER_LOAD_AND_CHECK_PTREG(rip, 17),
> > > +       PER_LOAD_AND_CHECK_PTREG(cs, 18),
> > > +       PER_LOAD_AND_CHECK_PTREG(eflags, 19),
> > > +       PER_LOAD_AND_CHECK_PTREG(rsp, 20),
> > > +       PER_LOAD_AND_CHECK_PTREG(ss, 21),
> > > +       BPF_MOV64_IMM(BPF_REG_0, 0),
> > > +       BPF_EXIT_INSN(),
> > > +       },
> > > +       .result = ACCEPT,
> > > +       .prog_type = BPF_PROG_TYPE_PERF_EVENT,
> > > +       .ctx_len = sizeof(struct bpf_perf_event_data),
> > > +       .data_len = sizeof(struct bpf_perf_event_value),
> > > +       .fill_helper = bpf_fill_perf_event_test_run_check,
> > > +       .override_data_out_len = true,
> > > +},
> > > +{
> > > +       "check if sample period and addr contain expected values",
> > > +       .insns = {
> > > +       PER_LOAD_AND_CHECK_EVENT(sample_period, 1),
> > > +       PER_LOAD_AND_CHECK_EVENT(addr, 2),
> > > +       BPF_MOV64_IMM(BPF_REG_0, 0),
> > > +       BPF_EXIT_INSN(),
> > > +       },
> > > +       .result = ACCEPT,
> > > +       .prog_type = BPF_PROG_TYPE_PERF_EVENT,
> > > +       .ctx_len = sizeof(struct bpf_perf_event_data),
> > > +       .data_len = sizeof(struct bpf_perf_event_value),
> > > +       .fill_helper = bpf_fill_perf_event_test_run_check,
> > > +       .override_data_out_len = true,
> > > +},
> > > +{
> > > +       "check if bpf_perf_prog_read_value returns expected data",
> > > +       .insns = {
> > > +       // allocate space for a struct bpf_perf_event_value
> > > +       BPF_MOV64_REG(BPF_REG_6, BPF_REG_10),
> > > +       BPF_ALU64_IMM(BPF_ADD, BPF_REG_6, -(int)sizeof(struct bpf_perf_event_value)),
> > > +       // prepare parameters for bpf_perf_prog_read_value(ctx, struct bpf_perf_event_value*, u32)
> > > +       // BPF_REG_1 already contains the context
> > > +       BPF_MOV64_REG(BPF_REG_2, BPF_REG_6),
> > > +       BPF_MOV64_IMM(BPF_REG_3, sizeof(struct bpf_perf_event_value)),
> > > +       BPF_EMIT_CALL(BPF_FUNC_perf_prog_read_value),
> > > +       // check the return value
> > > +       BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 1),
> > > +       BPF_EXIT_INSN(),
> > > +       // check if the fields match the expected values
> >
> > Use /* */ comments.
>
> Oops. Will fix.
>
> >
> > > +       PER_LOAD_AND_CHECK_VALUE(counter, 1),
> > > +       PER_LOAD_AND_CHECK_VALUE(enabled, 2),
> > > +       PER_LOAD_AND_CHECK_VALUE(running, 3),
> > > +       BPF_MOV64_IMM(BPF_REG_0, 0),
> > > +       BPF_EXIT_INSN(),
> > > +       },
> > > +       .result = ACCEPT,
> > > +       .prog_type = BPF_PROG_TYPE_PERF_EVENT,
> > > +       .ctx_len = sizeof(struct bpf_perf_event_data),
> > > +       .data_len = sizeof(struct bpf_perf_event_value),
> > > +       .fill_helper = bpf_fill_perf_event_test_run_check,
> > > +       .override_data_out_len = true,
> > > +},
> > > +#undef PER_LOAD_AND_CHECK_64
> > > +#undef PER_LOAD_AND_CHECK_VALUE
> > > +#undef PER_LOAD_AND_CHECK_CTX
> > > +#undef PER_LOAD_AND_CHECK_EVENT
> > > +#undef PER_LOAD_AND_CHECK_PTREG
> > > --
> > > 2.20.1
> > >
>
>
>
> --
> Kinvolk GmbH | Adalbertstr.6a, 10999 Berlin | tel: +491755589364
> Geschäftsführer/Directors: Alban Crequy, Chris Kühl, Iago López Galeiras
> Registergericht/Court of registration: Amtsgericht Charlottenburg
> Registernummer/Registration number: HRB 171414 B
> Ust-ID-Nummer/VAT ID number: DE302207000
