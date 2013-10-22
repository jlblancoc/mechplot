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
    
    properties(GetAccess=public, SetAccess=private)
       problemMaxDim; 
    end
    
    %% Public methods:
    methods(Access=public)
        % Add a new object (link, ground, etc.) to the mechanism.
        function add(obj, new_element)
            obj.objects{end+1}=new_element;
        end
        
        % Reset this object to an empty state
        function clear(me)
            me.objects = {};
            me.q_fixed = [];
            me.draw_options = struct();                        
            me.problemMaxDim=1.0;
        end

        %% ==== RENDER ===
        % Renders the mechanical structure into the current figure, 
        % given some "q" coordinates.
        function plot(me, q)
            me.updateLargestProblemDimension(q);
            
            % Prepare drawing figure:
            set(gcf,'DoubleBuffer','on'); 
            clf;
            hold on;
            box on;
            
            % Sort by ascending "z_order" property:
            nObjs = length(me.objects);
            zs=zeros(nObjs,1);
            for i=1:nObjs, zs(i)=me.objects{i}.z_order;end
            [~, idxs]=sort(zs);

            % Render objects:
            for i=1:nObjs,
                me.objects{idxs(i)}.draw(q,me);
            end

            %% Finish drawing figure:
            % Leave a larger margin:
            axis equal;
            a=axis; 
            cx=0.5*(a(2)+a(1));
            cy=0.5*(a(4)+a(3));
            W=a(2)-a(1);
            H=a(4)-a(3);
            extraMarginFactor = 1.10;
            W=W*extraMarginFactor; H=H*extraMarginFactor;
            axis([cx-0.5*W cx+0.5*W cy-0.5*H cy+0.5*H]);
            
            % Update window:            
            drawnow expose update;
            
        end % end of plot
        %% End of render
        

    end
    
    methods(Access=private)
        function updateLargestProblemDimension(me,q)
            me.problemMaxDim = max([me.q_fixed(:); q(:)])-min([me.q_fixed(:);q(:)]);
        end
    end
    
end

