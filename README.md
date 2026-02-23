# Ubuntu Golden Image
Automated Ubuntu golden image pipeline using Packer, Ansible, and AWS AMI. Builds, hardens, versions, and exports reusable production-ready images.

---

# Executive Summary

## Situation

Modern infrastructure requires consistent, reproducible machine images to eliminate configuration drift and improve deployment reliability.

Initial environment limitations:

- Manual Ubuntu installations

- No standardized base image

- No automated provisioning

- No image versioning

- No reusable cloud artifact

This created inconsistency between systems and slowed infrastructure deployment.

---

## Task

Design and implement a production-style image pipeline that:

- Automates Ubuntu installation

- Uses cloud-init for unattended setup

- Enables SSH access automatically

- Provisions configuration using Ansible

- Performs system hardening and cleanup

- Implements versioned image naming

- Publishes deployable AWS AMIs

- Produces reusable VM artifacts

## Action

### Phase 1 - Automated OS Installation (Packer + VirtualBox)

Built a Packer template using the virtualbox-iso builder to:

- `Boot Ubuntu 24.04 ISO`
- `Inject cloud-init via NoCloud datasource`
- `Perform fully unattended installation`
- `Configure SSH access`
- `Wait for SSH availability before provisioning`

Key features:

- `ISO checksum validation`
- `Automated boot command injection`
- `Cloud-init CD generation using xorriso`
- `Deterministic build configuration`


### Phase 2 - Cloud-Init Autoinstall Configuration

Implemented NoCloud datasource using:

- `meta-data`
- `user-data`

Configured:

- `Hostname`
- `Default user`
- `Hashed password`
- `SSH server installation`
- `Automatic SSH enablement`

Result:

- `Zero manual installer interaction`
- `Reliable unattended OS deployment`

### Phase 3 - Configuration Management (Ansible)

After SSH became available, Ansible executed post-install configuration.

Responsibilities:

- `Package updates`
- `Base configuration`
- `Service validation`
- `System preparation`
- `Production readiness configuration`

Resolved issues including:

- `SSH key handling`
- `Missing sshpass`
- `Home directory permissions`
- `Ansible temporary directory creation`


### Phase 4 - Image Hardening & Cleanup

Implemented production-grade cleanup before image finalization.

Tasks included:

- `apt clean`
- `Remove SSH host keys`
- `Clear /etc/machine-id`
- `Remove cloud-init state`
- `Clear temporary files`

Purpose:

- `Prevent duplicate host keys`
- `Prevent duplicate machine IDs`
- `Ensure new instances regenerate unique identity`
- `Reduce image size`
- `Improve security posture`


### Phase 5 - Clean Shutdown Process

Added controlled shutdown command to avoid forced power-off.

Purpose:

- `Ensure filesystem integrity`
- `Flush disk writes`
- `Prevent corrupted image artifacts`
- `Follow production image build standards`


### Phase 6 - Image Versioning

Implemented timestamp-based naming:

- `ubuntu-golden-{{timestamp}}`

Benefits:

- `Immutable build artifacts`
- `Clear version traceability`
- `Rollback capability`
- `CI/CD compatibility`
- `Safer production promotion workflows`

### Phase 7 - AWS AMI Integration

Configured AWS CLI and IAM credentials.

Selected deployment region:

- `us-east-2 (Ohio)`
- `Extended pipeline to publish AWS-compatible images.`

Result:

- `Deployable EC2 AMIs`
- `Cloud-ready infrastructure images`
- `Repeatable provisioning in AWS`
- `Production-scale deployment capability`


## Architecture Overview

Build pipeline flow:

- `Packer boots Ubuntu ISO`
- `Cloud-init performs unattended installation`
- `SSH becomes available`
- `Ansible provisions configuration`
- `Cleanup and hardening execute`
- `VM shuts down cleanly`
- `VM exported as OVF artifact`
- `Image published to AWS as AMI`


## Problems Encountered & Resolutions

SSH Not Becoming Available

- `Cause: Cloud-init not triggered correctly`
- `Resolution: Switched from HTTP datasource to NoCloud CD`
- `Lesson: Prefer deterministic local datasource for image builds`

Missing ISO Creation Tool

Error:
- `Could not find supported CD ISO creation command`
Resolution:
- `Installed xorriso`
Lesson:
- `Packer requires ISO tooling when generating cloud-init CD images`


## Ansible Authentication Failures

Issues:
- `SSH key errors`
- `Password authentication failure`
- `Missing sshpass`
Resolution:
- `Installed sshpass`
- `Adjusted Ansible provisioner configuration`
- `Verified SSH connectivity manually during debug`

Lesson:
- `Understand how Packer proxies SSH to Ansible`

## Machine Identity Duplication Risk

Risk:
- `Cloned systems sharing SSH keys or machine-id`
Resolution:
- `Explicit cleanup tasks before final shutdown`
Lesson:
- `Golden images must be generalized before reuse`


## Results

After completion:
- `Fully automated Ubuntu golden image pipeline`
- `Versioned image artifacts`
- `Production-grade cleanup and hardening`
- `Reusable VirtualBox artifact`
- `AWS AMI publishing capability`
- `Repeatable infrastructure builds`
- `Deterministic, automation-driven workflow`


## Skills Demonstrated

- `Infrastructure as Code (Packer HCL)`
- `Configuration Management (Ansible)`
- `Cloud-init automation`
- `Linux system administration`
- `AWS AMI workflows`
- `IAM configuration`
- `SSH troubleshooting`
- `Build pipeline design`
- `Image hardening techniques`
- `Layered infrastructure debugging`


## Repository Structure

- `golden-image-factory/`
  - `packer/`
    - `ubuntu.pkr.hcl`
  - `ansible/`
    - `site.yml`
  - `http/`
    - `meta-data`
    - `user-data`
  - `README.md`


## Future Improvements

- `SSH key-only authentication`
- `CIS benchmark hardening role`
- `Automated AMI tagging strategy`
- `GitHub Actions CI/CD integration`
- `Multi-region AMI replication`
- `Proxmox template support`
- `VMware build target`
- `Enterprise-grade security baseline`

## Author

Terrance Young
Aspiring DevOps / Systems Engineer
