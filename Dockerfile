FROM debian:buster-slim

# installing dependencies 
RUN set -ex; \
	if ! command -v gpg > /dev/null; then \
		apt-get update; \
		apt-get install -y  \
        wget \
        apt-transport-https \
        lsb-release \
        gnupg2 \
		; \
	fi

# explicitly set user/group IDs
RUN set -eux; \
	groupadd -r enterprisedb --gid=999; \
	useradd -r -g enterprisedb --uid=999 --home-dir=/var/lib/edb-as --shell=/bin/bash enterprisedb; \
# also create the enterprisedb user's home directory with appropriate permissions
	mkdir -p /var/lib/edb-as; \
	chown -R enterprisedb:enterprisedb /var/lib/edb-as

VOLUME ["/var/lib/edb-as/13/main", "/etc/edb-as/13/main"]

COPY entrypoint.sh /entrypoint.sh

EXPOSE 5444

ENTRYPOINT ["sh", "/entrypoint.sh"]