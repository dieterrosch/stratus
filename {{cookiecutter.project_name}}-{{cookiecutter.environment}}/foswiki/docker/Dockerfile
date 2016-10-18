#
# Debian image that has Foswiki installed from the release tgz
#
# docker build -t svendowideit/foswiki .

FROM debian:jessie
MAINTAINER	Sven Dowideit <SvenDowideit@home.org.au>

RUN apt-get update
RUN apt-get install -yq vim-tiny wget \
		apache2 rcs \
		libalgorithm-diff-perl libarchive-tar-perl libauthen-sasl-perl libcgi-pm-perl libcgi-session-perl libcrypt-passwdmd5-perl libdigest-sha-perl libencode-perl liberror-perl libfile-copy-recursive-perl libhtml-parser-perl libhtml-tree-perl libio-socket-ip-perl libio-socket-ssl-perl libjson-perl liblocale-maketext-perl liblocale-maketext-lexicon-perl liblocale-msgfmt-perl libwww-perl liburi-perl libversion-perl \
		libapache2-mod-fcgid \
		perl-doc

ARG FOSWIKI_VERSION=2.0.3

WORKDIR /var/lib/foswiki
RUN wget http://sourceforge.net/projects/foswiki/files/foswiki/${FOSWIKI_VERSION}/Foswiki-${FOSWIKI_VERSION}.tgz
RUN	tar zxv --strip-components=1 -f Foswiki-${FOSWIKI_VERSION}.tgz 
RUN chown -R www-data:www-data /var/lib/foswiki

ADD foswiki.conf /etc/apache2/sites-enabled/
RUN rm /etc/apache2/sites-enabled/000-default.conf
RUN a2enmod rewrite
RUN a2enmod cgi

RUN ./tools/configure -save -noprompt -set {PubUrlPath}='/pub' -set {ScriptUrlPath}='/bin' -set {DefaultUrlHost}='' \
	&& chown -R www-data:www-data /var/lib/foswiki/lib/LocalSite.cfg

#Create a backup copy of the foswiki site, this will be used to seed the persistent volume in Kubernetes using a lifeCycle postStart hook
WORKDIR /var/lib/foswiki_orig
RUN cp -Rp /var/lib/foswiki/* /var/lib/foswiki_orig/
RUN chown -R www-data:www-data /var/lib/foswiki_orig
ADD seed_initial_contents.sh /var/lib/foswiki_orig/
RUN chmod +x /var/lib/foswiki_orig/seed_initial_contents.sh

#RUN bash -c 'echo "/usr/sbin/apachectl start && tail -f /var/log/apache2/error.log" >> /root/.bashrc'
#RUN bash -c 'echo "/usr/sbin/apachectl -DFOREGROUND" >> /root/.bashrc'
#RUN bash -c 'echo "/var/lib/foswiki_orig/seed_initial_contents.sh" >> /root/.bashrc'
ENTRYPOINT /var/lib/foswiki_orig/seed_initial_contents.sh && /usr/sbin/apachectl -DFOREGROUND

EXPOSE 80


