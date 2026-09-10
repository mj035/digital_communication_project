function figure_light(fig)
% 그림을 흰 배경 / 검은 축으로 강제 (보고서 삽입용)
    if nargin < 1, fig = gcf; end
    set(fig, 'Color', 'w');
    axs = findall(fig, 'Type', 'axes');
    for k = 1:numel(axs)
        a = axs(k);
        set(a, 'Color', 'w', 'XColor', 'k', 'YColor', 'k', 'GridColor', [0.15 0.15 0.15]);
        set(get(a,'Title'),  'Color', 'k');
        set(get(a,'XLabel'), 'Color', 'k');
        set(get(a,'YLabel'), 'Color', 'k');
    end
    lg = findall(fig, 'Type', 'legend');
    if ~isempty(lg), set(lg, 'TextColor', 'k', 'Color', 'w'); end
end
