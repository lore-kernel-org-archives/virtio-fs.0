Date: Tue, 18 Jan 2022 02:03:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm3; bh=bAGMj33934tYeuVkwJ2GMvjSoD0MoEC5sLCIH
	QpjCBw=; b=zZTb293Q7PSRQjMuyHF0xJ+jOf9PW/LvQpzqGF4tuLXaPZF6ghOvv
	oeFqFp0Dkc9PJGyrTHDccuWy2Nq0aGEfZQF2hD4bnSUzWGy4Egn69m6Pqy3eoQaH
	03qzh8E+pdKw7WJg7YGgJbSj4ngD3qPT14fhLgW+mFG33Izqc4N8EOP1JOeej38I
	L4OgyMxojc1fDvOLNMM1IXfGuvAG2lzt3BcYzoMBwZF0E7exHJQ0UDDoJ5qyJTJ3
	6iebESC0HZNQVothWhMwJ5lw1IUZW3QUh+mfE+gHlKZML3qGiDhtQpOgK30FaVG3
	04vO9uQLeD8GJ1BpatclSpl2hrZuW/FiA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=bAGMj33934tYeuVkw
	J2GMvjSoD0MoEC5sLCIHQpjCBw=; b=WS1/jlf9lpeoa8uOd3jIGFzb5nJjvbvYM
	LZxxF2NPAnb+9dapQq1I8s6ctmFj5RjFwSED6Bwt778DN1d6H2LkcLgGL3XEu6Nb
	tC3zQUCmND0VSdzABaUl95BQADUXUP8s8dgQv80gy088PnrHNjfmrb5YDWGclTXR
	/MeWRtoxEhK2KcsUI3RTq1EeZb9S69RmmwLG8s3O+08V1OjtyWHW+YYGgtS1ErpZ
	DwrergHmXz5Wng1kUlvOQBcYCjknHhvjMorZfpH/to/rVzPDMbe1ZrN0NCslNfS0
	leie98VjzzjNsDzkZpvFuLKYmc6QnvC/Tb7R6f6xfYUtvBf1yGV0A==
From: virtiofs-bot@sinrega.org
Message-Id: <00856.122011802033300726@us-mta-636.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] Issue closed: Propagate exit code from
	child to parent
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

When running in a sandbox, propagate exit code from child to parent.
---
https://gitlab.com/virtio-fs/virtiofsd/-/issues/10

