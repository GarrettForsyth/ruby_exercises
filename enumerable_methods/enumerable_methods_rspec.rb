require "./lib/enumerable_methods.rb"

describe "my enumerable methods" do

  let(:my_array) { [10,0,-5] }
  let(:my_hash){ {one: 1, two: 2,three: 3} } 

  shared_examples_for "an enumerable method" do

    context "call with non-enumerable object" do
      it { expect { nil.my_each{} }.to  raise_error (NoMethodError)}
      it { expect { 1.my_each{} }.to raise_error(NoMethodError)}
      it { expect { "not enum".my_each{} }.to raise_error(NoMethodError)}
    end
                                                                          
    context "passed no block" do
      it "returns the arguement that invoked it" do
        expect(my_array.my_each).to eql(my_array)
        expect(my_hash.my_each).to eql(my_hash)
      end
    end
  end

  describe ".my_each"  do

    it_behaves_like "an enumerable method"

    context "call wtih my_array" do
      it "returns the object that invoked it" do
        expect(my_array.my_each{}).to eql(my_array)
      end
      it "yields to blcok for each element" do
        expect{ |x| my_array.my_each(&x) }.to yield_successive_args(10,0,-5) 
      end
    end

    context "call wtih my_hash" do
      it "returns the object that invoked it" do
        expect(my_hash.my_each{}).to eql(my_hash)
      end
      it "yields to block for each element" do
        expect{|x| my_hash.my_each(&x)}.to yield_successive_args([:one,1],[:two,2],[:three,3])
      end
    end
  end

end
