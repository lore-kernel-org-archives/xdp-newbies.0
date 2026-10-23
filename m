Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792788139;
	b=FX5kfQTIl5hwa0DDgx92WF/hnZ7rBYrGK/hhLqq+0QhCLLU70PHWHy8kwYfCh2WmNug9
	 QraTWQuF4067rWqjnsmeMIUwctoShNQYcD0T3ZfwtEwJ5NUkqwaxpdIzq2Ea0tMopIh+9
	 zCzWncZGniyqvwJWaWIMMkvUHaf02lGX+Soy1U0nTolNOekaQM8FrI/cEHNrIghg2VVxX
	 Lw2c7TP96LYAykRtEVcUuqDuCN8uaf666f35yYffgAfhNTxW/UNnxy7DZmGUypPREOYlJ
	 OuVx7WkJcAET20xVWEoEBYskyO+fsqDAjMCGQ1gABrYMPqfR6iqB61r6xDpDkKxLGdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792788139;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:From:
	 Content-Language:To:Subject:Content-Type:Content-Transfer-Encoding;
	bh=RDAVCEYLkQJBBRbumbtY/fhsVSlKrCr9KDBRRoeX0ww=;
	b=BthKTuaffKbH2oLdYxWz6T/PH9GJ3DB3JghqQJOoIFDduIBjZ+inGsiN8/ZP58vIySBU
	 xiQxuTxbzX0YFBm7aarrLiVPtdpgKP53x7a5YxB7eae1c8oN9mZuDVVOQtsXJ746d0rbs
	 dzCPIEnPvZ6zt9v91hmbwUaZ6q9lZjmYeG2bdkGBY/vqqExCIiUVomqFrBRNnmCJglPtM
	 oZopWlHhgDxCPvuCPBi4VmY2dliUQWWt8vG7pDggiyn3ZZxF6wlE4zexaVFfgfJsy5ySe
	 ODCxUsuzAZKj763TOmXJ3+W7GWwasssd/g8jSQY+cXpstj1w9MtTi6alMc5OfVjx6vA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=okNBZMzG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD6C860A2602;
	Fri, 23 Oct 2026 20:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=okNBZMzG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06F891F01825;
	Fri, 23 Oct 2026 20:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792788133;
	bh=RDAVCEYLkQJBBRbumbtY/fhsVSlKrCr9KDBRRoeX0ww=;
	h=Date:From:To:Subject;
	b=okNBZMzGvcK2PtPk3QkrUlBS4ywbUv9DTixj8EduMAFZCHTsUlV73vs4rkZDfy08K
	 13teZ2bhhsqQlqFZmOYU+SRRY2usH3kl1O5xl4nBewEwGoP/Qjiz31ii8ddL7LLu4c
	 4mTaWI8SRPtxjOIuN43S34v+qkbleHilfwf2/WTZtXojqQizPjEDeBR+rV3uPQYAPF
	 Otzt3IuGByCkPMYg1gmC7ioCahlC/ApzESThbh2Mjwlk4UGUdDvB9YkXfBiCyDeiZq
	 v2dqqmAue2u9/4rR+GTiSTr51Zw2BBOl8Ggq1SgNR0FaTRlT8M4m/XTNM16zq9cE7R
	 QKlurrjXTDdkg==
Message-ID: <77d9c4a3-1c12-4693-b706-da6194d87fde@kernel.org>
Date: Fri, 23 Oct 2026 21:42:11 +0100
X-Mailing-List: xdp-newbies@vger.kernel.org
List-Id: <xdp-newbies.vger.kernel.org>
List-Post: <mailto:xdp-newbies@vger.kernel.org>
List-Help: <mailto:xdp-newbies+help@vger.kernel.org>
List-Subscribe: <mailto:xdp-newbies+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:xdp-newbies+unsubscribe@vger.kernel.org>
List-Owner: <mailto:xdp-newbies+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Quentin Monnet <qmo@kernel.org>
Content-Language: en-GB
To: bpf <bpf@vger.kernel.org>,
 "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>
