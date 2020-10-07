require 'spec_helper'

shared_examples_for 'archivable' do
  let (:model) { create described_class.to_s.downcase, archived: false }

  it 'should return all active examples' do
    expect(described_class.active).to include model
  end

  it 'should return false if example is active' do
    expect(model.active?).to be true
  end

  it 'should archive the model' do
    model.archive
    expect(model.archived).to be true
  end
end
