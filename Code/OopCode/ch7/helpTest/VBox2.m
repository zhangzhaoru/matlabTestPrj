f = figure();
b1 = uiextras.VBox( 'Parent', f );
b2 = uiextras.HBox( 'Parent', b1, 'Padding', 5, 'Spacing', 5 );
uicontrol( 'Style', 'frame', 'Parent', b1, 'Background', 'r' )
uicontrol( 'Parent', b2, 'String', 'Button1' )
uicontrol( 'Parent', b2, 'String', 'Button2' )
set( b1, 'Sizes', [30 -1] );