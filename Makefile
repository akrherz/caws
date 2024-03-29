SCCS_ID_Makefile="@(#)Makefile 0.1 06/03/2003 12:00:00"
#
#	Makefile for comm_client and comm_svr programs.
#
#	comm_client - Polls a directory for files and sends them to the 
#				  comm_svr via a tcp socket connection.  Each file 
#				  is preceded by a header indicating bytes to follow, 
#				  sequence number, and timestamp.  An acknowledgement is
#				  required for each product.
#
#	comm_svr -	  Forks a persistant service for each client.  A dispatcher
#			      monitors a well-known port for new connection requests.
#				  The service reads headers and file data from a tcp socket
#				  connection and writes those files to disk.  Each file is
#				  acknowledged.
#
#	
#	Makefile Notes:
#			Set the CC variable to your compiler of choice (e.g. gcc or
#			/usr/vac/bin/cc).  If left unset it will likely default to cc.
#
#			Set the CCOPTS variable to any desired compiler options such as
#			-g to enable use of debugger or -O for optimizer.  This source
#			may not compile on some architectures without the use of some
#			pre-processor directives.  HPUX needs to have the following
#			flags defined:
#			"-Aa -D_HP_HPUX_SOURCE -D_XOPEN_SOURCE -D_XOPEN_SOURCE_EXTENDED"
#
#			Set the LDOPTS variable to any additional link-time options.
#			These probably won't be required with the current source, but
#			if this source is modified to include calls to other libraries,
#			those other libraries could be compiled into the executables
#			via the LDOPTS variable.
LDMHOME  := /home/ldm
CCOPTS   :=
LDOPTS   := 
INSTPATH := /usr/local/bin
ldmlib   := $(wildcard $(LDMHOME)/lib/*ldm.a)
ldminc   := $(wildcard $(LDMHOME)/include/*ldm.h)
CCOPTS   := $(CCOPTS) -DAWC_LDM_SUPPORT -I$(LDMHOME)/include
LDOPTS   := $(LDOPTS) -L$(LDMHOME)/lib -lldm -lm
INSTPATH := $(LDMHOME)/bin

all:: progs

progs:: comm_client

progs:: comm_svr

inst_progs:: $(INSTPATH)/comm_client

inst_progs:: $(INSTPATH)/comm_svr

COBJS = client_main.o client_send.o client_queue.o client_init.o

SOBJS =  serv_main.o serv_dispatch.o serv_recv.o serv_store.o serv_init.o

LOBJS = share.o log.o wmo.o

comm_client:	$(COBJS) $(LOBJS)
	rm -f $@
	$(CC) $(CCOPTS) -o $@ $(COBJS) $(LOBJS) $(LDOPTS)

comm_svr:	$(SOBJS) $(LOBJS)
	rm -f $@
	$(CC) $(CCOPTS) -o $@ $(SOBJS) $(LOBJS) $(LDOPTS)

clean::
	rm -f comm_svr
	rm -f comm_client
	rm -f $(COBJS)
	rm -f $(SOBJS)
	rm -f $(LOBJS)

.c.o:
	rm -f $@
	$(CC) $(CCOPTS) -c $*.c

install: inst_progs

$(INSTPATH)/% : %
	install $^ $@

client_main.o:: client.h share.h
client_send.o:: client.h share.h
client_queue.o:: client.h share.h
serv_main.o:: server.h share.h
serv_recv.o:: server.h share.h
serv_dispatch.o:: server.h share.h
serv_store.o:: server.h share.h
share.o:: share.h
log.o:: share.h
wmo.o:: share.h
