Date: Thu, 27 Jan 2022 07:41:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
	:to; s=fm3; bh=ZlN7mrAJBZa3ZTkh9yJAXYpS261X1kzfHI1wPKBRifU=; b=i
	awgoJjpDh3ZQdW0pJCmhcKN/bEh1LDrYItmkixI+ZWVs/sb/IuU2XaROWJMF7Qis
	PmonKttZ2yNGgRiJxcmcVgpPMDqoVdJ+1oAuP8JHQVqEsbtJDQJAThAgBRCFo6j8
	wser0unnRzFcnEl0UuYh8I58jsD6yB9A8rlqmpmYHMQmfw6b0o7kKNHVk4xLxNxM
	LsarFzfOKhzz6CBS7rzVrntsnBmGNz482ImUY8SWFzEBdAbMCx0oYR2M5+HR/rUn
	GW/tiEIaz+GonJnAWShyj7TsqTvIBR+Zqvf+5XuRK0C0fCSY+dElan7WKaEM/wTS
	PaqV22k0oaC+6l+xuH9/A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
	:sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; bh=ZlN7mrAJBZa3ZTkh9yJAXYpS261X1
	kzfHI1wPKBRifU=; b=guyLTx5xeOBfpu7bV7i7EooSkROcfnMRI0cqq9f1s8N3v
	sShojgfqUF4UrJAODMZVLet2CRVKREuqQpi1qEz5WdrWAw3GOPj+QdsntpKeRAgW
	Mzk9ArVrnCoFl8PiHxK36vkoLg/2jSzLso0HB5FH7vfh4PHOekGrKeqPe+2jUA9B
	LPxdwAvUnTHr8vdbHqFH3FK2+8HXxg/4zQRU5zPzLjcFxkpAx14iMaxv4a5+3GZa
	yCiTLKigDXXFqhFMjev8vzP9XxjHb1Xa4R/y4A2AheCL08J8j+0aU6HK9ZuOZfHO
	IWptibJkvFonIyJtdQPrpWsnA0Ded4pLXkSeUVg1g==
From: virtiofs-bot@sinrega.org
Message-Id: <61798.122012707410600611@us-mta-90.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd] MR opened: Parent exits with signal
	received by child
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Make the parent process return the child's exit code or the signal
received by the child. Closes #21.
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/80

