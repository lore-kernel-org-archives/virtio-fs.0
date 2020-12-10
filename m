DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=subject:to:cc:references:from:message-id:date:user-agent
	:mime-version:in-reply-to:content-transfer-encoding:content-language;
	bh=KeCVqZm2/0dGy8P7zNg3fjvGxxoUT3rvXtKbkGpsypE=;
	b=sqEmBHpJThlmvLn3rNj/0SrsZP2/MHHJ33Wsd9py2X9yLKI54ejbQm3F9Uh6rPaMOn
	364wcbyNQwUI7DSxCPID7HQMBHlj/p0XcIo3NtT2AQ1gfMg59bF0/iHrzB5rvikob3h0
	EgKhMtN/MabgLcoxdcHGBjUjwneXSlMeN4AJk+80vFhHONvl4l5e+2wdsnOjD8ygNvUA
	0DSB7ArYoRlUhssDf66/PmXKPajUChSKRCOqHxljbp1CIsPk+erMR3nKDMCi5DoMR9cF
	8Efg5bqvurcr9uD8mMOf5zXoAa4Uwkl192rwBZYiFf+MMFyL3hdRu7iykMUWMY5m+iiQ
	72WA==
References: <20201207183021.22752-1-vgoyal@redhat.com>
	<20201207183021.22752-4-vgoyal@redhat.com>
	<20201210200303.GN3629@work-vm>
	<20201210200931.GA185111@redhat.com>
From: "Harry G. Coin" <hgcoin@gmail.com>
Message-ID: <97a0de57-8422-2fdc-e16e-0d6f133f615c@gmail.com>
Date: Thu, 10 Dec 2020 15:24:14 -0600
MIME-Version: 1.0
In-Reply-To: <20201210200931.GA185111@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Subject: [Virtio-fs] ceph + freeipa ubuntu/fedora common small bug
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, lersek@redhat.com, qemu-devel@nongnu.org

FYI.  Same thing we saw on Fedora installing freeipa, this on ubuntu
with ceph.  Identical bitmask report.

...

Fixing /var/run/ceph ownership....done

Cannot set file attribute for '/var/log/journal', value=0x00800000,
mask=0x00800000, ignoring: Function not implemented

Cannot set file attribute for
'/var/log/journal/fd007229322043ad8778c214d19ed3ac', value=0x00800000,
mask=0x00800000, ignoring: Function not implemented

...

Host has xattrs on, btrfs.



