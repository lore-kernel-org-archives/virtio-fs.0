Date: Tue, 19 Jan 2021 20:04:29 +0530 (IST)
From: P J P <ppandit@redhat.com>
In-Reply-To: <20210118165541.GD255498@stefanha-x1.localdomain>
Message-ID: <9qo964n3-7p75-7992-7s7p-3srrs4q650n@erqung.pbz>
References: <rprnspo3-119s-qnoo-2o93-sn40rq40ns@erqung.pbz>
	<20210114133424.GA299876@stefanha-x1.localdomain>
	<qn527287-65qq-227p-2r48-1528r6rr386@erqung.pbz>
	<20210118165541.GD255498@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: Re: [Virtio-fs] [RFC] About non-root virtiofsd(1) process
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com

+-- On Mon, 18 Jan 2021, Stefan Hajnoczi wrote --+
| Guest applications may run with different uids/gids. The host has no control 
| over that.
| 
| Imagine booting a guest form a virtio-fs root file system and installing 
| packages. The guest must be able to control uids/gids for that to work.

* I see; I'll try to better understand how it's done.

* With UID namespaces, I thought virtiofsd(1) would be able to operate files 
  with arbitrary uid/gid, even after dropping its root privileges to acquire 
  non-root privileges on the host; Because it has 'root' privileges under the 
  shared directory & UID namespace.

| > $ ./virtiofsd -runas test -o source=...
| 
| Patches for this are welcome.

* Okay, will try.

Thank you.
--
Prasad J Pandit / Red Hat Product Security Team
8685 545E B54C 486B C6EB 271E E285 8B5A F050 DE8D

