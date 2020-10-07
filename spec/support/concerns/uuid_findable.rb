require 'spec_helper'

shared_examples_for 'uuid_findable' do
  let (:model) { create described_class.to_s.downcase }

  it 'should find an example from uuid' do
    expect(described_class.from_uuid(model.uuid)).to eq model
  end
end
