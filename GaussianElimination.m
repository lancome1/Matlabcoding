% Copyright 2023 The University of Texas at Austin
%
% For licensing information see
%                http://www.cs.utexas.edu/users/flame/license.html 
%                                                                                 
% Programmed by: Anni Liu

function [ A_out ] = GaussianElimination( A )

  [ ATL, ATR, ...
    ABL, ABR ] = FLA_Part_2x2( A, ...
                               0, 0, 'FLA_TL' );

  while ( size( ATL, 1 ) < size( A, 1 ) )

    [ A00,  a01,     A02,  ...
      a10t, alpha11, a12t, ...
      A20,  a21,     A22 ] = FLA_Repart_2x2_to_3x3( ATL, ATR, ...
                                                    ABL, ABR, ...
                                                    1, 1, 'FLA_BR' );

    %------------------------------------------------------------%

    a21 = laff_invscal( alpha11, a21 );
    A22 = laff_ger( -1, a21, a12t, A22 );

    %------------------------------------------------------------%

    [ ATL, ATR, ...
      ABL, ABR ] = FLA_Cont_with_3x3_to_2x2( A00,  a01,     A02,  ...
                                             a10t, alpha11, a12t, ...
                                             A20,  a21,     A22, ...
                                             'FLA_TL' );

  end

  A_out = [ ATL, ATR
            ABL, ABR ];

return

% Test the function
% Create a matrix.  (This matrix was carefully chosen so that only integers
% are encountered during the process.)

A = [
     2     0     1     2 
    -2    -1     1    -1 
     4    -1     5     4 
    -4     1    -3    -8 
]

% Perform Gaussian elimination

LU = GaussianElimination( A ) 

% Create a right-hand side.  We are going to solve A x = b

b = [
     2
     2
    11
    -3
]

% Perform forward substitution

bhat = ForwardSubstitution( LU, b )

% Extract the upper triangular matrix from the matrix that resulted from
% Gaussian elminination:

U = triu( LU )

% Solve U x = bhat

x = U \ bhat  

% Check the answer

b - A * x 

