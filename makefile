# GNU Makefile

# Detect Windows build environment
UNAME ?= $(shell uname)
# Find string cygwin (or mingw) in the uname var.
CYGWIN = $(findstring CYGWIN, $(UNAME))
MINGW = $(findstring MINGW, $(UNAME))

# If the cygwin (or mingw) var is not empty, declare windows and set to true.
ifneq ("$(CYGWIN)", "")
WINDOWS=1
endif
ifneq ("$(MINGW)", "")
WINDOWS=1
endif

# Include additional headers.
INCLUDEDIR = $(CURDIR)/include

# Surce directory
SRCDIR = $(CURDIR)/src

# Output directory
BINDIR = $(CURDIR)/bin

# Specify C++ Compiler
CXX ?= clang++
# C++ Compile Flags
CXXFLAGS = \
	-std=c++11 \
	-Wall \
	-Wextra \
	-Wno-parentheses \
	-Wno-class-memaccess \
	-fno-exceptions \
	-fno-rtti \
	-MD \
	-g3

# Specify Resource Compiler
RC = windres

# Resources to build the compiler
CSRCS = \
	$(SRCDIR)/ast.cpp \
	$(SRCDIR)/code.cpp \
	$(SRCDIR)/conout.cpp \
	$(SRCDIR)/fold.cpp \
	$(SRCDIR)/ftepp.cpp \
	$(SRCDIR)/intrin.cpp \
	$(SRCDIR)/ir.cpp \
	$(SRCDIR)/lexer.cpp \
	$(SRCDIR)/main.cpp \
	$(SRCDIR)/opts.cpp \
	$(SRCDIR)/parser.cpp \
	$(SRCDIR)/stat.cpp \
	$(SRCDIR)/utf8.cpp \
	$(SRCDIR)/util.cpp

# Resources to build the testsuite
TSRCS = \
	$(SRCDIR)/conout.cpp \
	$(SRCDIR)/opts.cpp \
	$(SRCDIR)/stat.cpp \
	$(SRCDIR)/test.cpp \
	$(SRCDIR)/util.cpp

# Resources to build the vmm
VSRCS = \
	$(SRCDIR)/exec.cpp \
	$(SRCDIR)/stat.cpp \
	$(SRCDIR)/util.cpp

WINDLLS = \
	/mingw64/bin/libgcc_s_seh-1.dll \
	/mingw64/bin/libstdc++-6.dll \
	/mingw64/bin/libwinpthread-1.dll

# Object files to have same name as source files, but swap the extension.
COBJS = $(CSRCS:.cpp=.o)
TOBJS = $(TSRCS:.cpp=.o)
VOBJS = $(VSRCS:.cpp=.o)

# Dependency files to have same name as source files, but swap the extension.
CDEPS = $(CSRCS:.cpp=.d)
TDEPS = $(TSRCS:.cpp=.d)
VDEPS = $(VSRCS:.cpp=.d)

# If not Windows, define the testsuite bin, otherwise build the main programs
# with proper filename extensions.
ifndef WINDOWS
CBIN = gmqcc
VBIN = qcvm
TBIN = testsuite
else
CBIN = gmqcc.exe
VBIN = qcvm.exe
endif

$(CBIN): $(COBJS)
	$(CXX) $(COBJS) -o $@

$(VBIN): $(VOBJS)
	$(CXX) $(VOBJS) -o $@

# If not Windows, define the testsuite build option and a test execution
# option.
ifndef WINDOWS
$(TBIN): $(TOBJS)
	$(CXX) $(TOBJS) -o $@

test: $(CBIN) $(VBIN) $(TBIN)
	@./$(TBIN)
endif

# Throw some messy opposite logic in while I figure out a better flow for my
# additional needs.
ifdef WINDOWS
bundle:
	mkdir $(BINDIR)
	mv $(CBIN) $(BINDIR)
	mv $(VBIN) $(BINDIR)
	cp $(WINDLLS) $(BINDIR)
	cp $(SRCDIR)/gmqcc.ini.example $(BINDIR)/gmqcc.ini
endif

# Pattern rule to compile source files into objects.
%.o: %.cpp
	$(CXX) -c $(CXXFLAGS) $< -o $@

# If not Windows, also compile testsuite
ifndef WINDOWS
all: $(CBIN) $(VBIN) $(TBIN)
else
all: $(CBIN) $(VBIN)
endif


clean:
	rm -f *.d
	rm -f $(COBJS) $(CDEPS) $(CBIN)
	rm -f $(VOBJS) $(VDEPS) $(VBIN)
	rm -rf $(BINDIR)
ifndef WINDOWS
	rm -f $(TOBJS) $(TDEPS) $(TOBJS)
endif

-include *.d
