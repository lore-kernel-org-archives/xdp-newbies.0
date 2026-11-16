Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794866276;
	b=FbLuF6HfhUPtaFNz39OdwbUTyqPT/7+GBGt1NJcffMAByWoQfQS6xiLduQXFS2HjD9W2
	 pL0EvIlt7x+b8gVzv5+mkUk1XK60SUwHRD967ooEZDruclW/RvoucF4G13Ibrcuq8b+U9
	 TKe+U00Pb9V35geXZ4BOKsGd1O4KvOnQ9o9tYYaGP/oPLRwkW22JRPQJl0rkmzko6w/IB
	 goAIGNuAWmQ2pJByZ1Qpz8fw5Cq631Dt3HPY1pllZHPDbAUL82t5O4sKLKv3BOO0i6DTo
	 q2ti7/V1KT98asCqZ/4cr0MYxeUpiZhNABVSqmOxQLU8r6AZ/SfTrbl7CRBy/292G7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794866276;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:From:To:References:Content-Language:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=pQi+zTsQ4fW3IG1ScZNoT8FbLMynAb5D/9kFyl0ktVw=;
	b=TTnCx6K9zU9HHXcMM/H2hCDgEjzvKW6Sguy8XZLTpXlykau0aQxKwU0tLJv4U2jQcy8I
	 zWQctvDYFJpe4SKgKXWdMmOtU3lDYJ8EUkJsQ0uflM2/Kh11+RGRYOP6oInSBO2N13JDm
	 rXhnosGzsugprU0F+eFiF4yJkvBCzs3wekXO3YL7tnc+CFR6cHysIuVjrhztkuaqfdwVm
	 m1r1IfglPCLh5ArrXB/mVKJXHulNbnjK8Z/nGy9iIwATmwQZ5E1SnmlXGgekTZ9d+TkcZ
	 tO4raHpAYVTHOamQcwlYZxphhoHNcXGltQjFgSP1qeE52/pq3QKIN8mRcqwTdLf8dEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lMiGOGnQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7F58606A322;
	Mon, 16 Nov 2026 21:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lMiGOGnQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 199251F000C4;
	Mon, 16 Nov 2026 21:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794866276;
	bh=pQi+zTsQ4fW3IG1ScZNoT8FbLMynAb5D/9kFyl0ktVw=;
	h=Date:Subject:From:To:References:In-Reply-To;
	b=lMiGOGnQMCCDhAv77Ysp4TPPoedRjYI4PXlqMHQ0AlldXnVH1qBQh1Kxk9FT4Kwl/
	 q4xIMPyXziu/O4+Fw6jbpWDY6pymrsHHE3WrVFyaVXcmXlkFc2yBGS1lPfmDcVk763
	 auJvdM9k/pSGmC3e0fXZ72JqX00Ris7icgrtxsxw3vBbZtmpdxzn7MYT04kFWTYQLD
	 91oSnlCXk3LsYhb2fIP5NERewEfAehH78VL7eSjGffFhdWnK9R/2cZxbOSWWXrO3HP
	 GvklyTR/frHFqqU0x6PI+aHq3g+rAVSZwPcev74PW4zWR5r/IfKrG6I/Y9w43YHX/r
	 zDyFkfVavU1lQ==
Message-ID: <1675ee0c-6494-4b0c-8bb9-5dd8a226d0ed@kernel.org>
Date: Mon, 16 Nov 2026 21:57:54 +0000
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
Subject: Re: FOSDEM 2027 eBPF Devroom Call for Participation
From: Quentin Monnet <qmo@kernel.org>
To: bpf <bpf@vger.kernel.org>,
 "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>
References: <77d9c4a3-1c12-4693-b706-da6194d87fde@kernel.org>
Content-Language: en-GB
In-Reply-To: <77d9c4a3-1c12-4693-b706-da6194d87fde@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi all,

