Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm3; t=1657174093; x=1657260493; bh=29iIEq9Ayh7xJN5qCpGl9
 Jf8W/c0mjkU+deF9hXAevI=; b=aQ5P8EgfkyrxgnerKvmaPIRGxNHTXUL3/Xk/9
 vXqTJEbIhMvazC1a08uR6y1bGerVTZVd0UqnCW6IQIbkNGRfAx0Ufkkp3GiNM+Qp
 iAg8FTAj8luqchbs8gjoJUzcF8FkUPDk2byy8r0OojRDYlvzogEiaICWLQ6Rm24g
 5I9y1gix8YAZnUujlCnWeeAJ/aDX57qx2mBJdPPwTi2tPmtcYHRO2WUt+r99EjWU
 mxUOhry+vFqxhkvxvlusDeUSKhNwV7Gq+rbapi3lcZ3NSvaXVHAHJKz4XjfPAgBr
 N3JcilblHPeOujgXDNiNlUwW4edPy+D6nqYMtO0GOX+ti3bvA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
 1657174093; x=1657260493; bh=29iIEq9Ayh7xJN5qCpGl9Jf8W/c0mjkU+de
 F9hXAevI=; b=rBEXtd6hrZoYUPf8xGBn+iDrkQ/7xT2J8eJKiErrZvSp4i0C0Yy
 kXIN3cESBd+Wo0f2mEi0jU/RPnJu0N3o7mcUxRhdIaE2r20qg8zAe2134l5j7zTE
 0Vl4Mlpd5Cjsm/KzbwCAOAoDd9wZJY6UeIwAMoAce+cgmr9wGPmpAV9SVGfy/K/5
 q+9qpUSDvfdk3819RkeHFPBMSsYu4B4nH4rTTjJdBDfsvaG2SR3yPurb1/NVkCGj
 5+K0c+uFAbXPfqUEiRsqoQBoefhvdTphtNWQmSmaET8VOMfoOyhxvj3FJ8n+Otbs
 ryZ5FwO3OQsHEwrAiceeHr8WGNxZTKpDCIQ==
From: virtiofs-bot@sinrega.org
Message-Id: <65675.122070702081300201@us-mta-22.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Thu,  7 Jul 2022 06:08:27 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR opened: Update virtio-queue and
 vhost-user-backend deps
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

There are new releases of virtio-queue (0.4.0) and
vhost-user-backend (0.5.0), update our dependencies to use them.

This time, the API has stayed stable and we don't need any other
changes than bumping their versions in Cargo.toml.

Signed-off-by: Sergio Lopez <slp@redhat.com>
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/126

