Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from lb.pantheon.sk ([46.229.239.20]:53088 "EHLO lb.pantheon.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395421AbfHWPFW (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 23 Aug 2019 11:05:22 -0400
From: =?utf-8?B?SsO6bGl1cyBNaWxhbg==?= <Julius.Milan@pantheon.tech>
Subject: RE: AF_XDP integration with FDio VPP? (Was: Questions about XDP)
Date: Fri, 23 Aug 2019 14:56:33 +0000
Message-ID: <97f984e84a7049bc80cdf6438d1f5f4d@pantheon.tech>
References: <889477ed79c44e6a9395cf961f782209@pantheon.tech>
 <CA+_TK733RPSU=sEqSFpk-La6RNuJJM4m7xsDgOZ-EnaRAwKwKA@mail.gmail.com>
 <20190823102224.16141c87@carbon>
 <87d6d1ccab164292bb050c55f2cd81f8@pantheon.tech>
 <CALDO+SZRLUopFfiP7C2_Q3LRHDMLQ6_BBN=xw+BQ6FQWGFpVQw@mail.gmail.com>
 <c58d5612-052c-cab1-ad9a-0e0e1a838f5b@intel.com>
In-Reply-To: <c58d5612-052c-cab1-ad9a-0e0e1a838f5b@intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>, William Tu <u9012063@gmail.com>, =?utf-8?B?TWFyZWsgWsOhdm9kc2vDvQ==?= <marek.zavodsky@pantheon.tech>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, "Karlsson, Magnus" <magnus.karlsson@intel.com>, Eelco Chaudron <echaudro@redhat.com>, Thomas F Herbert <therbert@redhat.com>

TWFueSB0aGFua3MgZ3V5cywgdmVyeSBhcHByZXRpYXRlZC4NCg0KR29pbmcgdG8gdGFrZSBhIGxv
b2sgYXQgT1ZTIGltcGxlbWVudGF0aW9uLCBidXQgSSB3b3VsZCBsaWtlIHRvIGVuc3VyZSBzb21l
dGhpbmcgYmVmb3JlLg0KDQo+PiBJIHRvb2sgdGhlIF91c2VyIHBhcnQgYW5kIHNwbGl0IGl0IGlu
dG8gdHdvOg0KPj4NCj4+ICJsb2FkZXIiIC0gIEV4ZWN1dGVkIG9uY2UgdG8gc2V0dXAgZW52aXJv
bm1lbnQgYW5kIG9uY2UgdG8gY2xlYW51cCwgbG9hZHMgX2tlcm4ubywgYXR0YWNoZXMgaXQgdG8g
aW50ZXJmYWNlIGFuZCBwaW4gbWFwcyB1bmRlciAvc3lzL2ZzL2JwZi4NCj4+DQo+PiBhbmQNCj4+
DQo+PiAid29ya2VyIiAtIEV4ZWN1dGVkIGFzIG1hbnkgYXMgcmVxdWlyZWQuIEV2ZXJ5IGluc3Rh
bmNlIGxvYWRzIG1hcHMgZnJvbSAvc3lzL2ZzL2JwZiwgY3JlYXRlIG9uZSBBRl9YRFAgc29jaywg
dXBkYXRlIHhza3MgcmVjb3JkIGFuZCBzdGFydCBsaXN0ZW4vcHJvY2VzcyBwYWNrZXRzIGZyb20g
QUZfWERQIChpbiB0ZXN0IHNjZW5hcmlvIHdlIGFyZSB1c2luZyBsMmZ3ZCBiZWNhdXNlIG9mIHdy
aXRlLWJhY2spLiBJIGhhZCB0byBhZGQgbWlzc2luZyBjbGVhbnVwcyB0aGVyZSggY2xvc2UoZmQp
LCBtdW5tYXAoKSkuIFRoaXMgc2hvdWxkIGJlIHZwcCBpbiBmaW5hbCBzb2x1dGlvbi4NCj4+DQo+
PiBTbyBmYXIgc28gZ29vZC4NCj4+DQo+PiBJJ20gdW5hYmxlIHRvIHN0YXJ0IG1vcmUgdGhhbiBv
bmUgd29ya2VyIGR1ZSB0byBwcmV2aW91c2x5IG1lbnRpb25lZCBlcnJvci4gRmlyc3QgaW5zdGFu
Y2Ugd29ya3MgcHJvcGVybHksIGV2ZXJ5IG90aGVyIGZhaWxzIG9uIGJpbmQgKGxpbmVubyBtYXkg
bm90IG1hdGNoIGR1ZSB0byBsb2NhbCBjaGFuZ2VzKToNCj4+DQo+PiB4ZHBzb2NrX3VzZXIuYzp4
c2tfY29uZmlndXJlOjU5NTogQXNzZXJ0aW9uIGZhaWxlZDogYmluZChzZmQsIChzdHJ1Y3Qgc29j
a2FkZHIgKikmc3hkcCwgc2l6ZW9mKHN4ZHApKSA9PSAwOiBlcnJubzogMTYvIkRldmljZSBvciBy
ZXNvdXJjZSBidXN5Ig0KPj4NCj4+DQo+IEkgZG9uJ3QgdGhpbmsgeW91IGNhbiBoYXZlIG11bHRp
cGxlIHRocmVhZHMgYmluZGluZyBvbmUgWFNLLCBzZWUNCj4geHNrX2JpbmQoKSBpbiBrZXJuZWwg
c291cmNlLg0KPiBGb3IgQUZfWERQIGluIE9WUywgd2UgY3JlYXRlIG11bHRpcGxlIFhTS3MsIG5v
bi1zaGFyZWQgdW1lbSBhbmQgZWFjaCANCj4gaGFzIGl0cyB0aHJlYWQuDQoNCkluIE9WUywgY2Fu
IHlvdSBiaW5kIHR3byBzb2NrZXRzIHdpdGggbm9uLXNoYXJlZCB1bWVtIHRvIHRoZSBzYW1lIGlu
dGVyZmFjZT8NCk91ciBnb2FsIGlzIHRvIGhhdmUgMiBvciBtb3JlIHByb2Nlc3NlcyAoVlBQcykg
bGlzdGVuaW5nIG9uIHRoZSBzYW1lIGludGVyZmFjZSB2aWEgWERQIHNvY2tldCwNCndoaWxlIFhE
UCBwcm9ncmFtIGRlY2lkZXMgd2hlcmUgdG8gcmVkaXJlY3QgdGhlIHBhY2tldHMgYXQgdGhlIG1v
bWVudC4NCg0KQmVzdCBSZWdhcmRzDQpKdWxpdXMNCg==
