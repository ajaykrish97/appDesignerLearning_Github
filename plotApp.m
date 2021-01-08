classdef plotApp < handle
    % plotApp uses uihtml to plot data with the help of external java
    % script library "Plotty".
    %
    %
    % Syntax:
    % >>plotApp(<xData>,<yData>);
    % Where xData and yData are values of x and y axis.
    %
    % Example: plotApp([1:5],sin([1:5]));
    %
    
    properties
        figH;
        mainGrid;
        plotAxes;
        tableData;
        addPushButton;
        deletePushButton;
        plotPushButton;
        closePushButton;
        plotTypes;
        currentIdx;
        input_data;
        init_val;
    end
    methods
        function obj = plotApp(varargin)
            % If input arguments given,parse the arguments and get the x
            % and y data.
            if nargin == 2
                input_struct.x = varargin{1};
                input_struct.y = varargin{2};
                input_struct.plotType = 'lines';
                obj.init_val = 1;
            else
                obj.init_val = 0;
            end
            obj.figH = uifigure('Name','PlotApp','Visible','off');
            screenSize = get(0,'screensize');
            set(obj.figH,'Position',[0.1*screenSize(3) 0.1*screenSize(4) screenSize(3)*0.8 screenSize(4)*0.8]);
            movegui(obj.figH,'center');
            % Create a grid container.
            obj.mainGrid = uigridlayout(obj.figH,[1,2]);
            obj.mainGrid.ColumnWidth = {'2x','1x'};
            % Axes
            obj.plotAxes = uihtml('parent',obj.mainGrid,'HTMLSource',[pwd '\plotApp.html']);
            % table
            tableGrid = uigridlayout(obj.mainGrid,[2,1]);
            tableGrid.RowHeight = {'1x',110};
            tablePanel = uipanel('parent',tableGrid,'Title','Table Data');
            tableCntr = uigridlayout(tablePanel,[2,1]);
            tableCntr.RowHeight = {'1x',50};
            emptyData = repmat({[]},4,2);
            obj.tableData = uitable('parent',tableCntr,'data',emptyData,'ColumnName',{'X-Data','Y-Data'},'ColumnEditable',true);
            % Contianer to add table pushbuttons.
            tableButtonsCntr = uigridlayout(tableCntr,[1,4]);
            obj.addPushButton = uibutton('parent',tableButtonsCntr,'Text','Add');
            obj.addPushButton.Layout.Row = 1;
            obj.addPushButton.Layout.Column = 3;
            obj.deletePushButton = uibutton('parent',tableButtonsCntr,'Text','Delete');
            obj.deletePushButton.Layout.Row = 1;
            obj.deletePushButton.Layout.Column = 4;
            % Plot Options.
            plotOptionsPanel = uipanel('parent',tableGrid,'Title','Plot Options');
            buttonGrid = uigridlayout(plotOptionsPanel,[2,4]);
            buttonGrid.RowHeight = {30,30};
            buttonGrid.ColumnWidth = {'1x','1x','1x','1x'};
            % Plot List.
            obj.plotTypes = uidropdown('parent',buttonGrid,'Items',{'lines','scatter','bar','markers'});
            obj.plotTypes.Layout.Row = 1;
            obj.plotTypes.Layout.Column = [1,4];
            % Plot and cancel pushbuttons.
            obj.plotPushButton = uibutton('parent',buttonGrid,'Text','Plot');
            obj.plotPushButton.Layout.Row = 2;
            obj.plotPushButton.Layout.Column = 2;
            obj.closePushButton = uibutton('parent',buttonGrid,'Text','Close');
            obj.closePushButton.Layout.Row = 2;
            obj.closePushButton.Layout.Column = 3;
            % Set Callbacks.
            set(obj.addPushButton,'ButtonPushedFcn',@(h,e)addRow(obj,h,e));
            set(obj.deletePushButton,'ButtonPushedFcn',@(h,e)deleteRow(obj,h,e));
            set(obj.plotPushButton,'ButtonPushedFcn',@(h,e)plotSignal(obj,h,e));
            set(obj.closePushButton,'ButtonPushedFcn',@(h,e)closeFig(obj,h,e));
            set(obj.tableData,'CellSelectionCallback',@(h,e)currentSelectedCell(obj,h,e));
            obj.plotAxes.DataChangedFcn = @(src,event)updateTable(obj);
            set(obj.figH,'visible','on');
            if obj.init_val
                obj.input_data = input_struct;
                plotInitVal(obj)
            end
            
        end
        %------------------------------------------------------------------
        function addRow(obj,~,~)
            % Adds row in the table.
            
            existingData =  get(obj.tableData,'Data');
            cols = size(existingData,2);
            newData = [existingData;repmat({[]},1,cols)];
            set(obj.tableData,'Data',newData);
        end
        %------------------------------------------------------------------
        function deleteRow(obj,~,~)
            % Delete row in table
            if obj.currentIdx(1) ~= 0
                existingData =  get(obj.tableData,'Data');
                existingData(obj.currentIdx(1),:) = [];
                set(obj.tableData,'Data',existingData);
                obj.currentIdx = obj.currentIdx(1) - 1;
            end
        end
        %------------------------------------------------------------------
        function currentSelectedCell(obj,~,e)
            % Get the selected cell.
            
            obj.currentIdx = e.Indices;
        end
        %------------------------------------------------------------------
        function updateTable(obj,~,~)
            % Get the html data.
            newData = obj.plotAxes.Data;
            % Write the new table data.
            if ~iscell([newData.x,newData.y])
                obj.tableData.Data = num2cell([newData.x,newData.y]);
            else
                obj.tableData.Data = [newData.x,newData.y];
            end
            % Change the plot type.
            obj.plotTypes.Value = newData.plotType;
        end
        %------------------------------------------------------------------
        function plotSignal(obj,~,~)
            % Plot pushbutton callback
           
            signalStructure.x = obj.tableData.Data(:,1);
            signalStructure.y = obj.tableData.Data(:,2);
            signalStructure.plotType = obj.plotTypes.Value;
            if ~isempty(signalStructure.x{1})
                % Change the data of uihtml to trigger the listner in html
                % to plot the data.
                obj.plotAxes.Data = signalStructure;
            end
        end
        %------------------------------------------------------------------
        function plotInitVal(obj)
            % Update the plot with init value.
            pause(2);
            if ~isempty(obj.input_data.x)
                obj.plotAxes.Data = obj.input_data;
            end
        end
        %------------------------------------------------------------------
        function closeFig(obj,~,~)
            close(obj.figH);
        end
    end
end