# CS143 - Compilers

This repo contains my work and notes as I progress through [Stanford's CS 143 - Compilers](https://web.stanford.edu/class/cs143/)

## Resources

1. [Cool Programming Language Reference Manual](https://web.stanford.edu/class/cs143/materials/cool-manual.pdf)
2. [Cool Programming Language Support Code](https://web.stanford.edu/class/cs143/materials/cool-tour.pdf)
3. [Lexical Analysis with Flex Manual](https://westes.github.io/flex/manual/)
4. [Bison Manual](https://www.gnu.org/software/bison/manual/html_node/index.html)
5. [Cool Programming Language Runtime](https://web.stanford.edu/class/cs143/materials/cool-runtime.pdf)
6. [SPIM Manual](https://web.stanford.edu/class/cs143/materials/SPIM_Manual.pdf)

## Resource Installation & Environment Set-Up

I set up the environment on Linux using the steps below.

Install packages (If you only intend to use the C++ version, you don't need the jdk):

```bash
sudo apt-get install flex-old bison build-essential csh openjdk-17-jdk libxaw7-dev wget
```

Make the /usr/class directory:

```bash
sudo mkdir -p /usr/class/cs143/cool
```

Make the directory owned by you:


```bash
sudo chown $USER /usr/class/cs143/cool
```

Go to /usr/class and download the tarball:

```bash
cd /usr/class/cs143/cool
wget "https://courses.edx.org/asset-v1:StanfordOnline+SOE.YCSCS1+1T2020+type@asset+block@student-dist.tar.gz" -O student-dist.tar.gz
```

Untar:

```bash
tar -xf student-dist.tar.gz
```

Add a symlink to your home directory:

```bash
ln -s /usr/class/cs143/cool ~/cool
```

Add the bin directory to your .profile:

```bash
vi ~/.profile
```
Add the following line inside:

```bash
export PATH=/usr/class/cs143/cool/bin:$PATH
```

Source the file for changes to take effect:

```bash
source ~/.profile
```

Confirm that `coolc` is available now:

```bash
which coolc
```

Compile one of the example programs to test everything works:

```bash
cd /usr/class/cs143/cool/examples/
coolc cool.cl
```

Test running the compiled file with `spim`:

```bash
spim /usr/class/cs143/cool/examples/cool.s
```

If you get the following error:

```bash
line82: /usr/class/cs143/cool/bin/../bin/.i686/spim: No such file or directory
```

To fix this, we need to add the i386 architecture to run 32-bit executable files:

```bash
sudo dpkg --add-architecture i386
sudo apt-get update
sudo apt-get install gcc-multilib
```

## Lectures

1. [Course Overview](https://web.stanford.edu/class/cs143/lectures/lecture01.pdf)
2. [Cool: The Course Project](https://web.stanford.edu/class/cs143/lectures/lecture02.pdf)
3. [Lexical Analysis](https://web.stanford.edu/class/cs143/lectures/lecture03.pdf)
4. [Implementation of Lexical Analysis](https://web.stanford.edu/class/cs143/lectures/lecture04.pdf)
5. [Introduction to Parsing](https://web.stanford.edu/class/cs143/lectures/lecture05.pdf)
6. [Syntax-Directed Translation](https://web.stanford.edu/class/cs143/lectures/lecture06.pdf)
7. [Top-Down Parsing](https://web.stanford.edu/class/cs143/lectures/lecture07.pdf)
8. [Bottom-Up Parsing](https://web.stanford.edu/class/cs143/lectures/lecture08.pdf)
9. [Semantic Analysis & Type Checking I](https://web.stanford.edu/class/cs143/lectures/lecture09.pdf)
10. [Type Checking II](https://web.stanford.edu/class/cs143/lectures/lecture10.pdf)
11. [Run-time Environments](https://web.stanford.edu/class/cs143/lectures/lecture11.pdf)
12. [Code Generation](https://web.stanford.edu/class/cs143/lectures/lecture12.pdf)
13. [Operational Semantics](https://web.stanford.edu/class/cs143/lectures/lecture13.pdf)
14. [Intermediate Code & Local Optimization](https://web.stanford.edu/class/cs143/lectures/lecture14.pdf)
15. [Global Optimization](https://web.stanford.edu/class/cs143/lectures/lecture15.pdf)
16. [Register Allocation](https://web.stanford.edu/class/cs143/lectures/lecture16.pdf)
17. [Automatic Memory Management](https://web.stanford.edu/class/cs143/lectures/lecture17.pdf)
18. [Fast Runtime Compilation](https://web.stanford.edu/class/cs143/)

## Assignments

### Programming Assignments

1. [Programming Assignment 1](https://web.stanford.edu/class/cs143/handouts/PA1.pdf)
    * [My Solution](./assignments/programming/PA1/)
2. [Programming Assignment 2](https://web.stanford.edu/class/cs143/handouts/PA2.pdf)
3. [Programming Assignment 3](https://web.stanford.edu/class/cs143/handouts/PA3.pdf)
4. [Programming Assignment 4](https://web.stanford.edu/class/cs143/handouts/PA4.pdf)
5. [Programming Assignment 5](https://web.stanford.edu/class/cs143/handouts/PA5.pdf)


### Written Assignments

1. [Written Assignment 1](https://web.stanford.edu/class/cs143/handouts/WA1.pdf) [(LaTeX template/pdf)](https://web.stanford.edu/class/cs143/handouts/WA1_template.tex)
    * [My Solution](./assignments/written/WA1/WA1_solution.pdf)
2. [Written Assignment 2](https://web.stanford.edu/class/cs143/handouts/WA2.pdf) [(LaTeX template/pdf)](https://web.stanford.edu/class/cs143/handouts/WA2_template.tex)
3. [Written Assignment 3](https://web.stanford.edu/class/cs143/handouts/WA3.pdf) [(LaTeX template/pdf)](https://web.stanford.edu/class/cs143/handouts/WA3_template.tex)
4. [Written Assignment 4](https://web.stanford.edu/class/cs143/handouts/WA4.pdf) [(LaTeX template/pdf)](https://web.stanford.edu/class/cs143/handouts/WA4_template.tex)
