PDF_OUTPUTS = syslog-ng-pe-v3.1-guide-admin-en.pdf syslog-ng-windows-agent-v3.1-guide-admin-en.pdf syslog-ng-ibm-agent-guide-admin-en.pdf syslog-ng-sql-whitepaper.pdf
HTML_OUTPUTS = syslog-ng-pe-v3.1-guide-admin-en.html syslog-ng-windows-agent-v3.1-guide-admin-en.html syslog-ng-ibm-agent-guide-admin-en.html syslog-ng-sql-whitepaper.html

MANSOURCES=$(wildcard other/*.[0-9].xml)
MANPAGES=$(subst other/,out/man/,$(subst .xml,,$(MANSOURCES)))

XSLTPROC_MANPAGES=xsltproc --xinclude --output $@  xml-stylesheet/pdf/docbook-xslt/manpages/docbook.xsl $<

all: setup $(PDF_OUTPUTS) $(HTML_OUTPUTS) $(MANPAGES)

setup:
	[ -d xml-stylesheet ] || git clone git+ssh://git.balabit/var/scm/git/docs/xml-stylesheet.git xml-stylesheet 
	[ -d xml-stylesheet ] && (cd xml-stylesheet; git pull)
	[ -d out ] || mkdir out
	[ -d xml-stylesheet ] 
	[ -d xml-stylesheet ] && (cd xml-stylesheet)
	[ -d out ] || mkdir out
	
### entry points for the user

html: $(addsuffix /index.html,$(addprefix out/,$(HTML_OUTPUTS)))

pdf: $(addprefix out/,$(PDF_OUTPUTS))

syslog-ng-pe-v3.1-guide-admin-en.pdf: out/syslog-ng-pe-v3.1-guide-admin-en.pdf

syslog-ng-pe-v3.1-guide-admin-en.html: out/syslog-ng-pe-v3.1-guide-admin-en.html/index.html

syslog-ng-windows-agent-v3.1-guide-admin-en.pdf: out/syslog-ng-windows-agent-v3.1-guide-admin-en.pdf

syslog-ng-windows-agent-v3.1-guide-admin-en.html: out/syslog-ng-windows-agent-v3.1-guide-admin-en.html/index.html

syslog-ng-ibm-agent-guide-admin-en.pdf: out/syslog-ng-ibm-agent-guide-admin-en.pdf

syslog-ng-ibm-agent-guide-admin-en.html: out/syslog-ng-ibm-agent-guide-admin-en.html/index.html

syslog-ng-sql-whitepaper.pdf: out/syslog-ng-sql-whitepaper.pdf

syslog-ng-sql-whitepaper.html: out/syslog-ng-sql-whitepaper.html/index.html

out/syslog-ng-pe-v3.1-guide-admin-en.pdf: syslog-ng-admin-guide/syslog-ng-admin-guide_en.xml syslog-ng-admin-guide/chapters/*.xml
	xml-stylesheet/pdf/process-profile $< $@ syslog-ng
        
out/syslog-ng-pe-v3.1-guide-admin-en.html/index.html: syslog-ng-admin-guide/syslog-ng-admin-guide_en.xml syslog-ng-admin-guide/*.xml syslog-ng-admin-guide/chapters/*.xml
	mkdir out/syslog-ng-pe-v3.1-guide-admin-en.html || /bin/true
	xml-stylesheet/html/process-profile $< $@ syslog-ng
	./copy-pngs.sh out/syslog-ng-pe-v3.1-guide-admin-en.html TRUE
	            
syslog-ng-admin-guide/syslog-ng-admin-guide_en.xml: setup


out/syslog-ng-windows-agent-v3.1-guide-admin-en.pdf: syslog-ng-admin-guide/syslog-ng-windows-agent-guide-en.xml syslog-ng-admin-guide/chapters/*.xml
	xml-stylesheet/pdf/process-profile $< $@ windows-agent
        
out/syslog-ng-windows-agent-v3.1-guide-admin-en.html/index.html: syslog-ng-admin-guide/syslog-ng-windows-agent-guide-en.xml syslog-ng-admin-guide/*.xml syslog-ng-admin-guide/chapters/*.xml
	mkdir out/syslog-ng-windows-agent-v3.1-guide-admin-en.html || /bin/true
	xml-stylesheet/html/process-profile $< $@ windows-agent
	./copy-pngs.sh out/syslog-ng-windows-agent-v3.1-guide-admin-en.html TRUE
	            
syslog-ng-admin-guide/syslog-ng-windows-agent-guide-en.xml: setup


out/syslog-ng-ibm-agent-guide-admin-en.pdf: syslog-ng-admin-guide/syslog-ng-ibm-agent-guide-admin-en.xml syslog-ng-admin-guide/chapters/*.xml
	xml-stylesheet/pdf/process-profile $< $@ ibm-agent
        
out/syslog-ng-ibm-agent-guide-admin-en.html/index.html: syslog-ng-admin-guide/syslog-ng-ibm-agent-guide-admin-en.xml syslog-ng-admin-guide/*.xml syslog-ng-admin-guide/chapters/*.xml
	mkdir out/syslog-ng-ibm-agent-guide-admin-en.html || /bin/true
	xml-stylesheet/html/process-profile $< $@ ibm-agent
	./copy-pngs.sh out/syslog-ng-ibm-agent-guide-admin-en.html TRUE
	            
syslog-ng-admin-guide/syslog-ng-ibm-agent-guide-admin-en.xml: setup


out/syslog-ng-sql-whitepaper.pdf: syslog-ng-admin-guide/syslog-ng-sql-whitepaper.xml syslog-ng-admin-guide/chapters/*.xml
	xml-stylesheet/pdf/process-profile $< $@ whitepaper
        
out/syslog-ng-sql-whitepaper.html/index.html: syslog-ng-admin-guide/syslog-ng-sql-whitepaper.xml syslog-ng-admin-guide/*.xml syslog-ng-admin-guide/chapters/*.xml
	mkdir out/syslog-ng-sql-whitepaper.html || /bin/true
	xml-stylesheet/html/process-profile $< $@ whitepaper
	./copy-pngs.sh out/syslog-ng-sql-whitepaper.html TRUE
	            
syslog-ng-admin-guide/syslog-ng-sql-whitepaper.xml: setup

manpages: $(MANPAGES)
$(MANPAGES): $(MANSOURCES)

# Other rules needed to be added, if we add manpages to other chapters (read:
# different extensions), although it's highly unlikely... - Folti
out/man/%.1: other/%.1.xml
	$(XSLTPROC_MANPAGES)

out/man/%.5: other/%.5.xml
	$(XSLTPROC_MANPAGES)

out/man/%.8: other/%.8.xml
	$(XSLTPROC_MANPAGES)

clean:
	-rm -rf out/*

.PHONY: clean setup $(PDF_OUTPUTS) $(HTML_OUTPUTS) manpages $(MANSOURCES)
