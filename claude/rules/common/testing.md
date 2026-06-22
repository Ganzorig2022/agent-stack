# Testing

Use **tdd-guide** / the `tdd` skill for new behavior, bug fixes, and refactors that must preserve behavior: red → green → refactor → verify.

Cover unit (functions/components), integration (APIs, DB), and E2E for critical flows. Structure tests Arrange-Act-Assert with descriptive names that state the behavior (`returns empty array when no markets match query`). Aim for meaningful coverage (~80%) over vanity numbers. Fix the implementation, not the test — unless the test is wrong.
