# Changelog

## v3.1.0

- [Test against Ruby 3.1 and Rails 7](https://github.com/jeremytregunna/ruby-trello/pull/304)
- [Fix a bug of `Trello::Comment.find`](https://github.com/jeremytregunna/ruby-trello/pull/302)
- Change CI from Travis to GitHub Action
- Test all matrix combinations with matrixeval-ruby on local

## v3.0.0

* [Fix "Trello::Board#update! fail to update description"](https://github.com/jeremytregunna/ruby-trello/pull/289)
* [Add `Trello::List#move_to_board`](https://github.com/jeremytregunna/ruby-trello/pull/297)
* Use schema to handle attribute register work
* Standardize all data models' initialize/save/update!/update_fields process.
* [Breaking] some data model's attribute names changes, check each data model for details
* Support Ruby 3 (ActiveModel >= 6)

## v2.3.0

Security, bug fixes, refactoring, testing.
* Addresses [Fix CVE-2020-10663](https://github.com/jeremytregunna/ruby-trello/pull/284)
* Refactors Trello::BasicData.many and Trello::BasicData.one
* Refactors Trello::BasicData.register_attributes
* Adds more testing around Trello::Card
* Fixes compatibility with JRuby

### Bug Fix

* [Fix #update_fields](https://github.com/jeremytregunna/ruby-trello/issues/272)
* [Fix Trello::AssociationProxy#to_a](https://github.com/jeremytregunna/ruby-trello/issues/274)
* [Fix CustomFieldItem#save](https://github.com/jeremytregunna/ruby-trello/pull/277)

## v2.2.0

Happy start!
