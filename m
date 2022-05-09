Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm1; t=1652089580; x=1652175980; bh=a61E4znYOnXKt1M6WZYJz
 d/Pxwqd1UoUn7+UesWg0ZE=; b=EtB8+kHCLaGwJH5lU3a5iwtxCOTacdoVxN5h1
 gz+izvbop0wAtFCifuPIUPaH5Khso1/JOsegbZj7IysYK8cQl/LWGkd2j55fJIBo
 QkRz4DHkcHQXc9xJrSNhczgX8VOXgwzjPwv1NBbnpFU6piME5ZhD0Fc764LWQl11
 GYgZA9o+gNz6o9Kg8aYaNhi2nR7yOxKn2GafGRtxU+LzbMWPKcLG11q56TDi6Dmv
 mOuEMmyNlI/sb6eQSiEg8oZ5d783/arCE3VJ8RbdsmBNUSuEdyzmOL9yfL4YTGNb
 3sDby6JDu9riruAGMp5xlRyxJus4+Ez1a1d9ijilUHQTVkX3g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:from:from:in-reply-to:reply-to
 :sender:subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
 :x-me-sender:x-sasl-enc; s=fm1; t=1652089580; x=1652175980; bh=a
 61E4znYOnXKt1M6WZYJzd/Pxwqd1UoUn7+UesWg0ZE=; b=gehB2kdj1sqoH6I9y
 908cWkUhYOrq0RLA136iXMMLWp069+OcxHuZOXgeJ558N+mhODhLeYE+wA/7TzyW
 VN6Xf4cI4IYq5wTtUqKBEkYIv0P6rMYOEPsOtTBh7BUHmmu+KsDvFb4ztC0fd608
 ZzdNpOtL8HEdcvKUUEazaMny6QahHfd47P+wAjS/LSzdXa5OG3BsBgjqDxcQD3YD
 l7OZqub/ZAoVXrMHHIDEwksOmRNOcgCFyaS/MnDNN3E8AgDnPUsY5Mydl0eH/QbN
 +IrgoaIYoLvXnabuWhT6T3a5iYqkOK/przpf8LUbk3ctPDDKWD8ETeV3228W/Ia6
 9kfHw==
From: virtiofs-bot@sinrega.org
Message-Id: <16757.122050905462201062@us-mta-517.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Mon,  9 May 2022 09:46:24 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] MR merged: Switch to building statically
 linked binaries for publishing
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Switch to building statically linked binaries for publishing
---
https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/106

