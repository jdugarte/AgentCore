# JPL-Derived Coding Standards (HRE Compliance) 🚀

These standards are adapted from NASA’s Jet Propulsion Laboratory (JPL) for high-reliability software. Compliance with these rules is mandatory for aerospace-grade determinism.

## 1. Acyclomatic Simplicity
- **Rule**: Maximum cyclomatic complexity of **10** per method/function.
- **Why**: Deeply nested logic is hard to test and prone to edge-case failures.

## 2. Bounded Execution
- **Rule**: All loops and recursive functions must have explicit, hard-coded upper execution bounds.
- **Why**: Prevents infinite loops and ensures execution time is deterministic.

## 3. Mandatory Assertions (Assertion Density)
- **Rule**: Minimum of **two state assertions** per critical function.
- **Implementation**:
    - **Pre-condition**: Check input validity/state before processing.
    - **Post-condition**: Check output/mutation success before returning.

## 4. Function Breadth (The One-Page Rule)
- **Rule**: Maximum **60 lines** per function.
- **Why**: Functions must fit in the AI's (and human's) focused context window to ensure flawless parsing.

## 5. Memory & Side Effects
- **Rule**: Avoid hidden side effects and global state mutations.
- **Rule**: Prefer immutable data structures where the language allows.
