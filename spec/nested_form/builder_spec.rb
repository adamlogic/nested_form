require File.dirname(__FILE__) + '/../spec_helper'

describe NestedForm::Builder do
  describe "with no options" do
    before(:each) do
      @project = Project.new
      @template = ActionView::Base.new
      @template.output_buffer = ""
      @builder = NestedForm::Builder.new(:item, @project, @template, {}, proc {})
    end

    it "should have an add link" do
      @builder.link_to_add("Add", :tasks).should == '<a href="#" class="add_nested_fields" data-association="tasks">Add</a>'
    end

    it "should have and add link with default name" do
      @builder.link_to_add(:tasks).should == '<a href="#" class="add_nested_fields" data-association="tasks">Add a task</a>'
    end

    it "should have a remove link" do
      @builder.link_to_remove("Remove").should == '<input id="item__destroy" name="item[_destroy]" type="hidden" value="0" /><a href="#" class="remove_nested_fields">Remove</a>'
    end

    it "should have a remove link with default name" do
      @builder.link_to_remove.should == '<input id="item__destroy" name="item[_destroy]" type="hidden" value="0" /><a href="#" class="remove_nested_fields">Remove</a>'
    end

    it "should wrap nested fields each in a div with class" do
      2.times { @project.tasks.build }
      @builder.fields_for(:tasks) do
        @template.concat("Task")
      end
      @template.output_buffer.should == '<div class="fields">Task</div><div class="fields">Task</div>'
    end

    it "should not wrap nested fields with :wrap => false" do
      2.times { @project.tasks.build }
      @builder.fields_for(:tasks, :wrap => false) do
        @template.concat("Task")
      end
      @template.output_buffer.should == 'TaskTask'
    end

    it "should accept custom wrappers" do
      2.times { @project.tasks.build }
      @builder.fields_for(:tasks, :prepend => '<p>', :append => '</p>') do
        @template.concat("Task")
      end
      @template.output_buffer.should == '<p>Task</p><p>Task</p>'
    end

    it "should add task fields to hidden div after form" do
      @template.stub(:after_nested_form) { |block| block.call }
      @builder.fields_for(:tasks) { @template.concat("Task") }
      @builder.link_to_add("Add", :tasks)
      @template.output_buffer.should == '<div id="tasks_fields_blueprint" style="display: none"><div class="fields">Task</div></div>'
    end

    it "should accept procs for wrappers" do
      @project.tasks.build :name => 'task1'
      @project.tasks.build :name => 'task2'

      @builder.fields_for(:tasks,
                          :prepend => proc{|t| "<div class=\"#{t.name}\">"},
                          :append => proc{|t| "</div><p>#{t.name}!</p>"}) do
        @template.concat("Task")
      end
      @template.output_buffer.should == '<div class="task1">Task</div><p>task1!</p><div class="task2">Task</div><p>task2!</p>'
    end
  end
end
