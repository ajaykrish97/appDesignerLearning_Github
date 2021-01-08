classdef animationExampleMainPage < handle
    % Use gridcontainer to show the image of examples.change the button to
    % mouse hover
    properties
        mainFig;
        mainGrid;
        bouncingBall;
        carDemo;
        roboArmDemo;
        windMillDemo;
    end
    methods
        function obj = animationExampleMainPage
            obj.mainFig = uifigure('Name','Animation Demo Models');
            screenSize = get(0,'screensize');
            set(obj.mainFig,'Units','Pixels','Position',[0.1*screenSize(3) 0.1*screenSize(4) 0.8*screenSize(3) 0.8*screenSize(4)]);
            movegui(obj.mainFig,'center');
            obj.mainGrid = uigridlayout(obj.mainFig,[3,2]);
            obj.mainGrid.RowHeight = {30,'1x','1x'};
            obj.mainGrid.ColumnWidth = {'1x','1x'};
            % Animation Example Label.
            animationlabel = uilabel('parent',obj.mainGrid,'text','Animation Demo Models','FontSize',18,'FontWeight','Bold','FontAngle','Italic','HorizontalAlignment','center');
            animationlabel.Layout.Row = 1;
            animationlabel.Layout.Column = [1,2];
            % Use uihtml in each grid.
            obj.bouncingBall = uihtml('parent',obj.mainGrid,'HTMLSource',[pwd '\animationModelImg.html']);
            obj.bouncingBall.Data = 'sldemo_bounce';
            obj.bouncingBall.DataChangedFcn = @(src,event)open_system('sldemo_bounce');
            obj.carDemo = uihtml('parent',obj.mainGrid,'HTMLSource',[pwd '\animationModelImg.html']);
            obj.carDemo.Data = 'sim_autotrans';
            obj.carDemo.DataChangedFcn = @(src,event)open_system('sim_autotrans');
            obj.roboArmDemo = uihtml('parent',obj.mainGrid,'HTMLSource',[pwd '\animationModelImg.html']);
            obj.roboArmDemo.Data = 'roboArm';
            obj.roboArmDemo.DataChangedFcn = @(src,event)open_system('roboArm');
            obj.windMillDemo = uihtml('parent',obj.mainGrid,'HTMLSource',[pwd '\animationModelImg.html']);
            obj.windMillDemo.Data = 'windTurbine';
            obj.windMillDemo.DataChangedFcn = @(src,event)open_system('windTurbine');
        end
    end
end