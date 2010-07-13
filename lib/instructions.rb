
class InstructionRow
  attr_accessor :instructions
  
  def parse(row)
    self.instructions = []
    row.each_char do |cell|
      self.instructions << ({ ' ' => :knit,
                              '.' => :purl } [cell])
    end
  end
  
  def reverse!
    self.instructions.collect! do |instr|
      {:knit => :purl,
       :purl => :knit} [instr]
     end
  end
  
  def to_instructions
    groups = []
    last_group = self.instructions.inject([]) do |group, instr|
      if (group.length == 0) or (instr == group.first)
        group + [instr]
      else
        groups << group
        [instr]
      end
    end
    groups << last_group
    
    out = []
    groups.each do |group|
      instruction = group[0]
      count = group.length

      letter = {:knit => 'K', :purl => 'P'} [instruction]
      out << "#{letter}#{count}"
    end
    
    return out
  end
end

class Instructions
  attr_accessor :chart
  
  def self.from_chart(chart)
    instructions = Instructions.new
    instructions.chart = chart
    
    instructions
  end
  
  
  def to_text
    index = 0
    self.chart.reverse.collect do |grid_row|
      index += 1
      side = index_to_side(index)
      side_suffix = " (#{side.to_s.upcase})" if index <= 2

      row = InstructionRow.new
      row.parse grid_row
      row.reverse! if side == :ws
      
      instructions = row.to_instructions
      instructions.reverse! if side == :rs
      
      "Row #{index}#{side_suffix}: #{instructions.join(', ')}"
    end
  end
  
  protected
  def index_to_side(index)
    if index%2 == 0
      return :ws
    else
      return :rs
    end
  end
end
