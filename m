DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netapp.com;
	s=selector1;
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
	bh=OexTS8EGUSkZLqIY5gcZnoJtuadjUMryrxY6nalvpDc=;
	b=QQqUSdAlXrGXtFlYCYoSeSvfzeM6KN3U9fcBeVGNFr2ilgQw79ZuB2QcZC/13wTjOMZPhFQxKCep9b7S6Nw3cC5YUvgz4mulj/u6n0cJbVLz8n9wAEir9O9YbKA2gIWFWi0OhKgggSXW5tUDLYM86jFHRUi9ZlIW7EcAbqa05eN4ZSNA7uxvwJzAN1+7nAkNyvpz+0vZHBSsj9HvqSAwLzdOM04yGnN+k1q77cPSChVztE7zMFI9Kg/26ZY3FVbAjeMM8NwPsXh3eSutxtAdq6wdKJ7JBupkDY01pEyuOA81Fy9o1K8mLjwK+IZGf8ppGyiC+34TbF+77Fzv0XTFGA==
From: "Ge, Xiongzi" <Xiongzi.Ge@netapp.com>
Date: Tue, 23 Mar 2021 01:35:58 +0000
Message-ID: <714BD741-AE3F-4BC5-8DFB-F5C74A8623B1@netapp.com>
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <F6C655B994629848A0F1ADABE6C1091A@namprd06.prod.outlook.com>
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] Live migration support for virtio-fs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "virtio-fs@redhat.com" <virtio-fs@redhat.com>

Hello Vivek, Dr. Gilbert, and the virtio-fs team,

It seems that virtio-fs does not support live migration. Once a vm is configured with virtio-fs, live migration cannot be performed even it is not mounted on the guest. Is there any progress for this? If the shared directory is from a distributed file system like Ceph, would it be easier than the general case to be implemented? 

Thanks,
Xiongzi



