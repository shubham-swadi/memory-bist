# Designing a M-BIST module for a 32x8 memory using Verilog HDL

This project was completed under the internship program organized by IEEE Circuits and Systems Society (CASS), Bangalore section belonging the domain of VLSI Design. This README file is the pre-final version of the report submitted for presentation of the project.

## Background Work

### What is memory?

Memory is an electronic circuit or device specifically designed to store and retrieve digital information. Semiconductor memory is a type of memory which uses electronic components to store digital information, primarily zeros and ones. A semiconductor memory is achieved with the help of semiconductor devices such as transistors,capacitors and resistors by integrating them on a silicon wafer or chip.
 
The most basic unit of a memory is a memory cell, which stores a single binary bit of information. These cells can be organized in forms of rows and columns to form memory arrays. The two main operations that can be performed on a memory are read and write. Reading involves extracting data present in a particular memory cell, whereas writing involves storing an input data within a memory cell.

The significant types of semiconductor memory are:
1. Dynamic Random Access Memory (DRAM)
2. Static Random Access Memory (SRAM)
3. Cache DRAM (CDRAM)
4. Read-Only Memories (ROMs)
5. Erasable, Programmable Read-Only Memories (EPROMs)
6. Electrically Erasable, Programmable Read-Only Memories (EEPROMs)

### What is the need for memory?

Memory is a fundamental component of VLSI design since it has a wide range of applications, from embedded systems and microcontrollers to processors, storage devices and more. 

Efficient memory design and management are critical in VLSI to ensure that data can be stored and accessed quickly and reliably, while also considering power consumption, space constraints, and cost-effectiveness. 

With the recent advancements in the field of Artificial Intelligence, semiconductor memories have gained even more importance. There is an increasing demand for storing and accessing data efficiently and quickly. Rapid computations are essential for real-time data processing demands of AI. AI models like deep neural networks consist of numerous parameters and hyperparameters that need to be stored during training. 

As of 2017, semiconductor memories accounted for 30% of the semiconductor industry. All this shows that semiconductor memories are an integral part of the semiconductor industry and their importance will keep increasing with the advancements in technology.

### Faults in a semiconductor memory

Semiconductor memories can be prone to errors and faults which can alter its performance. Thus testing a semiconductor memory is extremely important. Some of the common faults that occur in a memory are:
1. Stuck-at faults: The logic value of a particular cell is always 0 or 1.
2. Transition fault: A cell or a word fails to go from low(0) to high(1) value or vice versa.
3. Coupling fault: A write operation in one cell alters the data in some other cell.
4. Address Decoder Fault: Cells are wrongly addressed.

### What is BIST?

As seen above, memory chips are susceptible to faults. The faults that arise should be detected. The term Design For Testability (DFT), is an approach to design electronic circuits in order to easily diagnose faults and defects in a chip. One such testing technique in DFT is known as BIST. BIST is an acronym for Built-In Self Test which is a chip testing technique where we integrate testing capabilities on the same hardware of the chip.

### What is the need for BIST?

As discussed above, the demand for semiconductor chips, and semiconductor memories in particular, is ever increasing. Therefore, there is also a demand for testing mechanisms for all the chips in the market. Designing chip-specific testing mechanisms is not only inefficient and time consuming, it is economically infeasible too. Integrating the testing mechanism saves manufacturing costs of separate circuits and chips as well as the entire testing process can be automated.

### Parts/ Components of BIST

- BIST Controller
- Interface
- Comparator
- Test Pattern Generator

### What is an Algorithm?

"An algorithm is a finite set of well-defined rules for performing a specific task or solving a particular problem."

&nbsp; - Donald E. Knuth (“The Art of Computer Programming”)

According to this definition an algorithm consists of a definite number of steps or instructions with predefined beginning and end. The instructions are well defined and with no scope for ambiguity. Algorithms are designed to perform a specific task and they address a particular problem or a challenge

### Algorithm used (MARCH Y)

