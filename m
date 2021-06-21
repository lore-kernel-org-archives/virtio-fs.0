DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209;
	h=Content-Transfer-Encoding:MIME-Version:
	Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=Dt1tYSfWAid43wFWr7JNa2FzhmQeXcsREodQskAi2r8=;
	b=mLs7UUmUS/ByLwI8Aed5Zb49le
	0A2x/nG+9AHCfw1rP93d8QW1PVPT9sy3sfgZFIyENtc4khSxaEh9H56aMbTWgF6quSdlIi+B36MGy
	fUhCFOPVfQvxEurlzj+a2RD/FuwP1UvyJ/lCn4devsFpMRxr10QYoJc7A8ZwRCagtjzy2sML5rO26
	kou9gqh/L58tBghIQr+lu8PqyWY06+KJINT1lgI78ck5jqKM5kl5V2m8D/bPe98LMRotkniaN9rym
	9XyC9v3wfBaIFvMHZthZy8NcOzXh3eG15W4Uheg5IpnTKfpIYZ69s8ZK+RN6lQCYMTu/iscL3UnZG
	hP4Y7svg==
From: Christoph Hellwig <hch@lst.de>
Date: Mon, 21 Jun 2021 08:26:55 +0200
Message-Id: <20210621062657.3641879-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] support booting of arbitrary non-blockdevice file
	systems v2
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>

Hi all,

this series adds support to boot off arbitrary non-blockdevice root file
systems, based off an earlier patch from Vivek.

Chances since v1:
 - don't try to mount every registered file system if none is specified
 - fix various null pointer dereferences when certain kernel paramters are
   not set
 - general refactoring.

