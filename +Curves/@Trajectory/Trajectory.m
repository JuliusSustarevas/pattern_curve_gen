classdef Trajectory < handle

    properties
        data% is a 4x4xn transoforms
        t% nx1 time vector
    end

    methods

        function self = Trajectory(path, speed, speed_density)
            [path, t] = self.path2time(path, speed, speed_density);
            self.data = self.path2TForms(path);
            self.t = t;
        end

        function plot(self, frame_density)
            Helpers.trajectory_plot(self.data, self.t, frame_density)
        end

        function plot_path(self)
            import Helpers.*
            h = path_plot(squeeze(self.data(1:3, 4, :))');
        end

        function superimpose(self, path)
            %will round  trajectory to multiples of  path lengths
            p_l = max(path.path(:, 1));
            l = self.get_cuml();

            pattern_func = path()

        end

        function cl = get_cuml(self)
            d = diff(squeeze(self.data(1:3, 4, :))');
            cl = [0; cumsum(sqrt(sum(d.^2, 2)))];
        end

    end

    methods (Static)

        function data = path2TForms(path)
            n = length(path.path);
            ax = diff(path.path, 1);
            ax = [ax; ax(end, :)];

            %For trajectories made from 2d paths, assume Z only rotation
            ex = zeros(n, 1);
            ey = zeros(n, 1);
            ez = atan2(ax(:, 2), ax(:, 1));
            rotm = eul2rotm([ez, ey, ex], "ZYX");
            data = rotm2tform(rotm);
            data(1, 4, :) = path.path(:, 1);
            data(2, 4, :) = path.path(:, 2);
            data(3, 4, :) = path.path(:, 3);
        end

        function [path, t] = path2time(path, speed, speed_density)
            path.set_density(speed_density * speed);
            t = 0:speed_density:length(path.path)';
        end

    end

end