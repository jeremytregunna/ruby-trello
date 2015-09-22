## Contributing

1. To get started, please [sign the CLA]
2. Fork the repository
3. Run the tests.  We only accept pull request with a passing test
   suite, so make sure you're starting from a clean slate: `bundle &&
rake`
4. Create a new branch for your new adjustments:
   `features/my-new-feature`
4. Add a test that addresses each code change (note: refactors and
   documentation, do not require new tests).
5. Run the test suite to make sure it's still green (passing): `bundle
   && rake`
6. Push the your branch to your fork, and submit a pull request

[sign the CLA]: http://www.clahub.com/agreements/jeremytregunna/ruby-trello

## Guides

#### Test Suite

For common best practices, please follow the guides found at
http://betterspecs.org

Let's highlight a few important patterns:

* Use `expect` syntax over the deprecated `should` syntax (http://betterspecs.org#expect)
* Use `allow(object).to receive(:method_name)` over the deprecated `object.stub(:method_name)` to define a stub
* Use `expect(object).to receive(:method_name)` over the deprecated `object.should_receive(:method_name)` to define a stubbed expectation
* Use `let` blocks over `@instance` variables to persist objects/values (http://betterspecs.org/#let)
* Use `context` to control permutations and DRY-up duplicate stubs, mocks and override persistant objects (http://betterspecs.org/#contexts)
* Place stubs into `before` blocks and not in the expectation block
* Do *not* place expectations into `before` or `after` blocks
* Utilize RSpec's support for predicate methods: `expect(object.valid?).to be(true)` should be `expect(object).to be_valid`

**Additional Resources**

RSpec Design Patterns Workshop at RailsConf 2014: https://youtu.be/d2gL6CYaYwQ
