Return-Path: <virtiofs-bot@sinrega.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
 cc:date:from:from:in-reply-to:reply-to:sender:subject:subject:to
 :to; s=fm2; t=1655374988; x=1655461388; bh=14YzaxmwaZX0TQTlCcrD9
 R3msa7FrpoJ1SSN4k0Feek=; b=UgbRCOCRfMi6roX/gtMPd+cCan4Oj7131mw6T
 wh+f73/rYZI2PQJk/U3Qy1HKc+hMSdWs07E8kzlm09uP/rCyefhjYceyEHYEezxW
 WgQRB8kzMJm57PVlnhi0FbPhJuRcluldYSXs0US1CRif4T+qURZASd9WCU3sBT9i
 RwS4I/JDpjgceq47vsaFXa6eNI6yRpnMLjrwxd4CveKAWnaEAu1GOBUTp4t0iOv/
 /KOs/Ngxmhbzqk1wbSqRgGpmmUn8A6Pu4Y/dLbhRS6MGE/1CnJ0220DkwJ8ZHSZM
 NaKyw52Mi7r+7mAxP/J3SiS/H9Nn9xhiZA/wEvG1IIbqHVC/g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:date:feedback-id:feedback-id:from:from
 :in-reply-to:reply-to:sender:subject:subject:to:to:x-me-proxy
 :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
 1655374988; x=1655461388; bh=14YzaxmwaZX0TQTlCcrD9R3msa7FrpoJ1SS
 N4k0Feek=; b=hkbzAhqSA0tcXuEb6gkPVMY+JIxBZKNLwXNBsWc54AY1oJh5GYA
 Tby7IeIkGyCtEY3iOSOQAZzDbbMZRzgvoroONIvaajRuUqUJ/Z3F/9TcVF8m6gyO
 QfMxwIZc0qRx+h4Q8nWdNI47Kjgf6qMOWCrhNfsi6zW6HJcYgvMz061bdgszAVDs
 8Eqm6WGgBluyeXQoNJYppGnRjWNQO8EJqwXTpj/5GIyXSqzQh9BYL9LTI1N4YB6e
 Y60ddas3rblw2q05IzzLO2MG9d3hbUUNPvu7aKaOs4CM3nUNFuXZGS5Qw6FPUKUC
 0z+yTne51Wq6Kx+U26/NG60CERgjvSHRrNg==
From: virtiofs-bot@sinrega.org
Message-Id: <11151.122061606231100136@us-mta-8.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Date: Thu, 16 Jun 2022 10:23:13 +0000 (UTC)
Subject: [Virtio-fs] [virtiofsd] Issue opened: Cannot run executables in
 Windows guest
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

When trying to run an executable on the mapped drive, I get "Windows cannot access Z:\something.exe":
![image](https://gitlab.com/virtio-fs/virtiofsd/uploads/7e4aadd7ad761ff0941561dac49d6f03/image.png)

I looks like the drive is mounted with limited permissions.
---
https://gitlab.com/virtio-fs/virtiofsd/-/issues/51

