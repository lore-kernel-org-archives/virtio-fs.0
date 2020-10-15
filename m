DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=to:references:from:subject:message-id:date:user-agent:mime-version
	:in-reply-to:content-transfer-encoding:content-language;
	bh=NZ9jFMhZgyNB/uNJMB/ss75VZUSyirXEHwwlWjteg5M=;
	b=EtI+PfgXepYMOPpyHZ2IdQk/GH6CBBwr77lvftQStN8hdMPoFixq+/MTVMGDEK8uHC
	lVL9/ki9xSXdR5TKZZcjRglZomkx/RN1haASyV0EWSAQ+NJl08sVpGgls81ipm5jJrjF
	3KThb0AYR1+nno3yZf7l2Tp5w+fNHVEP/h4mvjo32lWPWZPUXZEc/WS6+llX8mwE8w3b
	lrnJmaCSKFtVbL6U38qljA3+sRmuFGSKF8X+Xay0Jk+ozgjqQXb0350q2B+n/4mg+SkM
	jAfhgfWpviXoy4TWePo8WK2CkkXF25QDrn3+h6mTC/DZK4r71ohn8U9uff/jJ3KV0n1q
	e/gw==
References: <20201014180209.49299-1-dgilbert@redhat.com>
	<20201014180209.49299-4-dgilbert@redhat.com>
From: "Harry G. Coin" <hgcoin@gmail.com>
Message-ID: <bd3c072f-dc6c-23a8-cd48-543bafa46363@gmail.com>
Date: Thu, 15 Oct 2020 18:57:09 -0500
MIME-Version: 1.0
In-Reply-To: <20201014180209.49299-4-dgilbert@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] Puzzle about rootflags,
	restorecon "operation not supported"
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

The 'mainline generic' version of the latest kernel fails to parse
'fuse' virtiofs options on root kernel boots.  Not only dax, but all the
'fuse' usual ones as well.  (None of
default_permissions,allow_other,user_id=0 etc are accepted).

Is that what you expected of the mainline kernel?  I learned of this
when trying to understand this further problem:

SELinux's 'restorecon' and other attempts to change security attributes
then fails with "operation not supported".

I could only get sshd able to accept connections by changing SELinux to
permissive.  The commands necessary to change the security attributes
failed with the 'operation not supported' issue.

Ideas?





