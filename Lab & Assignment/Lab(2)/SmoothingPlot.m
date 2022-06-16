function SmoothingPlot(global_table, global_smooth_table, global_table_col, global_smooth_table_col)

figure;
hold on
plot(global_table.Date, global_table_col)
plot(global_smooth_table.Date, global_smooth_table_col)
hold off
xlabel('Time');     ylabel('Feature Value');     legend('Before smoothing', 'After smoothing')

end
