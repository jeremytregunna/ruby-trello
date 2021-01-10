RUN = docker-compose run --rm

init:
	touch Gemfile.lock.ruby_2_5
	touch Gemfile.lock.ruby_2_6
	touch Gemfile.lock.ruby_2_7
	touch Gemfile.lock.ruby_3_0
	touch Gemfile.lock.jruby
gemfile\:refresh:
	rm Gemfile.lock.ruby_2_5
	rm Gemfile.lock.ruby_2_6
	rm Gemfile.lock.ruby_2_7
	rm Gemfile.lock.ruby_3_0
	rm Gemfile.lock.jruby
	touch Gemfile.lock.ruby_2_5
	touch Gemfile.lock.ruby_2_6
	touch Gemfile.lock.ruby_2_7
	touch Gemfile.lock.ruby_3_0
	touch Gemfile.lock.jruby
bundle\:all:
	@${RUN} ruby_2_5 bundle install
	@${RUN} ruby_2_6 bundle install
	@${RUN} ruby_2_7 bundle install
	@${RUN} ruby_3_0 bundle install
	@${RUN} jruby_9_2 bundle install

bundle:
	@${RUN} ruby_2_6 bundle install
dev:
	@${RUN} ruby_2_6 bash
test:
	@${RUN} ruby_2_6 bundle exec rspec $(filter-out $@,$(MAKECMDGOALS))
dev\:ruby_2_5:
	@${RUN} ruby_2_5 bash
test\:ruby_2_5:
	@${RUN} ruby_2_5 bundle exec rspec spec
dev\:ruby_2_6:
	@${RUN} ruby_2_6 bash
test\:ruby_2_6:
	@${RUN} ruby_2_6 bundle exec rspec spec
dev\:ruby_2_7:
	@${RUN} ruby_2_7 bash
test\:ruby_2_7:
	@${RUN} ruby_2_7 bundle exec rspec spec
dev\:ruby_3_0:
	@${RUN} ruby_3_0 bash
test\:ruby_3_0:
	@${RUN} ruby_3_0 bundle exec rspec spec
dev\:jruby_9_2:
	@${RUN} jruby_9_2 bash
test\:jruby_9_2:
	@${RUN} jruby_9_2 bundle exec rspec spec

test\:all:
	@${RUN} ruby_2_5 bundle exec rspec spec
	@${RUN} ruby_2_6 bundle exec rspec spec
	@${RUN} ruby_2_7 bundle exec rspec spec
	@${RUN} ruby_3_0 bundle exec rspec spec
	@${RUN} jruby_9_2 bundle exec rspec spec
%:
	@: