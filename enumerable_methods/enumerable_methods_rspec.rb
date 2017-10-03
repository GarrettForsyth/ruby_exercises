require "./lib/enumerable_methods.rb"

describe "my enumerable methods" do

  let(:my_array) { [10,0,-5] }
  let(:my_hash){ {one: 1, two: 2,three: 3} } 

  describe ".my_each"  do

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

  describe ".my_each_with_index"  do

    context "call wtih my_array" do
      it "returns the object that invoked it" do
        expect(my_array.my_each_with_index{}).to eql(my_array)
      end
      it "yields to blcok for each element" do
        expect{ |x| my_array.my_each_with_index(&x) }.to yield_successive_args(10,0,0,1,-5,2) 
      end
    end
    context "call wtih my_hash" do
      it "returns the object that invoked it" do
        expect(my_hash.my_each_with_index{}).to eql(my_hash)
      end
      it "yields to block for each element and its index" do
        expect{|x| my_hash.my_each_with_index(&x)}.to yield_successive_args([:one,1],0,[:two,2],1,[:three,3],2)
      end
    end
    context "call with non-enumerable object" do
      it { expect { nil.my_each_with_index{} }.to  raise_error (NoMethodError)}
      it { expect { 1.my_each_with_index{} }.to raise_error(NoMethodError)}
      it { expect { "not enum".my_each_with_index{} }.to raise_error(NoMethodError)}
    end
                                                                          
    context "passed no block" do
      it "returns the arguement that invoked it" do
        expect(my_array.my_each_with_index).to eql(my_array)
        expect(my_hash.my_each_with_index).to eql(my_hash)
      end
    end
  end

  describe ".my_select"  do

    context "call wtih my_array" do
      it "returns new object with only elements that met criteria" do
        expect(my_array.my_select{|x| x >= 0}).to eql([10,0])
      end
      it "yields to block for each element" do
        expect{ |x| my_array.my_select(&x) }.to yield_successive_args(10,0,-5) 
      end
    end

    context "call wtih my_hash one param" do

      it "returns new object with only elements that met criteria" do
        expect(my_hash.my_select{|x| x == :one}).to eql({one: 1})
      end
    end

    context "call with my_hash with two params" do

      it "returns new object with only elements that met criteria" do
        expect(my_hash.my_select{|x,y| y == 2}).to eql({two: 2})
      end
    end


    context "call with non-enumerable object" do
      it { expect { nil.my_select{} }.to  raise_error (NoMethodError)}
      it { expect { 1.my_select{} }.to raise_error(NoMethodError)}
      it { expect { "not enum".my_select{} }.to raise_error(NoMethodError)}
    end

    context "passed no block" do
      it "returns empty" do
        expect(my_array.my_select).to eql([])
        expect(my_hash.my_select).to eql({})
      end
    end
  end

  describe ".my_all?" do

    context "call wtih my_array" do
      it "returns true when all elements satisify condition" do
        expect(my_array.my_all?{|x| x > -100}).to eql(true)
      end
      it "returns false when at least one element does not satisify" do
        expect(my_array.my_all?{|x| x > 0}).to eql(false)
      end
    end

    context "call with non-enumerable object" do
      it { expect { nil.my_all?{} }.to  raise_error (NoMethodError)}
      it { expect { 1.my_all?{} }.to raise_error(NoMethodError)}
      it { expect { "not enum".my_all?{} }.to raise_error(NoMethodError)} end
                                                                          
    context "passed no block" do
      it "returns true" do
        expect(my_array.my_all?).to eql(true)
      end
    end
  end

  describe ".my_any?" do
                                                                              
    context "call wtih my_array" do
      it "returns true when any element satifies the condition" do
        expect(my_array.my_any?{|x| x > 0}).to eql(true)
      end
      it "returns false when zero elements  satisify" do
        expect(my_array.my_any?{|x| x > 1000}).to eql(false)
      end
    end
                                                                              
    context "call with non-enumerable object" do
      it { expect { nil.my_any?{} }.to  raise_error (NoMethodError)}
      it { expect { 1.my_any?{} }.to raise_error(NoMethodError)}
      it { expect { "not enum".my_any?{} }.to raise_error(NoMethodError)} end
                                                                          
    context "passed no block" do
      it "returns true" do
        expect(my_array.my_any?).to eql(true)
      end
    end
  end

  describe ".my_none?" do

    context "call wtih my_array" do
      it "returns true when no elements satifies the condition" do
        expect(my_array.my_none?{|x| x < -1000}).to eql(true)
      end
      it "returns false when any elements  satisify" do
        expect(my_array.my_none?{|x| x > 1}).to eql(false)
      end
    end
                                                                              
    context "call with non-enumerable object" do
      it { expect { nil.my_none?{} }.to  raise_error (NoMethodError)}
      it { expect { 1.my_none?{} }.to raise_error(NoMethodError)}
      it { expect { "not enum".my_none?{} }.to raise_error(NoMethodError)} end
                                                                          
    context "passed no block" do
      it "returns true" do
        expect(my_array.my_none?).to eql(true)
      end
    end
  end
end
