# Forked and adapted from geektechstuff by mcx808

FROM fedora:33

RUN \
# dnf installs ansible & the dependencies for kerberos & winRM
dnf -y install \
   ansible \
   gcc \
   python-devel \
   krb5-devel \
   krb5-libs \
   krb5-workstation \
   openssh-client \
   dnsutils && \
   pip install --upgrade pip && \
   pip install pywinrm[kerberos]

# Over rides SSH Hosts Checking
RUN mkdir -p /root/.ssh/ &&\
    echo "host *" >> /root/.ssh/config &&\
    echo "StrictHostKeyChecking no" >> /root/.ssh/config

# Add ansible-galaxy modules for windows management
RUN ansible-galaxy collection install ansible.windows

# Makes a directory for ansible playbooks
RUN mkdir -p /ansible/playbooks
# Makes the playbooks directory the working directory
WORKDIR /ansible/playbooks 

# Sets environment variables
ENV ANSIBLE_GATHERING smart
ENV ANSIBLE_HOST_KEY_CHECKING False
ENV ANSIBLE_RETRY_FILES_ENABLED False
ENV ANSIBLE_ROLES_PATH /ansible/playbooks/roles
ENV ANSIBLE_SSH_PIPELINING True

# Sets entrypoint as bin bash for now so kinit can be used to get kerberos tickets
ENTRYPOINT ["/bin/bash"]

# Sets entry point (same as running ansible-playbook)
#ENTRYPOINT ["ansible-playbook"]
# Can also use ["ansible"] if wanting it to be an ad-hoc command version
#ENTRYPOINT ["ansible"]
