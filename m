Return-Path: <jag.raman@oracle.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com;
 h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=il13Gr2KWiBgO5Sz5phkPhCmvWTAlJUOnYfu2ei8n6g=;
 b=IefNrcbHkKW1OMvlFVW8EIhWVw96H0Y66lMt0pOgFHDczI2pnk8t4rd24pqGEyDtKeq2
 p90/pGar3DEI1ptOFeyPlW3L0nBEFBrLFHflT65+Yoqm1KIxthSOggp3RJFGayrJzHr3
 Y6uj2gfdx15jjFiQZ210mX6WouzpU/WQy+mYR3SnonYfPJnmlGHe7De94yD9sTHTCgpS
 9XxfoQUxSJNAo/PDtuv02HbU4T94QzksKkX4JshlmLI8iqTHCmbIW4naa1X/SYY4DCds
 6eIAlrVLOtFPZRjPhqg252brC++STJVBwRir3CBff5i3yVhB5/KG/PTfNb2NJGxEdS5k JQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=il13Gr2KWiBgO5Sz5phkPhCmvWTAlJUOnYfu2ei8n6g=;
 b=koEtYvQlCVtiHWzzhgTntwSoFsXiHtfwhXuqr1MuI4obo93J3c+BCj+w6+BmTD10gTPw+L39jsf+nXC1xDLsyk8m2Li0mW23z5192S9ELPMaxAHARiKuTAtk3jFarUw19FEOpfPfLER0r85xvKyLb5ZT20vKgEXe+dEinFLXOa8=
From: Jag Raman <jag.raman@oracle.com>
Date: Mon, 25 Jul 2022 15:00:30 +0000
Message-ID: <3D94C789-5F97-4104-8730-02BBA6DF94C0@oracle.com>
References: <20220615155129.1025811-1-stefanha@redhat.com>
 <20220615155129.1025811-7-stefanha@redhat.com> <Ytkpiao5Zk8Pj5Lq@redhat.com>
 <97E1536C-58CF-4DDD-94C9-D44EF63C5AA5@oracle.com>
 <Yt6tzDw0R/UZL3NF@redhat.com>
In-Reply-To: <Yt6tzDw0R/UZL3NF@redhat.com>
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <71796D7130DC7246AA0925F4DBF30CE6@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Subject: Re: [Virtio-fs] [PULL 06/18] vfio-user: build library
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: =?utf-8?B?RGFuaWVsIFAuIEJlcnJhbmfDqQ==?= <berrange@redhat.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, qemu-devel <qemu-devel@nongnu.org>, Thomas Huth <thuth@redhat.com>, Aarushi Mehta <mehta.aaru20@gmail.com>, =?utf-8?B?UGhpbGlwcGUgTWF0aGlldS1EYXVkw6k=?= <f4bug@amsat.org>, Elena Ufimtseva <elena.ufimtseva@oracle.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, Laurent Vivier <lvivier@redhat.com>, "qemu-block@nongnu.org" <qemu-block@nongnu.org>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Richard Henderson <richard.henderson@linaro.org>, "virtio-fs@redhat.com" <virtio-fs@redhat.com>, Hanna Reitz <hreitz@redhat.com>, David Hildenbrand <david@redhat.com>, =?utf-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, Eric Blake <eblake@redhat.com>, Kevin Wolf <kwolf@redhat.com>, Beraldo Leal <bleal@redhat.com>, Peter Xu <peterx@redhat.com>, Eduardo Habkost <eduardo@habkost.net>, Qiuhao Li <Qiuhao.Li@outlook.com>, Paolo Bonzini <pbonzini@redhat.com>, Markus Armbruster <armbru@redhat.com>, Bandan Das <bsd@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>, Alexander Bulekov <alxndr@bu.edu>, Julia Suvorova <jusual@redhat.com>, Darren Kenny <darren.kenny@oracle.com>, Wainer dos Santos Moschetta <wainersm@redhat.com>, John Johnson <john.g.johnson@oracle.com>

