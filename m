Return-Path: <liuyd.fnst@fujitsu.com>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
 d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
 t=1650536752; x=1682072752;
 h=from:to:cc:subject:date:message-id:references:
 in-reply-to:content-id:content-transfer-encoding: mime-version;
 bh=51azZlq7cPaCIZ3J3rjE0QPls2aljrD8UT0PzO1xyPA=;
 b=fTpAYo4q6czzHFP9fATo8121hM1/wc7mYGriPSgyue4gzHzOvpkBP4MI
 TSXdWyvmh5FP/IwcnTWLLjhn5hD1M2Krpey5k2nFyQTNhEhB/H1vl2JJG
 0o/5QTrMthX80nWCWLsOBMJcoMARFkjv5UE9QoIJZT6cr1McSmvppkQWl
 Jpzh+5Zxy9hg3Q548HmPT06tCmT0BpZlKUAjjvtzSbschKzU+EVaCKdvD
 sgc0ZQ3woJgR9UKgTYKlHApiAEX1ROXWKwg0VGbxak+Id7oG8KjWXTudJ
 RLMngMJjk+y6lktv/t9v43QE9vTE85rf8nThONR3rsSNMpYTTdzKFElAK w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fujitsu.onmicrosoft.com; s=selector2-fujitsu-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=51azZlq7cPaCIZ3J3rjE0QPls2aljrD8UT0PzO1xyPA=;
 b=LPCRqxycUqZxIxHZ1dNWko9zgrY9yQW3l/wo5AB+XU9tuUhuGbjlc3x/Se2lOZ1+KVREAav/eniJLB6d5dcOoVOZVcI6PyIvBAt38mjbrZ2B2w9HXxAX71lICFbUTbeA6okM7WfLPH+Cvosc7DG7/yxWftel4kl2qbSHhXcbOgI=
From: "liuyd.fnst@fujitsu.com" <liuyd.fnst@fujitsu.com>
Date: Thu, 21 Apr 2022 10:24:42 +0000
Message-ID: <f03b52d2-8d3f-6caf-8983-cb0773172838@fujitsu.com>
References: <20220413042054.1484640-1-liuyd.fnst@fujitsu.com>
 <YlgRRcgIbbE+ZKb7@redhat.com>
In-Reply-To: <YlgRRcgIbbE+ZKb7@redhat.com>
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <35F41BAA4562964996D38C6F4893648B@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
Subject: Re: [Virtio-fs] [PATCH] docs: Correct the default thread-pool-size
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, Vivek Goyal <vgoyal@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, "virtio-fs@redhat.com" <virtio-fs@redhat.com>

SGksIFN0ZWZhbg0KDQpQbGVhc2UgaGVscCByZXZpZXcgaXQuIEknbSBzb3JyeSB0aGF0IEkgZm9y
Z290IHRvIGFkZCB5b3UgdG8gdGhlIA0KcmVjaXBpZW50IPCfmIUNCg0KT24gNC8xNC8yMiA4OjE5
IFBNLCBWaXZlayBHb3lhbCB3cm90ZToNCj4gT24gV2VkLCBBcHIgMTMsIDIwMjIgYXQgMTI6MjA6
NTRQTSArMDgwMCwgTGl1IFlpZGluZyB3cm90ZToNCj4+IFJlZmVyIHRvIDI2ZWMxOTA5NjQgdmly
dGlvZnNkOiBEbyBub3QgdXNlIGEgdGhyZWFkIHBvb2wgYnkgZGVmYXVsdA0KPj4NCj4+IFNpZ25l
ZC1vZmYtYnk6IExpdSBZaWRpbmcgPGxpdXlkLmZuc3RAZnVqaXRzdS5jb20+DQo+IExvb2tzIGdv
b2QuIE91ciBkZWZhdWx0IHVzZWQgdG8gYmUgLS10aHJlYWQtcG9vbC1zaXplPTY0LiBCdXQgd2Ug
Y2hhbmdlZA0KPiBpdCB0byB1c2luZyBubyB0aHJlYWQgcG9vbCBiZWNhdXNlIG9uIGxvd2VyIGVu
ZCBvZiB3b3JrbG9hZHMgaXQgcGVyZm9ybWVkDQo+IGJldHRlci4gV2hlbiBtdWx0aXBsZSB0aHJl
YWRzIGFyZSBkb2luZyBwYXJhbGxlbCBJL08gdGhlbiwgdGhyZWFkIHBvb2wNCj4gaGVscHMuIFNv
IHBlb3BsZSB3aG8gd2FudCB0byBkbyBsb3RzIG9mIHBhcmFsbGVsIEkvTyBzaG91bGQgbWFudWFs
bHkNCj4gZW5hYmxlIHRocmVhZCBwb29sLg0KPg0KPiBBY2tlZC1ieTogVml2ZWsgR295YWwgPHZn
b3lhbEByZWRoYXQuY29tPg0KPg0KPiBWaXZlaw0KPj4gLS0tDQo+PiAgIGRvY3MvdG9vbHMvdmly
dGlvZnNkLnJzdCB8IDIgKy0NCj4+ICAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAx
IGRlbGV0aW9uKC0pDQo+Pg0KPj4gZGlmZiAtLWdpdCBhL2RvY3MvdG9vbHMvdmlydGlvZnNkLnJz
dCBiL2RvY3MvdG9vbHMvdmlydGlvZnNkLnJzdA0KPj4gaW5kZXggMGMwNTYwMjAzYy4uMzNmZWQw
OGM2ZiAxMDA2NDQNCj4+IC0tLSBhL2RvY3MvdG9vbHMvdmlydGlvZnNkLnJzdA0KPj4gKysrIGIv
ZG9jcy90b29scy92aXJ0aW9mc2QucnN0DQo+PiBAQCAtMTI3LDcgKzEyNyw3IEBAIE9wdGlvbnMN
Cj4+ICAgLi4gb3B0aW9uOjogLS10aHJlYWQtcG9vbC1zaXplPU5VTQ0KPj4gICANCj4+ICAgICBS
ZXN0cmljdCB0aGUgbnVtYmVyIG9mIHdvcmtlciB0aHJlYWRzIHBlciByZXF1ZXN0IHF1ZXVlIHRv
IE5VTS4gIFRoZSBkZWZhdWx0DQo+PiAtICBpcyA2NC4NCj4+ICsgIGlzIDAuDQo+PiAgIA0KPj4g
ICAuLiBvcHRpb246OiAtLWNhY2hlPW5vbmV8YXV0b3xhbHdheXMNCj4+ICAgDQo+PiAtLSANCj4+
IDIuMzEuMQ0KPj4NCj4+DQo+Pg0KPj4NCi0tIA0KQmVzdCBSZWdhcmRzLg0KWWlkaW5nIExpdQ0K

