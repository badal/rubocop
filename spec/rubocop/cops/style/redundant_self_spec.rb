# encoding: utf-8

require 'spec_helper'

module Rubocop
  module Cop
    module Style
      describe RedundantSelf do
        let(:cop) { RedundantSelf.new }

        it 'reports an offence a self receiver on an rvalue' do
          src = ['a = self.b']
          inspect_source(cop, src)
          expect(cop.offences).to have(1).item
        end

        it 'accepts a self receiver on an lvalue of an assignment' do
          src = ['self.a = b']
          inspect_source(cop, src)
          expect(cop.offences).to be_empty
        end

        it 'accepts a self receiver on an lvalue of an or-assignment' do
          src = ['self.logger ||= Rails.logger']
          inspect_source(cop, src)
          expect(cop.offences).to be_empty
        end

        it 'accepts a self receiver on an lvalue of an and-assignment' do
          src = ['self.flag &&= value']
          inspect_source(cop, src)
          expect(cop.offences).to be_empty
        end

        it 'accepts a self receiver on an lvalue of a plus-assignment' do
          src = ['self.sum += 10']
          inspect_source(cop, src)
          expect(cop.offences).to be_empty
        end

        it 'accepts a self receiver with the square bracket operator' do
          src = ['self[a]']
          inspect_source(cop, src)
          expect(cop.offences).to be_empty
        end

        it 'accepts a self receiver with the double less-than operator' do
          src = ['self << a']
          inspect_source(cop, src)
          expect(cop.offences).to be_empty
        end

        it 'accepts a self receiver for methods named like ruby keywords' do
          src = ['a = self.class',
                 'self.for(deps, [], true)'
                ]
          inspect_source(cop, src)
          expect(cop.offences).to be_empty
        end

        it 'accepts a self receiver used to distinguish from local variable' do
          src = ['def requested_specs',
                 '  @requested_specs ||= begin',
                 '    groups = self.groups - Bundler.settings.without',
                 '    groups.map! { |g| g.to_sym }',
                 '    specs_for(groups)',
                 '  end',
                 'end',
                ]
          inspect_source(cop, src)
          expect(cop.offences).to be_empty
        end
      end
    end
  end
end
