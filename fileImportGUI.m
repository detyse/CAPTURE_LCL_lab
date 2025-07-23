function fileImportGUI
    % GUI: 选择 CSV / XLSX 并显示在表格
    fig = uifigure('Name','文件导入示例','Position',[100 100 620 380]);
    gl  = uigridlayout(fig,[3 1]);              % 三行布局
    gl.RowHeight = {40, '1x', 25};
    
    % 顶部控件
    btn = uibutton(gl,'Text','选择文件','ButtonPushedFcn',@onChoose);
    lbl = uilabel(gl,'Text','未选择文件','HorizontalAlignment','center');
    
    % 中间表格
    tbl = uitable(gl,'Data',{},'ColumnEditable',true);
    
    % 底部状态栏
    status = uilabel(gl,'Text','准备就绪','HorizontalAlignment','left');
    
    % ---------- 回调函数 ----------
    function onChoose(~,~)
        [f,p] = uigetfile({'*.csv;*.xlsx','表格数据';'*.*','所有文件'},'请选择文件');
        if isequal(f,0); return; end
        fullpath = fullfile(p,f);
        lbl.Text = fullpath;

        try
            T = readtable(fullpath);
            tbl.Data       = T;
            tbl.ColumnName = T.Properties.VariableNames;
            status.Text = sprintf('已加载 %d 行 × %d 列',height(T),width(T));
        catch ME
            uialert(fig, ME.message, '读取失败');
            status.Text = '读取失败';
        end
    end
end