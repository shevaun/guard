require 'spec_helper'
require 'guard/plugin'

describe 'Guard::Interactor::SCOPE' do

  let(:guard)     { ::Guard.setup }
  let(:foo_group) { guard.add_group(:foo) }
  let(:bar_guard) { guard.add_plugin(:bar, group: :foo) }

  before do
    allow(Guard).to receive(:scope=)
    allow(Guard).to receive(:setup_interactor)
    allow(Pry.output).to receive(:puts).and_return(true)
    stub_const 'Guard::Bar', Class.new(Guard::Plugin)
  end

  describe '#perform' do
    context 'without scope' do
      it 'does not call :scope=' do
        expect(Guard).to_not receive(:scope=)
        expect(Pry.output).to receive(:puts).with 'Usage: scope <scope>'
        Pry.run_command 'scope'
      end
    end

    context 'with a valid Guard group scope' do
      it 'runs the :scope= action with the given scope' do
        expect(Guard).to receive(:scope=).with(groups: [foo_group], plugins: [])
        Pry.run_command 'scope foo'
      end
    end

    context 'with a valid Guard plugin scope' do
      it 'runs the :scope= action with the given scope' do
        expect(Guard).to receive(:scope=).with(plugins: [bar_guard], groups: [])
        Pry.run_command 'scope bar'
      end
    end

    context 'with an invalid scope' do
      it 'does not run the action' do
        expect(Guard).to_not receive(:scope=)
        Pry.run_command 'scope baz'
      end
    end
  end

end
