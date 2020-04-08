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
INCLUDEDIR=$(CURDIR)/include

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
	src/ast.cpp \
	src/code.cpp \
	src/conout.cpp \
	src/fold.cpp \
	src/ftepp.cpp \
	src/intrin.cpp \
	src/ir.cpp \
	src/lexer.cpp \
	src/main.cpp \
	src/opts.cpp \
	src/parser.cpp \
	src/stat.cpp \
	src/utf8.cpp \
	src/util.cpp

# Resources to build the testsuite
TSRCS = \
	src/conout.cpp \
	src/opts.cpp \
	src/stat.cpp \
	src/test.cpp \
	src/util.cpp

# Resources to build the vmm
VSRCS = \
	src/exec.cpp \
	src/stat.cpp \
	src/util.cpp

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

# Pattern rule to compile source files into objects.
%.o: %.cpp
	$(CXX) -c $(CXXFLAGS) $< -o $@

# If not Windows, also compile testsuite
ifndef WINDOWS
all: $(CBIN) $(QCVM) $(TBIN)
else
all: $(CBIN) $(QCVM)
endif


clean:
	rm -f *.d
	rm -f $(COBJS) $(CDEPS) $(CBIN)
	rm -f $(VOBJS) $(VDEPS) $(VBIN)
ifndef WINDOWS
	rm -f $(TOBJS) $(TDEPS) $(TOBJS)
endif

-include *.d
