function Signal__assert_mine(Signal)
%Asserts that the signal is a TEAPhysio one
% Inputs:
%  Signal: the signal to test
%
%Copyright Frank Villaro-Dixon, BSD Simplified, 2014

if(nargin ~= 1)
	error('Usage: Signal__assert_mine(Signal)');
end

%TODO: implement the display of a bulk ?
if(length(Signal) == 1) %Avoid multiple bulk case for instance
    if(isfield(Signal, 'TEAPhysio'))
        if(Signal.TEAPhysio == 'S')
            return;
        end
    end
end

error('The signal given is not a TEAPhysio one')

%!error(Signal__assert_mine(42))
%!error(Signal__assert_mine())