Subject: FOSDEM 2027 eBPF Devroom Call for Participation
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

We are delighted to announce the Call for Participation for the third
eBPF Devroom at FOSDEM!

Mark the Dates
--------------

* November 23rd, 2026: Submission deadline
* December 7th, 2026: Announcement of accepted talks and schedule
* January 30th, 2027 (Saturday): eBPF Devroom at FOSDEM

eBPF at FOSDEM
--------------

FOSDEM is a free, community-organized event focusing on open source, and
aiming at gathering open source software developers and communities to
meet, learn, and share. It takes place annually in Brussels, Belgium.
After hosting a number of eBPF-related talks in various devrooms over
the years, FOSDEM 2027 welcomes a devroom dedicated to eBPF for the
third time! This devroom aims at gathering talks about various aspects
of eBPF, ideally on multiple platforms.

Topics of Interest
------------------

FOSDEM is an event centered on free and open-source software
development, and brings the opportunity to reach a large audience of
knowledgeable, highly technical open-source software activists. If you
have something to present about eBPF, we would love for you to consider
submitting a proposal to the Devroom.

The projects or technologies discussed in the talks MUST be open-source.

Topics of interest for the Devroom include (but are not limited to):

* eBPF development: recent or proposed features (on Linux, on other
  platforms, or even cross-platform), such as:
    * eBPF arenas, stack improvement, coroutines, improved BTF, etc.
    * eBPF program signing and supply chain security
    * Profiling eBPF with eBPF
    * eBPF-based process schedulers
    * eBPF in storage devices
    * eBPF verifier improvements or alternative implementations
    * eBPF for profiling AI workloads
* Deep-dives on existing eBPF features
* Working with eBPF: best practices, common mistakes, debugging, etc.
* eBPF toolchain, for compiling, managing, debugging, packaging, and
  deploying eBPF programs and related objects
* eBPF libraries, in C/C++, Go, Rust, or other languages
* eBPF in the real world, production use cases and their impact
* eBPF community efforts (documentation, standardization, cross-platform
  initiatives)

The list is not exhaustive, don’t hesitate to submit your proposal!

Format
------

FOSDEM 2027 will be an in-person event in Brussels, Belgium.
We do not accept remote presentations.
(Participants must be able to fund their trip, visa, and accommodation,
as we do not provide any scholarship or other funding assistance.)

We’re looking for 20- to 30-minute presentations. The duration should
include time for questions: allow at least 5 to 10 minutes to answer
questions from the public.

Note that due to time constraints, we may end up offering a slot
duration different than the one requested when submitting. If you have
specific duration requirements, we encourage you to mention them in your
proposal.

You can look at the schedule from previous editions for inspiration, at:
* https://archive.fosdem.org/2026/schedule/track/ebpf/
* https://archive.fosdem.org/2025/schedule/track/ebpf/

How to Submit
-------------

Please submit your proposals on Pretalx, FOSDEM’s submissions tool, at
https://pretalx.fosdem.org/fosdem-2027/cfp

Make sure to select “eBPF” as the track.

Code of Conduct
---------------

All participants at FOSDEM are expected to abide by the FOSDEM’s Code of
Conduct. If your proposal is accepted, you will be required to confirm
that you accept this Code of Conduct. You can find this code at
https://fosdem.org/2027/practical/conduct/

Devroom Organisers
------------------

* Bill Mulligan
* Daniel Borkmann
* Dimitar Kanaliev
* Quentin Monnet
* Yusheng Zheng

If you have questions about any aspects of this Call for Participation,
please email us at ebpf-devroom-manager@fosdem.org, and we will do our
best to assist you.

We keep an up-to-date version of this Call for Participation at
https://ebpf.io/fosdem-2027.html
