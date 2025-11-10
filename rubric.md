# Rubric
- definitions
    - **type**: in this document means Abstract Datatype while `type` will be used to talk about the zig keyword
    - **module**: in this document means a collection of data/functions
        - wether the language calls that collection of data/functions a class or module the defining feature is a unique named scope for data/functions
        - an interface is a module that describes no data
- `linked_list.zig`
    - memory management
        - what are the two `Allocator` methods used to manage memory in `linked_list.zig`
            - hint: see the methods of the `LinkedList(T).Node` type
        - explain what the responsibilities of the owner of a value (unlike rust zig does not **enforce** ownership)
        - explain control-flow keyword `defer`
            - hint: comment out the `defer` line in `test` `"push and pop"` 
    - types
        - explain how to create a binding to a specific data structure (grouped data and functions)
        - explain how to represent the type of tuples whose 0th field is of type `usize` and 1th field is of type `isize`
        - explain `@This` built in functions
        - `LinkedList` is a generic type why is the binding declared as a function?
    - optional
        - explain control-flow keyword `orelse`
        - explain  `.?` operator
        - explain syntax for representing an optional type
        - explain the following syntaxes. What are the rust equivalents?
            - `if (optional_value) |value| {}`
            - `while (optional_value) |value| {}`
    - errors
        - explain what is meant when a function returns `!T`
        - explain `try` operator
            - hint: what operator in rust does the same thing`?`
    - pointers
        - explain `.*` operator
        - explain `&` operator
        - explain the syntax for how to represent the following types
            - immutable pointer to `T`
            - mutable pointer to `T`
    - explain `undefined`
    - explain `@import`
- `terminal.zig`
    - briefly explain `print`, `printLine`, `readLine` and `input` functions. (the `const`s at the bottom of the file)
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
    - namespaces
        how to define a unquiet scope of data/functionality in different langs.
        - java
            - `package`, `module`: declares a module and creates a binding to it
            - `class`, `enum`, `record`: declares a module and creates a binding to it
                - represents a product type
            - `interface`, `abstract class`: declares a module and creates a binding to it
                - represents a shared set of functionality
        - rust
            - `mod`: declares a module and creates a binding to it
            - `struct`: declares a module and creates a binding to it
                - represents a product type
            - `enum`, `union`: declares a module and creates a binding to it
                - represents a sum type
            - `trait`: declares a module and creates a binding to it
                - has no data
                - represents a shared set of functionality
        - cpp
            - `module`, `namespace`: declares a module and creates a binding to it
            - `class`, `struct`: declares a module and creates a binding to it
                - represents a product type
            - `enum class`, `union`: declares a module and creates a binding to it
                - represents a sum type
            - `abstract class`:  declares a module and creates a binding to it
                - represents a shared set of functionality
        - zig
            - `const`: creates a binding. (in this case we only about bindings to module which zig calls `type`s)
            - `struct`: defines a module
                - represents a product type
            - `union`: defines a module
                - represents a sum type
            - reasons about shared behavior using reflection to check the if the type being passed has the required methods and those methods have the correct signature
            - Notice how zig is the only language that
                - separates binding of abstract types with their definition.
                    ```zig
                    // create a new binding called `str` it is assigned to the type `[]const u8` (read as a slice of `u8`)
                    const str: type = []const u8;

                    // create a new binding called `Name` it is assigned to a new type with the following data/functions
                    // `const` creates the binding
                    // `struct` defines the type 
                    const Name: type = struct { first: str, last: str };
                    ```
