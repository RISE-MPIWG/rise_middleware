module Powers
  module ToolExports
    as_trait do
      power :tool_exports do
        @user.tool_exports
      end

      power :readable_tool_exports do
        ToolExport.where(user_id: @user.id)
      end

      power :updatable_tool_exports do
        @user.tool_exports
      end

      power :updatable_tool_export?, :destroyable_tool_export?, :readable_tool_export? do |tool_export|
        tool_export.user_id == @user.id
      end

      power :creatable_tool_exports do
        ToolExport.where(user_id: @user.id)
      end

      power :destroyable_tool_exports do
        ToolExport.where(user_id: @user.id)
      end
    end
  end
end
