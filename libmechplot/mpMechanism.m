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
        
        % Plot options:
        keep_axis_limits = 0; % If set to 1, will leave the axis limits exactly as they were before starting to draw the structure
        bg_color = []; % if set to an [R G B] color, will change the background of the current figure (gcf) 
        
        % Options for saving animations as sequences of images:
        save_images = 0;  % Set to 1 to enable image saving (at the end of each call to .plot())
        save_image_filenames = 'mechplot_%03d.png';
        save_images_next_idx = 0; % The image index for "save_image_filenames" (automatically incremented)
    end
    
    properties(GetAccess=public, SetAccess=private)
       problemMaxDim = 0; % The largest length between two elements in the structure. Cached and only computed once upon first call to updateLargestProblemDimension()
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
            me.problemMaxDim= 0;
        end

        %% ==== RENDER ===
        % Renders the mechanical structure into the current figure, 
        % given some "q" coordinates.
        function plot(me, q)
            me.updateLargestProblemDimension(q);
            
            % Prepare drawing figure:
            set(gcf,'DoubleBuffer','on'); 
            if (me.keep_axis_limits)
                old_axis = axis;
            end
            cla; axis normal;
            hold on; box on;
            
            if (length(me.bg_color)==3)
                set(gcf,'Color',me.bg_color);
            end            
            
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
            if (me.keep_axis_limits)
                axis(old_axis);
            else
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
            end
            
            % Update window:            
            drawnow expose update;
            
            % Save images to disk?
            if (me.save_images)
                me.do_save_image();
            end
                
        end % end of plot
        %% End of render
        
        % Saves the current contents of gcf() as an image, according to 
        % the properties "save_image_filenames" and "save_images_next_idx"
        function do_save_image(me)
            I = getframe(gcf);
            
            sFil = sprintf(me.save_image_filenames,me.save_images_next_idx);            
            [~,~,ext] = fileparts(sFil);
            if (strcmpi(ext,'.gif'))
                % Convert to 256 color image:
                [imind,cm] = rgb2ind(frame2im(I),256);
                imwrite(imind,cm,sFil,'gif');
            else
                % Save RGB image:
                imwrite(I.cdata, sFil);
            end
            me.save_images_next_idx=me.save_images_next_idx+1;
        end
        
        % Reset the cached structure dimension, used to automatically size
        % many elements when drawing.
        function resetLargestProblemDimension(me)
            me.problemMaxDim=0;
        end

    end
    
    methods(Access=private)
        % Get the cached structure dimension, used to automatically size
        % many elements when drawing.
        function updateLargestProblemDimension(me,q)
            if (me.problemMaxDim==0)
                me.problemMaxDim = max([me.q_fixed(:); q(:)])-min([me.q_fixed(:);q(:)]);
            end
        end
    end
    
end

