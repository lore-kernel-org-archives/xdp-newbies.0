Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-vk0-f42.google.com ([209.85.213.42]:37564 "EHLO
        mail-vk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753217AbdHXVSw (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 24 Aug 2017 17:18:52 -0400
Received: by mail-vk0-f42.google.com with SMTP id q189so2193024vke.4
        for <xdp-newbies@vger.kernel.org>; Thu, 24 Aug 2017 14:18:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <F617083E-E950-48CB-8870-D8BA942D72EC@renci.org>
References: <24D45A9F-03F3-435C-A281-98F710A789CF@renci.org>
 <CAH3MdRV4+oZubJ36foLua_q87YGg8UsaFejKrWON5zN7DEEC5A@mail.gmail.com>
 <599EFE21.5030608@iogearbox.net> <CAH9hs-Jm8VSnVnj-c8SGRz=fePiUfOOZ5EqCGFC0MTMQ2rry1Q@mail.gmail.com>
 <F53AC7C3-CA5D-44C6-86E0-B967FD966FD3@renci.org> <CAH3MdRVF=r3HhCTY8Q0uPTJF7umN3G8w4Kb56tfjRExL61gEeg@mail.gmail.com>
 <CAH9hs-J=48OiwRya2EUExm09NTDd7zT+D5aHu6NNhBALaR9Z-A@mail.gmail.com> <F617083E-E950-48CB-8870-D8BA942D72EC@renci.org>
From: Y Song <ys114321@gmail.com>
Date: Thu, 24 Aug 2017 14:18:10 -0700
Message-ID: <CAH3MdRV8nCUQUXu9b7x=NqV6hJJF-rwDT0A4Bu1zBcYJQqe7UQ@mail.gmail.com>
Subject: Re: [iovisor-dev] modifying packets in XDP
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: Ilya Baldin <ibaldin@renci.org>
Cc: Brenden Blanco <bblanco@gmail.com>, Daniel Borkmann <daniel@iogearbox.net>, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, Tom Herbert via iovisor-dev <iovisor-dev@lists.iovisor.org>

This is the problem:
static inline uint16_t parse_tcp_pld(void *data, u64 nh_off, void *data_end) {
  uint16_t *pld = data + nh_off;
  if ((void*)&pld[1] > data_end)
    return 0;
  return pld;
}

return value should be "void *" or "uint16_t *".

In the future, we will try to add more diagnostic information to debug
such issues.


On Thu, Aug 24, 2017 at 12:52 PM, Ilya Baldin <ibaldin@renci.org> wrote:
> If I just copy your swapu16 function into my code (and it looks very similar to mine) the result continues to be the same (error).
>
> Here is a gist with python and c-components of my program
>
> https://gist.github.com/ibaldin/716d70d490b44e05d15db59ee983c0c0
>
> Looking at the BPF byte code print out from BCC (below) something strange is indeed going on that I think Yonghong alluded to.
>
> The last instruction is r2 = *(u16*)(r1 + 8), and r1 is invalid. R1 is initially set, but then for some reason becomes invalid:
>
> 50: (2d) if r4 > r2 goto pc+35
>  R1=pkt(id=2,off=0,r=2),aux_off_align=2 R2=pkt_end R3=pkt(id=1,off=0,r=20),aux_off_align=2 R4=pkt(id=2,off=2,r=2),aux_off_align=2 R5=inv56,min_value=22,max_value=142,min_align=2,aux_off_align=2 R10=fp
> 51: (57) r1 &= 65535
> 52: (15) if r1 == 0x0 goto pc+33
>  R1=inv,min_value=0,max_value=65535,min_align=1,aux_off_align=2 R2=pkt_end R3=pkt(id=1,off=0,r=20),aux_off_align=2 R4=pkt(id=2,off=2,r=2),aux_off_align=2 R5=inv56,min_value=22,max_value=14
>
>
> —— FULL TEXT OF BPF PROGRAM BYTECODE ———
>
>
> 0: (61) r2 = *(u32 *)(r1 +4)
> 1: (61) r1 = *(u32 *)(r1 +0)
> 2: (bf) r3 = r1
> 3: (07) r3 += 14
> 4: (2d) if r3 > r2 goto pc+81
>  R1=pkt(id=0,off=0,r=14) R2=pkt_end R3=pkt(id=0,off=14,r=14) R10=fp
> 5: (71) r3 = *(u8 *)(r1 +12)
> 6: (71) r4 = *(u8 *)(r1 +13)
> 7: (67) r4 <<= 8
> 8: (4f) r4 |= r3
> 9: (15) if r4 == 0xa888 goto pc+2
>  R1=pkt(id=0,off=0,r=14) R2=pkt_end R3=inv56 R4=inv R10=fp
> 10: (b7) r3 = 14
> 11: (55) if r4 != 0x81 goto pc+4
>  R1=pkt(id=0,off=0,r=14) R2=pkt_end R3=imm14,min_value=14,max_value=14,min_align=2 R4=inv,min_value=129,max_value=129 R10=fp
> 12: (b7) r3 = 18
> 13: (bf) r5 = r1
> 14: (07) r5 += 18
> 15: (2d) if r5 > r2 goto pc+70
>  R1=pkt(id=0,off=0,r=18) R2=pkt_end R3=imm18,min_value=18,max_value=18,min_align=2 R4=inv,min_value=129,max_value=129 R5=pkt(id=0,off=18,r=18) R10=fp
> 16: (15) if r4 == 0xa888 goto pc+1
>  R1=pkt(id=0,off=0,r=18) R2=pkt_end R3=imm18,min_value=18,max_value=18,min_align=2 R4=inv,min_value=129,max_value=129 R5=pkt(id=0,off=18,r=18) R10=fp
> 17: (55) if r4 != 0x81 goto pc+4
>  R1=pkt(id=0,off=0,r=18) R2=pkt_end R3=imm18,min_value=18,max_value=18,min_align=2 R4=inv,min_value=129,max_value=129 R5=pkt(id=0,off=18,r=18) R10=fp
> 18: (07) r3 += 4
> 19: (bf) r5 = r1
> 20: (0f) r5 += r3
> 21: (2d) if r5 > r2 goto pc+64
>  R1=pkt(id=0,off=0,r=22) R2=pkt_end R3=imm22,min_value=22,max_value=22,min_align=2 R4=inv,min_value=129,max_value=129 R5=pkt(id=0,off=22,r=22) R10=fp
> 22: (55) if r4 != 0x8 goto pc+63
>  R1=pkt(id=0,off=0,r=22) R2=pkt_end R3=imm22,min_value=22,max_value=22,min_align=2 R4=inv,min_value=8,max_value=8 R5=pkt(id=0,off=22,r=22) R10=fp
> 23: (bf) r4 = r1
> 24: (0f) r4 += r3
> 25: (15) if r4 == 0x0 goto pc+60
>  R1=pkt(id=0,off=0,r=22) R2=pkt_end R3=imm22,min_value=22,max_value=22,min_align=2 R4=pkt(id=0,off=22,r=22) R5=pkt(id=0,off=22,r=22) R10=fp
> 26: (bf) r5 = r4
> 27: (07) r5 += 20
> 28: (2d) if r5 > r2 goto pc+57
>  R1=pkt(id=0,off=0,r=42) R2=pkt_end R3=imm22,min_value=22,max_value=22,min_align=2 R4=pkt(id=0,off=22,r=42) R5=pkt(id=0,off=42,r=42) R10=fp
> 29: (71) r4 = *(u8 *)(r4 +9)
> 30: (55) if r4 != 0x6 goto pc+55
>  R1=pkt(id=0,off=0,r=42) R2=pkt_end R3=imm22,min_value=22,max_value=22,min_align=2 R4=inv56,min_value=6,max_value=6 R5=pkt(id=0,off=42,r=42) R10=fp
> 31: (bf) r4 = r1
> 32: (0f) r4 += r3
> 33: (71) r4 = *(u8 *)(r4 +0)
> 34: (57) r4 &= 15
> 35: (67) r4 <<= 2
> 36: (0f) r4 += r3
> 37: (bf) r3 = r1
> 38: (0f) r3 += r4
> 39: (15) if r3 == 0x0 goto pc+46
>  R1=pkt(id=0,off=0,r=42) R2=pkt_end R3=pkt(id=1,off=0,r=0),aux_off_align=2 R4=inv57,min_value=22,max_value=82,min_align=2 R5=pkt(id=0,off=42,r=42) R10=fp
> 40: (bf) r5 = r3
> 41: (07) r5 += 20
> 42: (2d) if r5 > r2 goto pc+43
>  R1=pkt(id=0,off=0,r=42) R2=pkt_end R3=pkt(id=1,off=0,r=20),aux_off_align=2 R4=inv57,min_value=22,max_value=82,min_align=2 R5=pkt(id=1,off=20,r=20),aux_off_align=2 R10=fp
> 43: (69) r5 = *(u16 *)(r3 +12)
> 44: (77) r5 >>= 2
> 45: (57) r5 &= 60
> 46: (0f) r5 += r4
> 47: (0f) r1 += r5
> 48: (bf) r4 = r1
> 49: (07) r4 += 2
> 50: (2d) if r4 > r2 goto pc+35
>  R1=pkt(id=2,off=0,r=2),aux_off_align=2 R2=pkt_end R3=pkt(id=1,off=0,r=20),aux_off_align=2 R4=pkt(id=2,off=2,r=2),aux_off_align=2 R5=inv56,min_value=22,max_value=142,min_align=2,aux_off_align=2 R10=fp
> 51: (57) r1 &= 65535
> 52: (15) if r1 == 0x0 goto pc+33
>  R1=inv,min_value=0,max_value=65535,min_align=1,aux_off_align=2 R2=pkt_end R3=pkt(id=1,off=0,r=20),aux_off_align=2 R4=pkt(id=2,off=2,r=2),aux_off_align=2 R5=inv56,min_value=22,max_value=142,min_align=2,aux_off_align=2 R10=fp
> 53: (b7) r5 = 0
> 54: (bf) r0 = r1
> 55: (07) r0 += 6
> 56: (b7) r4 = 0
> 57: (2d) if r0 > r2 goto pc+9
>  R0=inv,min_value=6,max_value=65541,min_align=1,aux_off_align=2 R1=inv,min_value=0,max_value=65535,min_align=1,aux_off_align=2 R2=pkt_end R3=pkt(id=1,off=0,r=20),aux_off_align=2 R4=imm0,min_value=0,max_value=0,min_align=2147483648,aux_off_align=2 R5=imm0,min_value=0,max_value=0,min_align=2147483648,aux_off_align=2 R10=fp
> 58: (bf) r0 = r1
> 59: (07) r0 += 10
> 60: (b7) r4 = 0
> 61: (2d) if r0 > r2 goto pc+5
>  R0=inv,min_value=10,max_value=65545,min_align=1,aux_off_align=2 R1=inv,min_value=0,max_value=65535,min_align=1,aux_off_align=2 R2=pkt_end R3=pkt(id=1,off=0,r=20),aux_off_align=2 R4=imm0,min_value=0,max_value=0,min_align=2147483648,aux_off_align=2 R5=imm0,min_value=0,max_value=0,min_align=2147483648,aux_off_align=2 R10=fp
> 62: (69) r2 = *(u16 *)(r1 +8)
> R1 invalid mem access 'inv'
>
> -ilya
>
> Ilya Baldin
>
