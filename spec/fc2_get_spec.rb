require 'spec_helper'

describe Fc2Get do
  it 'has a version number' do
    expect(Fc2Get::VERSION).not_to be nil
  end

  it '#mimi' do
    expect(Fc2Get.mimi('20140528bpRKSJWR'))
      .to eq 'c5e51ed4de1f4e6246b851bef4a210de'
  end

  it '#decode_params' do
    expect(Fc2Get.decode_params('a=1&b=2&c=哈哈&d=&e='))
      .to eq 'a' => '1', 'b' => '2', 'c' => '哈哈', 'd' => '', 'e' => ''
  end
end
