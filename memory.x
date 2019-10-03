MEMORY
{
  /* NOTE 1 K = 1 KiBi = 1024 bytes */
  /* TODO Adjust these memory regions to match your device memory layout */
  /* These values correspond to the LM3S6965, one of the few devices QEMU can emulate */
  FLASH : ORIGIN = 0x08000000, LENGTH = 62K
  DATA : ORIGIN = 0x0800F800, LENGTH = 2K
  PROGRAM1 : ORIGIN = 0x08010000, LENGTH = 250K
  /*PROGRAM2 : ORIGIN = 0x08041800, LENGTH = 250K*/
  RAM : ORIGIN = 0x20000000, LENGTH = 64K
}

ENTRY(ProgramStart);

EXTERN(PROGRAM_START);

/* This is where the call stack will be allocated. */
/* The stack is of the full descending type. */
/* You may want to use this variable to locate the call stack and static
   variables in different memory regions. Below is shown the default value */
/* _stack_start = ORIGIN(RAM) + LENGTH(RAM); */

/* You can use this symbol to customize the location of the .text section */
/* If omitted the .text section will be placed right after the .vector_table
   section */
/* This is required only on microcontrollers that store some configuration right
   after the vector table */
 _stext = ORIGIN(PROGRAM1); 

/* Example of putting non-initialized variables into custom RAM locations. */
/* This assumes you have defined a region RAM2 above, and in the Rust
   sources added the attribute `#[link_section = ".ram2bss"]` to the data
   you want to place there. */
/* Note that the section will not be zero-initialized by the runtime! */
 SECTIONS {
     .program_num : {
       *(.program_num);
       . = ALIGN(4);
     } > DATA
     .text _stext :
      {
        *(.text .text.*);
        KEEP(*(.program_start));
      } > PROGRAM1

      /DISCARD/ :
      {
        *(.ARM.exidx.*);
      }

      /DISCARD/ :
      {
        *(.rodata*);
      }

      /DISCARD/ :
      {
        *(.bss*);
      }
   }

ASSERT(_stext + SIZEOF(.text) < ORIGIN(PROGRAM1) + LENGTH(PROGRAM1), "
ERROR(cortex-m-rt): The .text section must be placed inside the PROGRAM1 memory.
Set _stext to an address smaller than 'ORIGIN(PROGRAM1) + LENGTH(PROGRAM1)'");


