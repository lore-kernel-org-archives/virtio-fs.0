Date: Fri, 15 Jan 2021 12:39:13 +0530 (IST)
From: P J P <ppandit@redhat.com>
In-Reply-To: <20210114133424.GA299876@stefanha-x1.localdomain>
Message-ID: <qn527287-65qq-227p-2r48-1528r6rr386@erqung.pbz>
References: <rprnspo3-119s-qnoo-2o93-sn40rq40ns@erqung.pbz>
	<20210114133424.GA299876@stefanha-x1.localdomain>
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

  Hello,

+-- On Thu, 14 Jan 2021, Stefan Hajnoczi wrote --+
| On Thu, Jan 14, 2021 at 02:11:28PM +0530, P J P wrote:
| > Ex. By default offer only read access to guest VM.
| 
| That's not useful. Most users require read-write.

* Agreed. I meant let 'rw' access be user's choice than the default for 
  virtiofsd(1).
 
| The fundamental issue is that the server must be able to create, access, and 
| modify files with arbitrary uids/gids.

* Why arbitrary uids/gids? Once a directory is shared with a guest, its 
  uids/gids would stay same, no?

* We also start separate virtiofsd(1) process for each share/guest too. ie.  
  single virtiofsd(1) daemon is not catering to multiple guests and their
  respective shared directories, right?

| If you have specific ideas, let's discuss them.

* One was to have a command line switch similar to 'qemu -runas <user>'

     $ ./virtiofsd -runas test -o source=...

  If a user wants to run virtiofsd(1) with non-root privileges, it'll be 
  handy.

| https://gitlab.com/virtio-fs/qemu/-/merge_requests/6/diffs?commit_id=718c71fa44f6b92ac27558c903d27935236b08ef

* I'll go through it.


Thank you.
--
Prasad J Pandit / Red Hat Product Security Team
8685 545E B54C 486B C6EB 271E E285 8B5A F050 DE8D

