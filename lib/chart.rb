class InstructionGroup
  attr_accessor :instruction, :count

  def self.from_direction(direction)
    instruction = {'K' => :knit, 'P' => :purl} [direction[0,1]]
    count = direction[1..-1].to_i
    
    group = InstructionGroup.new 
    group.instruction = instruction
    group.count = count
    return group
  end
  
  def reverse!
    self.instruction = {:knit => :purl, :purl => :knit} [self.instruction]
  end

  def to_chart
    [{:purl => ' ', :knit => '.'}[self.instruction]] * self.count
  end
end

class Chart
  attr_accessor :instruction_rows
  
  def self.from_instructions(instructions)
    c = Chart.new
    c.instruction_rows = instructions
    return c
  end
  
  def to_text
    instructions = self.instruction_rows.collect do |row|
      row.split(':')[-1].split(',').collect do |direction|
        InstructionGroup.from_direction direction.strip
      end
    end
    
    instructions.collect! {|row| row.flatten}
    
    instructions.each_index do |index|
      if index.even?
        instructions[index].collect {|group| group.reverse!}
        instructions[index].reverse!
      end
    end

    instructions.collect {|row| row.collect {|group| group.to_chart }.flatten.join }.reverse
  end
end