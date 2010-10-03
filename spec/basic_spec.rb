require File.expand_path(File.dirname(__FILE__) + '/../lib/instructions')
require File.expand_path(File.dirname(__FILE__) + '/../lib/chart')

EXAMPLES = {
  [" . ",
   ". .",
   " . "] => 
   ["Row 1 (RS): K1, P1, K1",
    "Row 2 (WS): K1, P1, K1",
    "Row 3: K1, P1, K1"],
    
  [".   .",
   ".. ..",
   ". . .",
   ".   ."] =>
   ["Row 1 (RS): P1, K3, P1",
    "Row 2 (WS): K1, P1, K1, P1, K1",
    "Row 3: P2, K1, P2",
    "Row 4: K1, P3, K1"],
    
    
  ["..     ..     ",
   "..     ..     ",
   "..     .......",
   "..     ..     ",
   "..     ..     ",
   "..     ..     ",
   ".........     ",
   "..     ..     "] =>
   ["Row 1 (RS): K5, P2, K5, P2",
    "Row 2 (WS): K9, P5",
    "Row 3: K5, P2, K5, P2",
    "Row 4: K2, P5, K2, P5",
    "Row 5: K5, P2, K5, P2",
    "Row 6: K2, P5, K7",
    "Row 7: K5, P2, K5, P2",
    "Row 8: K2, P5, K2, P5"],
    
    
  [" . ...",
   " . ...",
   " . ...",
   " . ...",
   " . . .",
   " . . .",
   " . . .",
   " . . .",
   "      ",
   "      ",
   "      ",
   "      "] =>
   ["Row 1 (RS): K6",
    "Row 2 (WS): P6",
    "Row 3: K6",
    "Row 4: P6",
    "Row 5: P1, K1, P1, K1, P1, K1",
    "Row 6: P1, K1, P1, K1, P1, K1",
    "Row 7: P1, K1, P1, K1, P1, K1",
    "Row 8: P1, K1, P1, K1, P1, K1",
    "Row 9: P3, K1, P1, K1",
    "Row 10: P1, K1, P1, K3",
    "Row 11: P3, K1, P1, K1",
    "Row 12: P1, K1, P1, K3"]
}


describe Instructions, "#from_chart" do  
  it "should produce the correct knitting patterns" do
    EXAMPLES.each do |chart, expected_instructions|
      instructions = Instructions.from_chart chart
      instructions.to_text.should == expected_instructions
    end
  end
end

describe Chart, "#from_instructions" do
  it "should produce the correct knitting charts" do
    EXAMPLES.invert.each do |instructions, expected_chart|
      instructions = ["extra text"] + instructions + ["more text"]
      c = Chart.from_instructions instructions
      c.to_text.should == expected_chart
    end
  end
end
