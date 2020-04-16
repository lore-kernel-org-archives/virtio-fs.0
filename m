From: Stefan Hajnoczi <stefanha@redhat.com>
Date: Thu, 16 Apr 2020 17:49:05 +0100
Message-Id: <20200416164907.244868-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Subject: [Virtio-fs] [PATCH 0/2] virtiofsd: drop Linux capabilities(7)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: virtio-fs@redhat.com, Vivek Goyal <vgoyal@redhat.com>

dmlydGlvZnNkIGRvZXNuJ3QgbmVlZCBvZiBhbGwgTGludXggY2FwYWJpbGl0aWVzKDcpIGF2YWls
YWJsZSB0byByb290LiAgS2VlcCBhCndoaXRlbGlzdGVkIHNldCBvZiBjYXBhYmlsaXRpZXMgdGhh
dCB3ZSByZXF1aXJlLiAgVGhpcyBpbXByb3ZlcyBzZWN1cml0eSBpbgpjYXNlIHZpcnRpb2ZzZCBp
cyBjb21wcm9taXNlZCBieSBtYWtpbmcgaXQgaGFyZCBmb3IgYW4gYXR0YWNrZXIgdG8gZ2FpbiBm
dXJ0aGVyCmFjY2VzcyB0byB0aGUgc3lzdGVtLgoKU3RlZmFuIEhham5vY3ppICgyKToKICB2aXJ0
aW9mc2Q6IG9ubHkgcmV0YWluIGZpbGUgc3lzdGVtIGNhcGFiaWxpdGllcwogIHZpcnRpb2ZzZDog
ZHJvcCBhbGwgY2FwYWJpbGl0aWVzIGluIHRoZSB3YWl0IHBhcmVudCBwcm9jZXNzCgogdG9vbHMv
dmlydGlvZnNkL3Bhc3N0aHJvdWdoX2xsLmMgfCA1MSArKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKwogMSBmaWxlIGNoYW5nZWQsIDUxIGluc2VydGlvbnMoKykKCi0tIAoyLjI1LjEKCg==

