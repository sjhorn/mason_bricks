flutter test --coverage && genhtml -p ${PWD}/lib -o coverage coverage/lcov.info && open coverage/index.html