The call for participation for the BPF devroom at FOSDEM'27 is open
(details below, or at https://ebpf.io/fosdem-2027.html).
It closes on *November 23rd*, in just one week.

If you have work or experiments to share on eBPF, please consider
submitting. If you know people who might be interested in attending or
presenting at the devroom, please pass the word.

Thanks,
Quentin



2026-10-23 21:42 UTC+0100 ~ Quentin Monnet <qmo@kernel.org>
> We are delighted to announce the Call for Participation for the third
> eBPF Devroom at FOSDEM!
> 
> Mark the Dates
> --------------
> 
> * November 23rd, 2026: Submission deadline
> * December 7th, 2026: Announcement of accepted talks and schedule
> * January 30th, 2027 (Saturday): eBPF Devroom at FOSDEM
> 
> eBPF at FOSDEM
> --------------
> 
> FOSDEM is a free, community-organized event focusing on open source, and
> aiming at gathering open source software developers and communities to
> meet, learn, and share. It takes place annually in Brussels, Belgium.
> After hosting a number of eBPF-related talks in various devrooms over
> the years, FOSDEM 2027 welcomes a devroom dedicated to eBPF for the
> third time! This devroom aims at gathering talks about various aspects
> of eBPF, ideally on multiple platforms.
> 
> Topics of Interest
> ------------------
> 
> FOSDEM is an event centered on free and open-source software
> development, and brings the opportunity to reach a large audience of
> knowledgeable, highly technical open-source software activists. If you
> have something to present about eBPF, we would love for you to consider
> submitting a proposal to the Devroom.
> 
> The projects or technologies discussed in the talks MUST be open-source.
> 
> Topics of interest for the Devroom include (but are not limited to):
> 
> * eBPF development: recent or proposed features (on Linux, on other
>   platforms, or even cross-platform), such as:
>     * eBPF arenas, stack improvement, coroutines, improved BTF, etc.
>     * eBPF program signing and supply chain security
>     * Profiling eBPF with eBPF
>     * eBPF-based process schedulers
>     * eBPF in storage devices
>     * eBPF verifier improvements or alternative implementations
>     * eBPF for profiling AI workloads
> * Deep-dives on existing eBPF features
> * Working with eBPF: best practices, common mistakes, debugging, etc.
> * eBPF toolchain, for compiling, managing, debugging, packaging, and
>   deploying eBPF programs and related objects
> * eBPF libraries, in C/C++, Go, Rust, or other languages
> * eBPF in the real world, production use cases and their impact
> * eBPF community efforts (documentation, standardization, cross-platform
>   initiatives)
> 
> The list is not exhaustive, don’t hesitate to submit your proposal!
> 
> Format
> ------
> 
> FOSDEM 2027 will be an in-person event in Brussels, Belgium.
> We do not accept remote presentations.
> (Participants must be able to fund their trip, visa, and accommodation,
> as we do not provide any scholarship or other funding assistance.)
> 
> We’re looking for 20- to 30-minute presentations. The duration should
> include time for questions: allow at least 5 to 10 minutes to answer
> questions from the public.
> 
> Note that due to time constraints, we may end up offering a slot
> duration different than the one requested when submitting. If you have
> specific duration requirements, we encourage you to mention them in your
> proposal.
> 
> You can look at the schedule from previous editions for inspiration, at:
> * https://archive.fosdem.org/2026/schedule/track/ebpf/
> * https://archive.fosdem.org/2025/schedule/track/ebpf/
> 
> How to Submit
> -------------
> 
> Please submit your proposals on Pretalx, FOSDEM’s submissions tool, at
> https://pretalx.fosdem.org/fosdem-2027/cfp
> 
> Make sure to select “eBPF” as the track.
> 
> Code of Conduct
> ---------------
> 
> All participants at FOSDEM are expected to abide by the FOSDEM’s Code of
> Conduct. If your proposal is accepted, you will be required to confirm
> that you accept this Code of Conduct. You can find this code at
> https://fosdem.org/2027/practical/conduct/
> 
> Devroom Organisers
> ------------------
> 
> * Bill Mulligan
> * Daniel Borkmann
> * Dimitar Kanaliev
> * Quentin Monnet
> * Yusheng Zheng
> 
> If you have questions about any aspects of this Call for Participation,
> please email us at ebpf-devroom-manager@fosdem.org, and we will do our
> best to assist you.
> 
> We keep an up-to-date version of this Call for Participation at
> https://ebpf.io/fosdem-2027.html

