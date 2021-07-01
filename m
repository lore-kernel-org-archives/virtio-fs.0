DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=to:cc:references:from:subject:message-id:date:user-agent
	:mime-version:in-reply-to:content-transfer-encoding:content-language;
	bh=KMzRFLn342aRAs5Y7mXjGWoHLdf+TBmPiPg7MEqy6gg=;
	b=sogbVjzhmB6pLWUqbNKwMi3ZF5uOTZ39mCSc/fgaKMd334tB9ck3W0muPQiS7l4vif
	KK4DMdK3KdW0pQ+Wh9zbVFoib0S17/Ad/JJTgbMnG4hgK0ctb9GWY21UI49EE6wl23EH
	NnrTm85ggvht5UgzesRuc6sXnqcP+bp2kRvWxvTmE+dDNZferlPSTG0R5X8bC7HMUL5k
	q0j8v+XC2uxFizTNWX8OJJ/xI/NPiPLpX4jd4C+VREdsB5r2WQ8vRpLdphr3YRqDZq90
	JeRCAe+IWK1PMEm82A5+uJxybt6Ai6u7q4cfgj5LC01UcQk93/+Etg84p/nEwX92yCDi
	WQSQ==
References: <492294b2-b305-86f4-2c91-a2faa766d2ee@gmail.com>
	<YN195pPX2s0PRDqK@work-vm>
From: "Harry G. Coin" <hgcoin@gmail.com>
Message-ID: <14273048-d01f-6b7b-3094-787b79cb4a96@gmail.com>
Date: Thu, 1 Jul 2021 10:02:27 -0500
MIME-Version: 1.0
In-Reply-To: <YN195pPX2s0PRDqK@work-vm>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] multiple virtiofsd's + overlapping shared subtree
 -> enforced compatible xattr maps?
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com


On 7/1/21 3:33 AM, Dr. David Alan Gilbert wrote:
> * Harry G. Coin (hgcoin@gmail.com) wrote:
>> If two or more instances of virtiofsd have a common full or partially
>> shared directory tree path -- how will those instances 'enforce' a
>> 'compatible' xattr map lest the host+guest(s) have quite the selinux
>> attribute salad?
> Virtiofsd instances are independent; it's upto whatever runs the daemons
> to pick the options in a sane way.

While that's the current case, because the intention was to rely on the
underlying fs to manage contention among virtiofsds: the moment
xattrmaps happened virtiofsd entered the layer all network file system
daemons face.  Roughly speaking: a shift from one process per client to
some IPC or threaded approach with a 'manager' process/thread that
coordinates 'compatible' xattrmaps, acl maps, 'root squashing' etc. etc..

>>   How much does virtiofsd need to feel like nfsd...?
> What does nfsd do for this?

A couple attempts over the last decade, the most landed in 5.9: 
https://www.phoronix.com/scan.php?page=news_item&px=Linux-5.9-NFS-Server-User-Xattr