DQoNCj4gT24gSnVsIDI1LCAyMDIyLCBhdCAxMDo1MCBBTSwgRGFuaWVsIFAuIEJlcnJhbmfDqSA8
YmVycmFuZ2VAcmVkaGF0LmNvbT4gd3JvdGU6DQo+IA0KPiBPbiBNb24sIEp1bCAyNSwgMjAyMiBh
dCAwMjo0NTowOVBNICswMDAwLCBKYWcgUmFtYW4gd3JvdGU6DQo+PiBIaSBEYW5pZWwsDQo+PiAN
Cj4+IFdl4oCZdmUgY3JlYXRlZCB0aGUgZm9sbG93aW5nIGlzc3VlIHRvIHVwZGF0ZSBRRU1V4oCZ
cyBsaWJ2ZmlvLXVzZXIgbWlycm9yDQo+PiB0byB0aGUgbGF0ZXN0Og0KPj4gaHR0cHM6Ly9naXRs
YWIuY29tL3FlbXUtcHJvamVjdC9saWJ2ZmlvLXVzZXIvLS9pc3N1ZXMvMQ0KPj4gDQo+PiBXaWxs
IHVwZGF0ZSBRRU1V4oCZcyBzdWJtb2R1bGUgb25jZSB0aGlzIG1pcnJvciBpcyB1cGRhdGVkLg0K
PiANCj4gVGhhdCBzb3VuZHMgZ29vZCwgdGhhbmsgeW91LiBXZSBzaG91bGQgYmUgZmluZSB0byBn
ZXQgdGhlDQo+IHN1Ym1vZHVsZSByZWVmcmVzaGVkIGV2ZW4gaW4gc29mdCBmcmVlemUsIGdpdmVu
IHRoYXQgaXQgaXMNCj4gZml4aW5nIGEgdGVzdCBmYWlsdXJlIGJ1Zy4NCj4gDQo+IE9oIGFuZCBJ
IGp1c3Qgbm90aWNlZCBJIG1lc3NlZCB1cCB5b3VyIG5hbWUgaW4gbXkgbWVzc2FnZQ0KPiBiZWxv
dy4gSSdtIHZlcnkgc29ycnkgYWJvdXQgdGhhdC4NCg0KTm8gd29ycmllcy4gOikNCg0KPiANCj4g
V2l0aCByZWdhcmRzLA0KPiBEYW5pZWwgDQo+IA0KPj4gT24gSnVsIDIxLCAyMDIyLCBhdCA2OjI1
IEFNLCBEYW5pZWwgUC4gQmVycmFuZ8OpIDxiZXJyYW5nZUByZWRoYXQuY29tPG1haWx0bzpiZXJy
YW5nZUByZWRoYXQuY29tPj4gd3JvdGU6DQo+PiANCj4+IEhpIEpheSAvIFN0ZWZhbiwNCj4+IA0K
Pj4gV2UndmUgZ290IGEgbm9uLWRldGVybWluc2l0aWMgaGFuZyBpbiBRRU1VIENJIHNpbmNlIHRo
aXMgc2VyaWVzDQo+PiBtZXJnZWQsIHdoaWNoIHdlIHRyYWNrZWQgZG93biB0byBhIGxpYnZmaW8t
dXNlciB0ZXN0IHRoYXQgaXMNCj4+IGZsYWtleToNCj4+IA0KPj4gaHR0cHM6Ly9naXRsYWIuY29t
L3FlbXUtcHJvamVjdC9xZW11Ly0vaXNzdWVzLzExMTQNCj4+IA0KPj4gSm9obiBMZXZvbiBoYXMg
cHJvcG9zZWQgYSBQUiB0byBsaWJ2ZmlvLXVzZXIgdG8gdHVybiBvZmYgdGhlDQo+PiB0ZXN0LCBi
dXQgd2UnbGwgbmVlZCBvbmUgb2YgeW91IHRvIHVwZGF0ZSB0aGUgZ2l0IHN1Ym1vZHVsZQ0KPj4g
Zm9yIGxpYnZmaW8tdXNlciBvbiB0aGUgUUVNVSBzaWRlLCBhcyBJIGNhbid0IGZpbmQgYSBuaWNl
IHdheQ0KPj4gdG8gc2VsZWN0aXZlbHkgc2tpcCB0aGUgdGVzdCBmcm9tIFFFTVUgc2lkZSBhbG9u
ZS4NCj4+IA0KPj4gV2l0aCByZWdhcmRzDQo+PiBEYW5pZWwNCj4+IA0KPiANCj4gV2l0aCByZWdh
cmRzLA0KPiBEYW5pZWwNCj4gLS0gDQo+IHw6IGh0dHBzOi8vYmVycmFuZ2UuY29tICAgICAgLW8t
ICAgIGh0dHBzOi8vd3d3LmZsaWNrci5jb20vcGhvdG9zL2RiZXJyYW5nZSA6fA0KPiB8OiBodHRw
czovL2xpYnZpcnQub3JnICAgICAgICAgLW8tICAgICAgICAgICAgaHR0cHM6Ly9mc3RvcDEzOC5i
ZXJyYW5nZS5jb20gOnwNCj4gfDogaHR0cHM6Ly9lbnRhbmdsZS1waG90by5vcmcgICAgLW8tICAg
IGh0dHBzOi8vd3d3Lmluc3RhZ3JhbS5jb20vZGJlcnJhbmdlIDp8DQo+IA0KDQo=

