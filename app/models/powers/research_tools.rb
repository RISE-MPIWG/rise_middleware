module Powers
  module ResearchTools
    as_trait do
      power :research_tools, :readable_research_tools do
        if @user
          @user.organisation.accessible_research_tools.uniq
        else
          # TODO we probably need a 'public' mechanism for research tool as well for unauthenticated users
          ResearchTool.all
        end
      end

      power :creatable_research_tools do
        Collection.all
      end

      power :updatable_research_tools do
        case role_sym
        when :admin
          ResearchTool.none
        when :super_admin
          ResearchTool.active
        else
          ResearchTool.none
        end
      end

      power :readable_research_tool? do |research_tool|
        if @user
          @user.organisation.accessible_research_tools.include? research_tool
        else
          # TODO we probably need a 'public' mechanism for research tool as well for unauthenticated users
          true
        end
      end

      power :updatable_research_tool? do |_research_tool|
        case role_sym
        when :super_admin
          ResearchTool.active
        else
          false
        end
      end

      power :destroyable_research_tool? do |_research_tool|
        case role_sym
        when :super_admin
          collection.active
        else
          false
        end
      end

      power :destroyable_research_tools do
        case role_sym
        when :admin
          @user.organisation.research_tools.active
        when :super_admin
          ResearchTool.active
        else
          ResearchTool.none
        end
      end
    end
  end
end
