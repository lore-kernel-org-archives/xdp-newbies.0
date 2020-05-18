Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-dm6nam10on2071.outbound.protection.outlook.com ([40.107.93.71]:6216
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727782AbgERQ27 (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 18 May 2020 12:28:59 -0400
From: "Main, George" <mainge@rose-hulman.edu>
Subject: XDP_PASS and XDP_REDIRECT
Date: Mon, 18 May 2020 16:28:57 +0000
Message-ID: <DM6PR18MB2475DD12FB5A8D747CA6ABEF9CB80@DM6PR18MB2475.namprd18.prod.outlook.com>
Content-Language: en-US
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>

Hello All,=0A=0AI am working on an XDP Content Based Router project. The ba=
sic concept is that a machine running an XDP program acts as a gateway and =
accepts TCP connections from outside machines. Upon receiving a message it =
converts the packet to UDP and uses bpf_redirect_map to send the packet out=
 through another interface.=0A=0AThe problem I am encountering is that I wa=
nt to be able to pass the message to userspace (where the TCP server reside=
s) using XDP_PASS in addition to the redirect. I'm somewhat looking for a w=
ay to emulate the functionality of bpf_clone_redirect, but with support for=
 XDP driver mode.=0A=0AIs this even possible right now? Are there any worka=
rounds?=0A=0AThanks!
