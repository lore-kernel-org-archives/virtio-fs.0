Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; bh=VgTpdYuRKbaO09MCQPAESi0U9ZAq6W/1PsrYKirF4Tg=; b=q
 vpZtmczYqCxL/Hf7xm9oqUqXpPXluogM+si9j/szDX4+HJgpcFPUid2Zieix+ihk
 ba7aJNmjTwDk0v7gyy9eASKmzOChfHr6Rg+W18IAZd5n+AO91dFe6lpA171U6ndd
 X1Um0eCJnXZl+PHJePNIiWwJH0ZGGuWlQ4vr/qc6JRSzGyk3BlE2Ehnyx6Ald3hQ
 C6Cw9kh28DgX7NhYAja02A4ci83uEP35KXtuIlSw39blw5xp8dhnm708iV1a2NvF
 0H/UpG7LYIvaWj2lWJFjc+f2V/0P0NjSAv5I0IJdZ7eoO6IRTTp+6xTITzf+ci63
 9/aPEr9CD6ZGg7rFNPVDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
 :sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
 :x-me-sender:x-sasl-enc; s=fm2; bh=VgTpdYuRKbaO09MCQPAESi0U9ZAq6
 W/1PsrYKirF4Tg=; b=CJgUeQCA0JAqcSBwQwccDjoP3sNGvSxDLlfTmWq9+jyvd
 zejX7kiWwOReWp/TkNBpiH7oqs1E/X74tkDWfHdW6Hvlf21MD650fQlFvGZrcb8e
 0MPrqJW57jIs5sgsy5vnyrCuOQLplSkvT4sdbtqooiTs4g5lryLAlARkP6l94GOe
 xEeaY7tpI9mTjWXFGCgvtOOdsMgMNXMsu+ZGvYX6iDQipwcHR87lKDemRazXxaYs
 1KaPlHvhDTs7Dc9oXksnPmbYZhXs4RMHmnJJrZn0g2DDXtFIK8Nn5tIr8sScTHwf
 Y0v7n4BNPylXlCyicDYJPwIxJHrBr6IFGzqrLEcHg==
From: virtiofs-bot@sinrega.org
Message-Id: <68701.122031408053300877@us-mta-299.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Date: Mon, 14 Mar 2022 12:05:35 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] Issue closed: --inode-file-handles=fallback
 is misleading
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

`--inode-file-handles=fallback` sounds like inode file handles are used as fallback. However, as far as I know, it's the other way around: with this knob, inode file handles are prefered and O_PATH FDs are used as a fallback. Thus, I think `--inode-file-handles=fallback` should be renamed to `--inode-file-handles=prefer` or something like that.
---
https://gitlab.com/virtio-fs/virtiofsd/-/issues/20

