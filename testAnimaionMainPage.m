classdef testAnimaionMainPage < matlab.unittest.TestCase
    methods (Test)
        function testGUI(testCase)
            % Launch animation Gui
            obj = plotApp;
            % present table rows
            existingData =  get(obj.tableData,'Data');
            preSize = size(existingData);
            %% Add row check.
            obj.addRow
            newData =  get(obj.tableData,'Data');
            newSize = size(newData);
            testCase.verifyNotEqual(preSize,newSize);
            %% Delete row check.
            obj.currentIdx = newSize;
            obj.deleteRow
            newData =  get(obj.tableData,'Data');
            newSize = size(newData);
            close(obj.figH)
            testCase.verifyFail(preSize,newSize);  
        end
    end
end


