classdef MinHeap < Heap
%--------------------------------------------------------------------------
% Class:        MinHeap < Heap (& handle)
%               
% Constructor:  H = MinHeap(n);
%               H = MinHeap(n,x0);
%               
% Properties:   (none)
%               
% Methods:                 H.InsertKey(key);
%               sx       = H.Sort();
%               min      = H.ReturnMin();
%               min      = H.ExtractMin();
%               count    = H.Count();
%               capacity = H.Capacity();
%               bool     = H.IsEmpty();
%               bool     = H.IsFull();
%                          H.Clear();
%               
% Description:  This class implements a min-heap of numeric keys
%--------------------------------------------------------------------------

    %
    % Public methods
    %
    methods (Access = public)
        %
        % Constructor
        %
        function this = MinHeap(varargin)
            %----------------------- Constructor --------------------------
            % Syntax:       H = MinHeap(n);
            %               H = MinHeap(n,x0);
            %               
            % Inputs:       n is the maximum number of keys that H can hold
            %               
            %               x0 is a vector (of length <= n) of numeric keys
            %               to insert into the heap during initialization
            %               
            % Description:  Creates a min-heap with capacity n
            %--------------------------------------------------------------
            
            % Call base class constructor
            this = this@Heap(varargin{:});
            
            % Construct the min heap
            this.BuildMinHeap();
        end
        
        %
        % Insert key
        %
        function InsertKey(this,key)
            %------------------------ InsertKey ---------------------------
            % Syntax:       H.InsertKey(key);
            %               
            % Inputs:       key is a number
            %               
            % Description:  Inserts key into H
            %--------------------------------------------------------------
            
            this.SetLength(this.k + 1);
            this.x(this.k) = inf;
            this.DecreaseKey(this.k,key);
        end
        
        %
        % Sort the heap
        %
        function sx = Sort(this)
            %-------------------------- Sort ------------------------------
            % Syntax:       sx = H.Sort();
            %               
            % Outputs:      sx is a vector taht contains the sorted
            %               (ascending order) keys in H
            %               
            % Description:  Returns the sorted values in H
            %--------------------------------------------------------------
            
            % Sort the heap
            nk = this.k; % virtual heap size during sorting procedure
            for i = this.k:-1:2
                this.Swap(1,i);
                nk = nk - 1;
                this.MinHeapify(1,nk);
            end
            this.x(1:this.k) = flipud(this.x(1:this.k));
            sx = this.x(1:this.k);
        end
        
        %
        % Return minimum element
        %
        function min = ReturnMin(this)
            %------------------------ ReturnMin ---------------------------
            % Syntax:       min = H.ReturnMin();
            %               
            % Outputs:      min is the minimum key in H
            %               
            % Description:  Returns the minimum key in H
            %--------------------------------------------------------------
            
            if (this.IsEmpty() == true)
                min = [];
            else
                min = this.x(1);
            end
        end
        
        %
        % Extract minimum element
        %
        function min = ExtractMin(this)
            %------------------------ ExtractMin --------------------------
            % Syntax:       min = H.ExtractMin();
            %               
            % Outputs:      min is the minimum key in H
            %               
            % Description:  Returns the minimum key in H and extracts it
            %               from the heap
            %--------------------------------------------------------------
            
            this.SetLength(this.k - 1);
            min = this.x(1);
            this.x(1) = this.x(this.k + 1);
            this.MinHeapify(1);
        end
    end
    
    %
    % Private methods
    %
    methods (Access = private)
        %
        % Decrease key at index i
        %
        function DecreaseKey(this,i,key)
            if (i > this.k)
                % Index overflow error
                MinHeap.IndexOverflowError();
            elseif (key > this.x(i))
                % Decrease key error
                MinHeap.DecreaseKeyError();
            end
            this.x(i) = key;
            while ((i > 1) && (this.x(Heap.parent(i)) > this.x(i)))
                this.Swap(i,Heap.parent(i));
                i = Heap.parent(i);
            end
        end
        
        %
        % Build the min heap
        %
        function BuildMinHeap(this)
            for i = floor(this.k / 2):-1:1
                this.MinHeapify(i);
            end
        end
        
        %
        % Maintain the min heap property at a given node
        %
        function MinHeapify(this,i,size)
            % Parse inputs
            if (nargin < 3)
                size = this.k;
            end
            
            ll = Heap.left(i);
            rr = Heap.right(i);
            if ((ll <= size) && (this.x(ll) < this.x(i)))
                smallest = ll;
            else
                smallest = i;
            end
            if ((rr <= size) && (this.x(rr) < this.x(smallest)))
                smallest = rr;
            end
            if (smallest ~= i)
                this.Swap(i,smallest);
                this.MinHeapify(smallest,size);
            end
        end
    end
    
    %
    % Private static methods
    %
    methods (Access = private, Static = true)
        %
        % Decrease key error
        %
        function DecreaseKeyError()
            error('You can only decrease keys in MinHeap');
        end
        
        %
        % Index overflow error
        %
        function IndexOverflowError()
            error('MinHeap index overflow');
        end
    end
end
