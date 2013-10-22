classdef mpMechanism  < handle
    %MPMECHANISM Class that represents a mechanism or mechanical structure.
    %   
    %
    % Mechplot (C) 2013 Jose Luis Blanco - University of Almeria
    % License: GNU GPL 3. Docs online: https://github.com/jlblancoc/mechplot
    
    
    %% Constructor
    methods
        function s = mpMechanism()
            s.clear();
        end
    end
    
    %% Properties
    properties(GetAccess=public, SetAccess=public)
        objects;
        q_fixed;
        draw_options;
    end
    
    %% Public methods:
    methods(Access=public)
        % Add a new object (link, ground, etc.) to the mechanism.
        function add(obj, new_element)
            obj.objects{end+1}=new_element;
        end
        
        % Reset this object to an empty state
        function clear(obj)
            obj.objects = {};
            obj.q_fixed = [];
            obj.draw_options = struct();                        
        end

        %% ==== RENDER ===
        % Renders the mechanical structure into the current figure, 
        % given some "q" coordinates.
        function plot(obj, q)
            % Prepare drawing figure:
            set(gcf,'DoubleBuffer','on'); 
            clf;
            hold on;

            % Render objects:
            nObjs = length(obj.objects);
            for i=1:nObjs,
                obj.objects{i}.draw(q,obj);
            end

            % Finish drawing figure:
            axis equal;
            drawnow expose update;
            
        end
        %% End of render
    end
    
end