There exist a lot of algorithms for the purpose of testing memory. One such family of memory testing algorithms is MARCH. MARCH stands for  Marching, Addressing, Row Address Strobe, Column Address Strobe and Halt.

The notation followed by MARCH algorithms is given below:
<img>

The following are the different algorithms in the MARCH family:
<img>

MARCH Y is one such simple algorithm belonging to the MARCH family. It is able to detect all Stuck-at faults, Transition faults, Coupling faults and Address Decoder faults.

Some advanced algorithms used in industries include SMarchCHKBvcd, advanced coupling test. 

## Problem Statement

- Design a memory block of size 32x8 : 32 words (Rows) and 8 bits/word
 
&ensp; - 1 Read Port, 1 Write port

- Design its Memory BIST (Built in Self Test) Block which may include
  
&ensp; - Controller and its sub part

&ensp; - Interface

&ensp; - Comparator

- Implement its controller with Simple MARCH Y algorithm to cover memory faults.

- Implement in Verilog

- Write test bench (Verilog) and Simulate to ensure the Functionality

- Report with Block diagrams, flow chart, Code and Results

## Prior art survey

The questions posed to us in the problem statement are very simplistic in nature and boiled down to a beginner level in order to help us understand the basics of memory organization and VLSI testing. The industry level applications of the same are very complex and somewhat out of scope for us. After referring to multiple articles and sources, we gained a basic understanding of how VLSI testing works. While working on this problem statement, we found out that such basic architecture of a memory BIST already exists.

## Proposed Solution/ Implementation

The proposed Built-In Self-Test (BIST) architecture for a 32x8 memory comprises several key modules to facilitate efficient testing and verification. 

The central component is the Controller, responsible for orchestrating the entire BIST operation. It utilizes a Finite State Machine (FSM) to implement the marchY algorithm, coordinating interactions among various modules. The Test Pattern Generator generates binary test data, feeding it to the Interface module, which acts as a gateway between the BIST operation and normal memory functioning. The Test Address Generator complements this by generating read and write addresses for each clock cycle.

The Interface module incorporates signals such as read_enable, write_enable, data_in, and both write and read addresses. These signals are sourced from the Controller, Test Pattern Generator, and Test Address Generator, ensuring seamless communication with the Memory module. The Memory itself is a 32x8 memory block with standard input signals including read_enable, write_enable, read_address, write_address, data_in, and clk.

A crucial part of the BIST architecture is the Comparator, which validates data consistency by comparing the data written into the memory with the data read from it. If the comparison is successful, the Comparator signals a "go_bist" to the Controller, allowing the BIST operation to proceed. This modular architecture ensures a systematic and comprehensive Built-In Self-Test for the 32x8 memory, enhancing the reliability and robustness of the overall system.

### Tools Used

Xilinx Vivado

### Block Diagram

![WhatsApp Image 2024-04-15 at 14 47 33_57ac3dea](https://github.com/shubham-swadi/memory-bist/assets/122473812/0fbb86a1-9386-483f-8d08-a303987fbaf8)


### Simulation results

![image](https://github.com/shubham-swadi/memory-bist/assets/122473812/5d1c8dc2-1a58-480c-b56a-5512b3f0f871)


The above are the simulation results for the controller module. Clk, reset, bist_en are input signals, go_bist, test_pattern_gen_en, test_address_gen_en etc are the output signals and cs and i are status signals to track the algorithm. It takes a total of **317** cycles to complete the one bist test.

## Project Mentor

[Mr. Kapil Bajaj](https://www.linkedin.com/in/kapil-bajaj-a2a4944)

## Project Members

[Omkar Patil](https://www.linkedin.com/in/omkar-patil-306312227)  
[Shubham Kiran Swadi](www.linkedin.com/in/shubham-swadi)  
[Arpitha Battu](https://www.linkedin.com/in/arpithabattu)  
[Harshak Sachdeva](https://www.linkedin.com/in/harshak-sachdeva-b910b611a)

