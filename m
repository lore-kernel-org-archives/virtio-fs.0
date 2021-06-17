DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209;
	h=Content-Transfer-Encoding:MIME-Version:
	Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=P7kLv1oVP+rhYg9WCt73Sf/4lVoZblgwQfVI0MV7Vnk=;
	b=pU/rzvdZunzXrnpBlSL9c6CMBr
	BtpU5QE4CjRZsy1haF46aBQyBWJcbogZHsI/CRX7I3pn//wRJM12uizbGjvFHZ9rDTGu5zUGanT3c
	r4ePeJdNDThruUeJiU6Ymbh8FNIeKfUUEevpQuhht9a9GXUlrpVL7t4tKMzDzXL2app4BQN405/am
	VLLAI6Rs9l6bEyzB2Z3jQ5kDGegxmdcPufoxK6iD47QVSSnP78NDGtalgLt1nvRY7OycNDklItnNJ
	rfkVcx036pRnY8y2n3QX4SPLH5u99DxNllgbWnkF9v6XjePBJ9o3JO4yBZhRj/7AAn5s511OU9EtO
	jYMm6R1A==
From: Christoph Hellwig <hch@lst.de>
Date: Thu, 17 Jun 2021 17:36:47 +0200
Message-Id: <20210617153649.1886693-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] support booting of arbitrary non-blockdevice file
	systems
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

