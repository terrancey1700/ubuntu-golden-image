build:
	packer build packer/ubuntu.pkr.hcl

validate:
	packer validate packer/ubuntu.pkr.hcl

fmt:
	packer fmt packer/ubuntu.pkr.hcl

clean:
	rm -rf output-* packer_cache

ami:
	packer build -only=amazon-ebs packer/ubuntu.pkr.hcl
