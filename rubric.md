# Rubric
- `linked_list.zig`
    - memory management
        - what are the two `Allocator` methods used to manage memory in `linked_list.zig`
        - explain what the responsibilities of the owner of a value (unlike rust zig does not **enforce** ownership)
        - explain `defer`
            - hint: comment out the `defer` line in `test` `"push and pop"` 
    - types
        - explain how to create a binding to a specific data structure (grouped data and functions)
        - explain how to represent the type of tuples whose 0th field is of type `usize` and 1th field is of type `isize`
        - explain `@This` built in functions
        - `LinkedList` is a generic type why is the binding declared as a function?
    - optional
        - explain `orelse` keyword
        - explain  `.?` operator
        - explain syntax for representing an optional type
        - explain the following syntaxes. What are the rust equivalents?
            - `if (optional_value) |value| {}`
            - `while (optional_value) |value| {}`
    - errors
        - explain what is meant when a function returns `!T`
        - explain `try` keyword
    - pointers
        - explain `.*` operator
        - explain `&` operator
        - explain the syntax for how to represent the following types
            - immutable pointer to `T`
            - mutable pointer to `T`
    - explain `undefined`
    - explain `@import`
- `terminal.zig`
    - briefly explain `print`, `printLine`, `readLine` and `input` functions
        - even though these are functions what key word was used to create the bindings?
        - what is the largest value that can be printed/read (what is the buffer size)?
    - explain the `stack_buffered` function
        - the actual printing/reading input logic is not the focus just the structure of having a function return a type with four functions inside
        - explain how currying is used to define the function bindings
            - returns a type that contains four functions
                - `terminal.print`,
                - `terminal.printLine`,
                - `terminal.readLine`
                - `terminal.input`
- cheat sheet
    - loops
        - c-style for
            - cpp
            ```cpp
            for (size_t i = 0; i < 10; i += 1) {}
            ```
            - zig
            ```zig
            var i: usize = 0
            while (i < 10) : (i += 1) {}
            ```
        - for each loop
            - cpp
            ```cpp
            for (auto element : collection) {} // loop over copies
            for (auto& element : collection) {} // loop over mutable references
            for (const auto& element : collection) {} // loop over imitable references 
            ```
            - zig
            ```zig
            for (collection) |element| {} // loop over copies
            for (collection) |*element| {} // loop over mutable pointers to elements
            ```
